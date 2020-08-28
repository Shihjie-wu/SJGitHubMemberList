//
//  UserProfileDetailViewModel.swift
//  SJGitHubMemberList
//
//  Created by Zero on 2020/8/28.
//  Copyright © 2020 Zero. All rights reserved.
//

import Foundation

class UserProfileDetailViewModel {
    
    var reloadViewClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var showAlertMessage: ((_ message: String)->())?
    
    var userDetail:UserDetailInfoModel? {
        didSet{
            self.reloadViewClosure?()
        }
    }

    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    var alertMessage: String? {
        didSet {
            self.showAlertMessage?(alertMessage!)
        }
    }
    
    func initFetch(with loginStr:String) {
        self.isLoading = true
        RequestConnection.sharedInstance.getUserDetail(loginStr: loginStr) { (isSuccess, error, data) in
            if let error = error {
                self.alertMessage = "Error message : \n \(error.localizedDescription)"
            }else
            {
                self.isLoading = false
                self.userDetail = data
            }
        }
    }
}
