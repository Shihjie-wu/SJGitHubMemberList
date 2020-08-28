//
//  UserProfileListViewModel.swift
//  SJGitHubMemberList
//
//  Created by Zero on 2020/8/26.
//  Copyright © 2020 Zero. All rights reserved.
//

import Foundation

class UserProfileListViewModel {
    
    var presenViewControllerWithContent:((_ content:String)->())?
    var reloadTableView: (()->())?
    var updateLoadingStatus: (()->())?
    
    var showAlertMessage: ((_ message: String)->())?
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertMessage?(self.alertMessage!)
        }
    }
    
    private var userProfileArray:[UserProfileModel] = [UserProfileModel]() {
        didSet{
            self.reloadTableView?()
        }
    }
    
    var loginStr:String?{
        didSet{
            self.presenViewControllerWithContent?(loginStr ?? "")
        }
    }
    
    func numberOfRows() -> Int
    {
        return userProfileArray.count
    }
    
    func getUserProfile(atIndexPath indexPath:IndexPath) -> UserProfileModel {
        return self.userProfileArray[indexPath.row]
    }
    
    func initFetch() {
        
        self.isLoading  = true
        
        RequestConnection.sharedInstance.getUserProfileList(since: String(self.userProfileArray.count / 2)){ (success, error, userList) in
            if let error = error {
                self.alertMessage = "Error message : \n \(error.localizedDescription)"
            } else
            {
                self.isLoading = false
                
                if self.userProfileArray.isEmpty {
                    self.userProfileArray = userList ?? [UserProfileModel]()
                } else {
                    self.userProfileArray.append(contentsOf: userList ?? [UserProfileModel]()
)
                }
            }
        }
    }
    
    func getUserDetail(with indexPath:IndexPath){
        self.loginStr = userProfileArray[indexPath.row].login
    }
}
