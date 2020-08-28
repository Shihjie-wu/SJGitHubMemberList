 //
//  UserProfileListViewController.swift
//  SJGitHubMemberList
//
//  Created by Zero on 2020/8/26.
//  Copyright © 2020 Zero. All rights reserved.
//

import UIKit

class UserProfileListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var viewModel: UserProfileListViewModel = {
        return UserProfileListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initViewModel()
        initView()
    }
    
    func initView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        let nib = UINib(nibName: "UserTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "UserTableViewCell")
    }
    
    func initViewModel() {
        self.activityIndicator.startAnimating()
        viewModel.initFetch()
        
        viewModel.reloadTableView = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
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
        
        viewModel.presenViewControllerWithContent = { [weak self] content in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserDetailInfoViewController") as! UserDetailInfoViewController
            vc.loginStr = content
            self?.present(vc, animated: true, completion: nil)
        }
        
        viewModel.showAlertMessage = { (message) in
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
            
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            
            let actionOK = UIAlertAction(title: "確定", style: .default, handler: nil)
            
            alert.addAction(actionOK)
            self.present(alert, animated: true, completion: nil)
        }
    }

}
 
 extension UserProfileListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell else {
                   fatalError()
               }
        
        let userProfile = viewModel.getUserProfile(atIndexPath: indexPath)
        cell.userProfileCellModel = userProfile
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.getUserDetail(with: indexPath)
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentOffsetY = scrollView.contentOffset.y
        let bottomOffset = scrollView.contentSize.height - contentOffsetY
        if bottomOffset <= height { // 在最底部 self.currentInsInBottom = true } else { self.currentInsInBottom = false
            
            if viewModel.numberOfRows() < 100 {
                if !viewModel.isLoading {
                    self.activityIndicator.startAnimating()
                    viewModel.initFetch()
                }
            }
        }
        
    }
}
