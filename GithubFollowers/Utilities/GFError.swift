//
//  GFError.swift
//  GithubFollowers
//
//  Created by Cami Mamedov on 17.02.24.
//

import Foundation

enum GFError: String, Error{
    case NetworkError = "Invalid response from server. Please try again."
    case UrlError = "This username created an invalid request. Please try again."
    case unableToFavorite = "There was an error favoriting this user."
    case alreadyInFavorites = "You've already favorited this user."
}
