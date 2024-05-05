//
//  FollowerListViewController.swift
//  GithubFollowers
//
//  Created by Cami Mamedov on 11.02.24.
//

import UIKit

class FollowerListViewController: UIViewController, UICollectionViewDelegate, UISearchResultsUpdating {
   
    enum Section{
        case main
    }
    
    var username: String!
    var followers: [FollowerData] = []
    var filteredFollowers: [FollowerData] = []
    var page: Int = 1
    var hasMoreFollowers = true
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, FollowerData>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureCollectionView()
        getFollowers()
        configureDataSource()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func getFollowers(){
        showLoadingView()
        Task{
            do {
                let followers = try await NetworkManager.shared.getFollowers(for: username, page: page)
                dismissLoadingView()
                hasMoreFollowers = (followers.count >= 100)
                self.followers.append(contentsOf: followers)
                
                if self.followers.isEmpty{
                    showEmptyStateView(message: "This user doesn't have any followers. Go follow them.", in: view)
                    return
                }
                updateData(on: self.followers)
            }
            catch{
                if let error = error as? GFError{
                    var message = "Network error"
                    switch error {
                    case .NetworkError:
                        message = "Invalid response from server. Please try again."
                    case .UrlError:
                        message = "This username created an invalid request. Please try again."
                    }
                    
                    self.presentGFAlertOnMainThread(title: "Something went wrong.", message: message, buttonTitle: "Ok")
                    
                    return
                }
            }
        }
    }
    
    private func createColumnFlowLayout() -> UICollectionViewFlowLayout{
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
    
    private func configureViewController(){
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createColumnFlowLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    private func configureDataSource(){
        dataSource = UICollectionViewDiffableDataSource<Section, FollowerData>(collectionView: collectionView, cellProvider: {
            (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    private func configureSearchController(){
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
    }
    
    private func updateData(on followers: [FollowerData]){
        var snapshot = NSDiffableDataSourceSnapshot<Section, FollowerData>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > contentHeight - height && hasMoreFollowers {
            page += 1
            getFollowers()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let follower = followers[indexPath.item]
        
        let infoViewController = UserInfoViewController()
        infoViewController.username = follower.login
        
        let navigationViewController = UINavigationController(rootViewController: infoViewController)
        present(navigationViewController, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            updateData(on: followers)
            return
        }
        
        filteredFollowers = followers.filter({ follower in
            follower.login.lowercased().contains(filter.lowercased())
        })
        
        updateData(on: filteredFollowers)
    }
}
