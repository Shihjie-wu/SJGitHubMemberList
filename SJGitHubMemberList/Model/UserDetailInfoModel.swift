//
//  UserInfoModel.swift
//  SJGitHubMemberList
//
//  Created by Zero on 2020/8/26.
//  Copyright © 2020 Zero. All rights reserved.
//

import Foundation

struct UserDetailInfoModel: Codable {
    
    let avatar_url: String?
    let name: String?
    let bio: String?
    let login: String?
    let site_admin: Bool
    let location: String?
    let blog: String?
}
