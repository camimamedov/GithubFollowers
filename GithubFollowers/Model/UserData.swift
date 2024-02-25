//
//  UserData.swift
//  GithubFollowers
//
//  Created by Cami Mamedov on 17.02.24.
//

import Foundation

struct UserData: Codable{
    var login: String
    var avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    var publicRepos: Int
    var publicGists: Int
    var htmlUrl: String
    var following: Int
    var followers: Int
    var createdAt: String
}
