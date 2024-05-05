//
//  NetworkManager.swift
//  Apetizer
//
//  Created by Cami Mamedov on 25.01.24.
//

import Foundation
import UIKit

final class NetworkManager{
    
    static let shared = NetworkManager()
    let cache = NSCache<NSString, UIImage>()
    
    private let baseURL = "https://api.github.com/users/"
    
    private init(){
    }

    func getFollowers(for username: String, page: Int) async throws -> [FollowerData]{
        guard let url = URL(string: baseURL + "\(username)/followers?per_page=100&page=\(page)") else {
            throw GFError.UrlError
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode([FollowerData].self, from: data)
            return response
        }
        catch{
            throw GFError.NetworkError
        }
    }

    func getUserInfo(for username: String) async throws -> UserData {
        guard let url = URL(string: baseURL + "\(username)") else {
            throw GFError.UrlError
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(UserData.self, from: data)
            return response
        }
        catch{
            throw GFError.NetworkError
        }
    }
}
