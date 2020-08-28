//
//  UserDetailInfoViewController.swift
//  SJGitHubMemberList
//
//  Created by Zero on 2020/8/28.
//  Copyright © 2020 Zero. All rights reserved.
//

import UIKit

class UserDetailInfoViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var loginStrLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var blogBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var loginStr:String? = ""
    
    lazy var viewModel: UserProfileDetailViewModel = {
        return UserProfileDetailViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewModel()
        initView()
    }
    
    func initView(){
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
    }
    
    func initViewModel(){
        viewModel.reloadViewClosure = { [weak self]() in
            DispatchQueue.main.async {
                if let data = self?.viewModel.userDetail{
                    self?.userNameLabel.text = data.name
                    self?.loginStrLabel.text = data.login
                    self?.blogBtn.setTitle(data.blog, for: .normal)
                    if  let url = URL(string: data.avatar_url ?? "") {
                         let data = try! Data(contentsOf: url )
                        self?.avatarImageView.image = UIImage(data: data)
                    }
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
               DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.hidesWhenStopped = true
                }
            }
        }
        
        viewModel.showAlertMessage = { (message) in
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
            
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            
            let actionOK = UIAlertAction(title: "確定", style: .default, handler: { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            })
            
            alert.addAction(actionOK)
            self.present(alert, animated: true, completion: nil)
        }
        
        viewModel.initFetch(with: self.loginStr ?? "")
    }
    
    @IBAction func btnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
