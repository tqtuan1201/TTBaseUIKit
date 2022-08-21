//
//  Constant.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/6/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

public struct CONSTANT {
    
    public enum LOADING_TYPE {
        case VIEW_CENTER
        case TAB_TOP
        case NAV_BUTTOM
    }
    
    public enum POSITION_VIEW : CGFloat {
        case SKELETON_LAYER = 50.0
        case EFFECT_VIEW = 200.0
        case NAV_VIEW = 300.0
        case NOTIFICATION_VIEW = 299.0
        case LOADING_VIEW = 8000.0
    }

    public enum TAG_VIEW : Int {
        case LOADING = -111
        
        case MARK_SKELETON = -112
        case LABEL_SKELETON = -113
        case BUTTON_SKELETON = -114
        case IMAGE_SKELETON = -115
        case WKWEB_VIEW_SKELETON = -116
        case WARNING_VIEW = -117
        case LOADING_DESCRIPTIONVIEW = -118
        
        case BG_UISTACKVIEW = 100
        case NOTIFICATION_VIEW = 101
    }
    
    public enum FORMAT_DATE : String {
        case ID                     = "dd.MM.yyyy_HH.mm.ss"
        case YYYY_MM_DD             = "yyyy-MM-dd"
        case DD_MM_YYYY             = "dd/MM/yyyy"
        case DD_MM_YY               = "dd/MM/YY"
        case DDMMYYYY               = "ddMMyyyy"
        case YYYYMMDD               = "yyyyMMdd"
        case YYYYMM                 = "yyyyMM"
        case DDMM                   = "dd/MM"
        case DDMM_HH_MM_A                 = "dd/MM hh:mm a"
        case DD_MM_YYYY_HH_MM       = "dd/MM/yyyy HH:mm"
        case DD_MM_YYYY_HH_MM_SS    = "dd/MM/yyyy HH:mm:ss"
        case DD_MM_YYYY_HH_MM_A     = "dd/MM/yyyy hh:mm a"
        case YYYY_MM_DD_HH_MM_SS    = "yyyy-MM-dd HH:mm:ss"
        case YYYY_MM_DD_T_HH_MM_SS  = "yyyy-MM-dd'T'HH:mm:ss"
        case YYYY_MM_DD_T_HH_MM_SS_Z = "yyyy-MM-dd'T'HH:mm:ssZ"
        case YYYY_MM_DD_T_HH_MM_SSSSSS_Z = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        case YYYY_MM_DD_T_HH_MM_SSSS_Z = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        case YYYY_MM_DD_T_HH_MM_SSS_Z = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case YYYY_MM_DD_T_HH_MM_S_Z = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        case HH_MM_DD_MM_YYYY       = "HH:mm dd/MM/yyyy"
        case YYYY_MM_DD_HH_MM       = "yyyy-MM-dd HH:mm"
        case HH_MM                  = "HH:mm"
        case MMMYYYY                = "MMM, yyyy"
        case MMMMYYYY                = "MMMM, yyyy"
        case MMM                    = "MMM"
        case DD_MM_HH_MM            = "dd/MM HH:mm"
        case MMM_D_YYYY             = "MMM d, yyyy"
        case MMM_D                  = "MMM d"
        case D_MMM                  = "d MMM"
        case D_MMMM                 = "d MMMM"
        case HH_MM_A                = "hh:mm a"
        case MMMM                   = "MMMM"
        case EEEE                   = "EEEE"
        
        
    }
    
}
