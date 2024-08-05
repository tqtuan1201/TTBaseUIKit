//
//  DemoViewModel.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/7/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit


class DemoViewModel {
    
      fileprivate lazy var isFetching:Bool = false
      
      var willShowLoading:( () -> () )?
      var willRemoveLoading:( () -> () )?

      var willShowSkeletonAnimation:( () -> () )?
      var willRemoveSkeletonAnimation:( () -> () )?
      
      var willRefreshData:( (_ vm:DemoViewModel) -> () )?
      var willShowMessage:( (_ mess:ResponseMessage) -> () )?
}

//MARK:// For Base funcs
extension DemoViewModel {
    
}

//MARK:// For API config
extension DemoViewModel {
    
    fileprivate func onFetchData() {
        if self.isFetching { return } ; self.isFetching = true
        self.willShowLoading?()
        
    }
}
