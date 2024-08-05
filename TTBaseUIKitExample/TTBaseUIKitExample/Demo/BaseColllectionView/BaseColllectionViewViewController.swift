//
//  BaseColllectionViewViewController.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 31/7/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit

class BaseColllectionViewViewController: BaseUIViewController {
    
    
    override var lgNavType: BaseUINavigationView.TYPE { return .DETAIL}
    override var navType: TTBaseUIViewController<DarkBaseUIView>.NAV_STYLE { return .STATUS_NAV}
    override var isSetHiddenTabar: Bool { return true }
    
    fileprivate let ITEM_HEIGHT:CGFloat = (Device.size() <= .screen4_7Inch ? 230.0 : 255.0) + XSize.P_CONS_DEF * 2
    
    lazy var collectionView:TTBaseUICollectionView =  {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.minimumLineSpacing = XSize.P_CONS_DEF * 2
        layout.minimumInteritemSpacing = XSize.P_CONS_DEF * 2
        
        let v = TTBaseUICollectionView(collectionViewLayout: layout, bgColor: .clear, isShowCroll: false, isSetContent: false)
        v.delegate = self
        v.dataSource = self
        v.register(DemoBaseUICollectionViewCell.self)
        v.keyboardDismissMode = .onDrag
        return v
    }()
    
    fileprivate var viewModel:BaseColllectionViewViewModel = BaseColllectionViewViewModel()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewCodable(with: [self.collectionView])
    }
    
}


// MARK://TTViewCodable bindViewModel
extension BaseColllectionViewViewController {
    
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
        
        self.viewModel.willRefreshData = { [weak self] vm in guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                
            }
        }
    }
}


// MARK://TTViewCodable Setup UIView
extension BaseColllectionViewViewController : TTViewCodable {
    
    func setupData() {
        self.setTitleNav("Base ColllectionView".uppercased())
    }
    func setupCustomView() {
        
    }
    
    func setupStyles() {
        
    }
    
    func setupConstraints() {
        self.collectionView.setLeadingAnchor(constant: XSize.P_CONS_DEF).setTrailingAnchor(constant: XSize.P_CONS_DEF)
            .setTopAnchor(constant: XSize.getHeightNavWithStatus() + XSize.P_CONS_DEF).setBottomAnchor(constant: XSize.P_CONS_DEF, isMarginsGuide: true)
    }
}


//MARK:// For CollectionView - UICollectionViewDataSource
extension BaseColllectionViewViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeToday = CGSize(width: collectionView.frame.width / 2 - XSize.H_LINEVIEW * 2, height: self.ITEM_HEIGHT)
        return sizeToday
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return XSize.H_LINEVIEW * 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:DemoBaseUICollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.nameLabel.setText(text: self.viewModel.items[indexPath.row])
        cell.priveLabel.setText(text: ["TTBaseUIKit","TTBaseUIKit UIKit","TTBaseUIKit SwiftUI"].randomElement() ?? "TTBaseUIKit")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.showNoticeView(body: self.viewModel.items[indexPath.row])
    }

}
