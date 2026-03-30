//
//  BaseColllectionViewViewController.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 31/7/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit


class BaseCustomFlowLayoutColllectionViewController: BaseUIViewController {
    
    
    override var lgNavType: BaseUINavigationView.TYPE { return .DETAIL}
    override var navType: TTBaseUIViewController<DarkBaseUIView>.NAV_STYLE { return .STATUS_NAV}
    override var isSetHiddenTabar: Bool { return true }
    
    fileprivate let ITEM_HEIGHT:CGFloat = (Device.size() <= .screen4_7Inch ? 230.0 : 255.0) + XSize.P_CONS_DEF * 2
    
    lazy var collectionView:TTBaseUICollectionView =  {
        
        let layout = AutoSizingFlowLayout()
        
        collectionView = TTBaseUICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AutoSizingCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    fileprivate var viewModel:BaseColllectionViewViewModel = BaseColllectionViewViewModel()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewCodable(with: [self.collectionView])
    }
    
}


// MARK://TTViewCodable bindViewModel
extension BaseCustomFlowLayoutColllectionViewController {
    
    func bindComponents() {
        
    }
    
    func bindViewModel() {
        
        self.viewModel.willShowLoading  = { [weak self] in guard let strongSelf = self else { return }
            DispatchQueue.main.async { strongSelf.showLoadingView(type: .TAB_TOP)}
        }
        
        self.viewModel.willRemoveLoading  = { [weak self] in guard let strongSelf = self else { return }
            DispatchQueue.main.async { strongSelf.removeLoading() }
        }
        
        self.viewModel.willShowMessage = { [weak self] mess in guard let strongSelf = self else { return }
            let stype:TTBaseNotificationViewConfig.NOTIFICATION_TYPE = mess.onCheckSuccess() ? .SUCCESS : .ERROR
            strongSelf.showNoticeView(body: mess.getDes(), style: stype)
        }
    }
}


// MARK://TTViewCodable Setup UIView
extension BaseCustomFlowLayoutColllectionViewController : TTViewCodable {
    
    func setupData() {
        self.setTitleNav("AUTOSIZINGCELL COLLECTION".uppercased())
    }
    func setupCustomView() {
        
    }
    
    func setupStyles() {
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: TTSize.P_CONS_DEF, right: 0)
        self.collectionView.setBgColor(color: UIColor.clear)
        self.view.backgroundColor = UIColor.white
    }
    
    func setupConstraints() {
        self.collectionView.setLeadingAnchor(constant: XSize.P_CONS_DEF).setTrailingAnchor(constant: XSize.P_CONS_DEF)
            .setTopAnchor(constant: XSize.getHeightNavWithStatus() + XSize.P_CONS_DEF ).setBottomAnchor(constant: XSize.P_CONS_DEF, isMarginsGuide: true)
    }
}


//MARK:// For CollectionView - UICollectionViewDataSource
extension BaseCustomFlowLayoutColllectionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 0)
    }

    // Set footer height to 0
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return XSize.P_CONS_DEF
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AutoSizingCell
        let text = "Sample text for item \(self.viewModel.items.randomElement()!). This text can vary in length."
        cell.nameLabel.setText(text: text)
        cell.priveLabel.setText(text: self.viewModel.items[indexPath.row])
        return cell
    }
}
