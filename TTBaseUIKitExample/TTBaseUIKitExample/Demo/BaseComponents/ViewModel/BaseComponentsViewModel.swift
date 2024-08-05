//
//  BaseComponentsViewModel.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 31/7/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit

class BaseComponentsViewModel {
    
      fileprivate lazy var isFetching:Bool = false
      
      var willShowLoading:( () -> () )?
      var willRemoveLoading:( () -> () )?

      var willShowSkeletonAnimation:( () -> () )?
      var willRemoveSkeletonAnimation:( () -> () )?
      
      var willRefreshData:( (_ vm:BaseComponentsViewModel) -> () )?
      var willShowMessage:( (_ mess:ResponseMessage) -> () )?
}

//MARK:// For Base funcs
extension BaseComponentsViewModel {
    
}

//MARK:// For API config
extension BaseComponentsViewModel {
    
    fileprivate func onFetchData() {
        if self.isFetching { return } ; self.isFetching = true
        self.willShowLoading?()
        
    }
}
