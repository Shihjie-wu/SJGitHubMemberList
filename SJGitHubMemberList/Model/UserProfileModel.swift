//
//  UserProfileModel.swift
//  SJGitHubMemberList
//
//  Created by Zero on 2020/8/26.
//  Copyright © 2020 Zero. All rights reserved.
//

import Foundation

struct UserProfileModel: Codable {
    let id: Int
    let avatar_url: String
    let login: String
    let site_admin: Bool
    let url: String
}
