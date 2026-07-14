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

// MARK: - QR Scanner View (iOS 14+)
/// Presents a live camera preview and calls `onCodeScanned` the first time a QR code is
/// detected. Caller is responsible for dismissing the view after handling the result.
@available(iOS 14.0, *)
public struct QRScannerView: View {
    public var onCodeScanned: (String) -> Void
    /// `presentationMode` (not `@Environment(\.dismiss)`) — this module's DebugBridge
    /// views target iOS 14+, and `\.dismiss` requires iOS 15.
    @Environment(\.presentationMode) private var presentationMode
    @State private var torchOn = false

    public init(onCodeScanned: @escaping (String) -> Void) {
        self.onCodeScanned = onCodeScanned
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
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white.opacity(0.9))
                    }
                    Spacer()
                    Button(action: { torchOn.toggle() }) {
                        Image(systemName: torchOn ? "bolt.fill" : "bolt.slash.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                .padding()

                Spacer()

                Text("Scan the QR code from TTBDebugPlus → Connection Health")
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
                        self.showPermissionDeniedMessage()
                    }
                }
            }
        default: // .denied, .restricted
            showPermissionDeniedMessage()
        }
    }

    private func setupCaptureSession() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            showPermissionDeniedMessage()
            return
        }
        session.addInput(input)

        let output = AVCaptureMetadataOutput()
        guard session.canAddOutput(output) else { return }
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: .main)
        output.metadataObjectTypes = [.qr]

        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = .resizeAspectFill
        preview.frame = view.bounds
        view.layer.addSublayer(preview)
        previewLayer = preview
    }

    private func showPermissionDeniedMessage() {
        let label = UILabel()
        label.text = "Camera access is required to scan the pairing QR code.\nEnable it in Settings → Privacy → Camera."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -32)
        ])
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
