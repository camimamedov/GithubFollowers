//
//  UserInfoViewController.swift
//  GithubFollowers
//
//  Created by Cami Mamedov on 25.02.24.
//

import UIKit

class UserInfoViewController: UIViewController {

    let headerView = UIView()
    let profileView = UIView()
    let followersView = UIView()
    
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.backgroundColor = .systemGray6
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        Task {
            do{
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                add(childVC: GFUserInfoHeaderViewController(user: user), to: headerView)
                add(childVC: GFRepoItemViewController(user: user), to: profileView)
                add(childVC: GFFollowerItemViewController(user: user), to: followersView)
            }
            catch{
                if let error = error as? GFError{
                    presentGFAlertOnMainThread(title: "Something went wrong", message: error.localizedDescription, buttonTitle: "OK")
                }
            }
        }
        
        layoutUI()
    }
    
    private func layoutUI(){
        view.addSubview(headerView)
        view.addSubview(profileView)
        view.addSubview(followersView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        profileView.translatesAutoresizingMaskIntoConstraints = false
        followersView.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.backgroundColor = .systemBackground
        profileView.backgroundColor = .systemBackground
        followersView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            profileView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            profileView.heightAnchor.constraint(equalToConstant: 150),
            
            followersView.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 20),
            followersView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            followersView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            followersView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }
    
    private func add(childVC: UIViewController, to containerView: UIView){
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}
