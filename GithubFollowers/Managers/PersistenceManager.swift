//
//  PersistenceManager.swift
//  GithubFollowers
//
//  Created by Cami Mamedov on 12.05.24.
//

import Foundation

enum PersistenceActionType{
    case add, remove
}

enum PersistenceManager{
    
    static private let defaults = UserDefaults.standard
    
    enum Keys{
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: FollowerData, actionType: PersistenceActionType, completed: @escaping (GFError?) -> Void){
        retrieveFavorites { result in
            switch result{
            case .success(let retrievedFavorites):
                
                var favorites = retrievedFavorites
                switch(actionType){
                case .add:
                    
                    guard favorites.contains(favorite) == false else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    
                    favorites.append(favorite)
                    
                    break
                case.remove:
                    
                    favorites.removeAll { user in
                        user.login == favorite.login
                    }
                    
                    break
                }
                completed(save(favorites: favorites))
                
                break
            case .failure(let error):
                completed(error)
                break
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[FollowerData], GFError>) -> Void){
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else{
            completed(.success([]))
            return
        }
        
        do{
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([FollowerData].self, from: favoritesData)
            completed(.success(favorites))
        }
        catch{
            completed(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: [FollowerData]) -> GFError? {
        
        do{
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.setValue(encodedFavorites, forKey: Keys.favorites)
            return nil
        }
        catch{
            return .unableToFavorite
        }
    }
}
