//
//  RequestConnection.swift
//  SJGitHubMemberList
//
//  Created by Zero on 2020/8/27.
//  Copyright © 2020 Zero. All rights reserved.
//

import Foundation

class RequestConnection: NSObject {
    
    static let sharedInstance: RequestConnection = RequestConnection()
    
    typealias requestComplate = (Data?, Error?) -> Void
    
    func requestWithURL(urlString: String, parameters: [String: Any], completion: @escaping (requestComplate)) {
        
        var urlComponents = URLComponents(string: urlString)!
        urlComponents.queryItems = []
        
        for (key, value) in parameters{
            guard let value = value as? String else{return}
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        
        guard let queryedURL = urlComponents.url else{return}
        
        let request = URLRequest(url: queryedURL)
        
        fetchedDataByDataTask(from: request, completion: completion)
    }
    
    private func fetchedDataByDataTask(from request: URLRequest, completion: @escaping (requestComplate)) {
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                completion(data, error)
                print(error as Any)
            } else {
                guard let data = data else{return}
                completion(data, error)
            }
        }
        task.resume()
    }
    
    func getUserProfileList(since:String, completion:@escaping(_ isSuccess:Bool, _ error:Error?, [UserProfileModel]?)->()){
        
        let urlStr = "https://api.github.com/users"
        let paramDic = ["since":since,"per_page":"20"]
        
        requestWithURL(urlString: urlStr, parameters: paramDic) { (data, error) in
            guard let data = data else {
                        completion(false, error, nil)
                        return
                    }
            DispatchQueue.main.async {
                      let decoder = JSONDecoder()
                
                      do {
                        let userList = try decoder.decode([UserProfileModel].self, from: data)
                          completion(true,nil,userList)
                      } catch let error {
                          completion(false, error,nil)
                      }
                  }
        }
    }
    
    func getUserDetail(loginStr:String, completion:@escaping (_ isSuccess:Bool, _ error:Error?, UserDetailInfoModel?) -> ()) {
        let urlStr = "https://api.github.com/users/\(loginStr)"

               requestWithURL(urlString: urlStr, parameters: [:]) { (data, error) in
                   guard let data = data else {
                               completion(false, error, nil)
                               return
                           }
                   DispatchQueue.main.async {
                             let decoder = JSONDecoder()
                             do{
                                 let userDetail = try decoder.decode(UserDetailInfoModel.self, from: data)
                                 completion(true,nil,userDetail)
                             }catch let error{
                                 completion(false, error,nil)
                             }
                         }
               }
    }
}
