//
//  UserData.swift
//  GithubFollowers
//
//  Created by Cami Mamedov on 17.02.24.
//

import Foundation

struct UserData: Codable{
    let login: String
    let avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let htmlUrl: String
    let following: Int
    let followers: Int
    let createdAt: String
}
