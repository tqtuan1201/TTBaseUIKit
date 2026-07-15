//
//  QRScannerView.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 2026-07-13.
//  Camera-based QR scanner for pairing with TTBDebugPlus — scans the
//  `ttbdebug://<host>:<port>` code shown in the macOS app's Connection Health tab.
//

#if canImport(SwiftUI) && canImport(AVFoundation)
import SwiftUI
import AVFoundation
import UIKit

// MARK: - QR Scanner View (iOS 14+)
/// Presents a live camera preview and calls `onCodeScanned` the first time a QR code is
/// detected. Caller is responsible for dismissing the view after handling the result
/// (this view also dismisses itself after a successful scan).
@available(iOS 14.0, *)
public struct QRScannerView: View {
    public var onCodeScanned: (String) -> Void
    /// Optional: called when the user cancels (close button). Scanner also dismisses itself.
    public var onCancel: (() -> Void)?
    /// `presentationMode` (not `@Environment(\.dismiss)`) — this module's DebugBridge
    /// views target iOS 14+, and `\.dismiss` requires iOS 15.
    @Environment(\.presentationMode) private var presentationMode
    @State private var torchOn = false

    public init(onCodeScanned: @escaping (String) -> Void, onCancel: (() -> Void)? = nil) {
        self.onCodeScanned = onCodeScanned
        self.onCancel = onCancel
    }

    public var body: some View {
        ZStack {
            QRScannerRepresentable(torchOn: torchOn) { code in
                onCodeScanned(code)
                presentationMode.wrappedValue.dismiss()
            }
            .ignoresSafeArea()

            VStack {
                HStack {
                    Button(action: {
                        onCancel?()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white.opacity(0.9))
                            .accessibilityLabel("Close scanner")
                    }
                    Spacer()
                    Button(action: { torchOn.toggle() }) {
                        Image(systemName: torchOn ? "bolt.fill" : "bolt.slash.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white.opacity(0.9))
                            .accessibilityLabel(torchOn ? "Turn torch off" : "Turn torch on")
                    }
                }
                .padding()

                Spacer()

                Text("Scan the QR code from TTBDebugPlus → Connection Health or Settings → Relay")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
            }
        }
        .background(Color.black)
    }
}

// MARK: - UIViewControllerRepresentable bridge

@available(iOS 14.0, *)
private struct QRScannerRepresentable: UIViewControllerRepresentable {
    var torchOn: Bool
    var onCodeScanned: (String) -> Void

    func makeUIViewController(context: Context) -> QRScannerViewController {
        let vc = QRScannerViewController()
        vc.onCodeScanned = onCodeScanned
        return vc
    }

    func updateUIViewController(_ uiViewController: QRScannerViewController, context: Context) {
        uiViewController.setTorch(on: torchOn)
    }
}

// MARK: - Capture Controller

@available(iOS 14.0, *)
final class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var onCodeScanned: ((String) -> Void)?
    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var didEmit = false
    private var deniedContainer: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configureSession()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !session.isRunning, !session.inputs.isEmpty else { return }
        DispatchQueue.global(qos: .userInitiated).async { [session] in
            session.startRunning()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard session.isRunning else { return }
        session.stopRunning()
    }

    // MARK: - Session Setup (permission-gated)

    private func configureSession() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    guard let self else { return }
                    if granted {
                        self.setupCaptureSession()
                        guard self.viewIfLoaded?.window != nil, !self.session.inputs.isEmpty else { return }
                        DispatchQueue.global(qos: .userInitiated).async { [session = self.session] in
                            session.startRunning()
                        }
                    } else {
                        self.showPermissionDeniedUI()
                    }
                }
            }
        default: // .denied, .restricted
            showPermissionDeniedUI()
        }
    }

    private func setupCaptureSession() {
        deniedContainer?.removeFromSuperview()
        deniedContainer = nil

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            showPermissionDeniedUI(cameraUnavailable: true)
            return
        }
        // Avoid double-adding if configure is called twice after permission grant.
        if session.inputs.isEmpty {
            session.addInput(input)
        }

        if session.outputs.isEmpty {
            let output = AVCaptureMetadataOutput()
            guard session.canAddOutput(output) else { return }
            session.addOutput(output)
            output.setMetadataObjectsDelegate(self, queue: .main)
            output.metadataObjectTypes = [.qr]
        }

        if previewLayer == nil {
            let preview = AVCaptureVideoPreviewLayer(session: session)
            preview.videoGravity = .resizeAspectFill
            preview.frame = view.bounds
            view.layer.insertSublayer(preview, at: 0)
            previewLayer = preview
        }
    }

    /// Optimized empty state: icon, clear copy, Open Settings + Retry.
    private func showPermissionDeniedUI(cameraUnavailable: Bool = false) {
        deniedContainer?.removeFromSuperview()

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        deniedContainer = container

        let icon = UIImageView(image: UIImage(systemName: cameraUnavailable ? "camera.fill" : "camera.metering.unknown"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = UIColor.white.withAlphaComponent(0.85)
        icon.contentMode = .scaleAspectFit
        icon.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 44, weight: .medium)

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = cameraUnavailable ? "Camera Unavailable" : "Camera Access Needed"
        title.textAlignment = .center
        title.textColor = .white
        title.font = .systemFont(ofSize: 20, weight: .semibold)

        let body = UILabel()
        body.translatesAutoresizingMaskIntoConstraints = false
        body.numberOfLines = 0
        body.textAlignment = .center
        body.textColor = UIColor.white.withAlphaComponent(0.85)
        body.font = .systemFont(ofSize: 15, weight: .regular)
        if cameraUnavailable {
            body.text = "This device cannot use the camera for QR pairing. Use Debug Bridge → Enter IP instead."
        } else {
            body.text = "Allow camera access to scan the TTBDebugPlus pairing QR code.\nSettings → Privacy & Security → Camera → enable for this app."
        }

        let openSettings = UIButton(type: .system)
        openSettings.translatesAutoresizingMaskIntoConstraints = false
        openSettings.setTitle("Open Settings", for: .normal)
        openSettings.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        openSettings.setTitleColor(.white, for: .normal)
        openSettings.backgroundColor = UIColor.systemBlue
        openSettings.layer.cornerRadius = 12
        openSettings.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        openSettings.addTarget(self, action: #selector(openAppSettings), for: .touchUpInside)
        openSettings.isHidden = cameraUnavailable
        openSettings.accessibilityLabel = "Open Settings to enable camera"

        let retry = UIButton(type: .system)
        retry.translatesAutoresizingMaskIntoConstraints = false
        retry.setTitle("Try Again", for: .normal)
        retry.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        retry.setTitleColor(UIColor.white.withAlphaComponent(0.9), for: .normal)
        retry.addTarget(self, action: #selector(retryPermission), for: .touchUpInside)
        retry.isHidden = cameraUnavailable
        retry.accessibilityLabel = "Try camera access again"

        let stack = UIStackView(arrangedSubviews: [icon, title, body, openSettings, retry])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.setCustomSpacing(20, after: body)
        stack.setCustomSpacing(8, after: openSettings)
        container.addSubview(stack)

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            icon.widthAnchor.constraint(equalToConstant: 56),
            icon.heightAnchor.constraint(equalToConstant: 56),

            openSettings.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            openSettings.widthAnchor.constraint(greaterThanOrEqualToConstant: 200),

            stack.topAnchor.constraint(equalTo: container.topAnchor),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }

    @objc private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    @objc private func retryPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if status == .authorized {
            deniedContainer?.removeFromSuperview()
            deniedContainer = nil
            setupCaptureSession()
            guard !session.inputs.isEmpty else { return }
            DispatchQueue.global(qos: .userInitiated).async { [session] in
                if !session.isRunning { session.startRunning() }
            }
        } else if status == .notDetermined {
            configureSession()
        } else {
            // Still denied — send user to Settings rather than a dead end.
            openAppSettings()
        }
    }

    // MARK: - Torch

    func setTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
        try? device.lockForConfiguration()
        device.torchMode = on ? .on : .off
        device.unlockForConfiguration()
    }

    // MARK: - AVCaptureMetadataOutputObjectsDelegate

    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard !didEmit,
              let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              object.type == .qr,
              let value = object.stringValue else { return }
        didEmit = true
        session.stopRunning()
        onCodeScanned?(value)
    }
}
#endif
