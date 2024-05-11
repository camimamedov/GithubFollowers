//
//  UserInfoViewController.swift
//  GithubFollowers
//
//  Created by Cami Mamedov on 25.02.24.
//

import UIKit
import SafariServices

protocol UserInfoVCDelegate: AnyObject {
    func didTapGithubProfile(with: UserData)
    func didTapGetFollowers(with: UserData)
}

class UserInfoViewController: UIViewController {
    
    let headerView = UIView()
    let profileView = UIView()
    let followersView = UIView()
    let dateLabel = GFBodyLabel(textAlignment: .center)
    
    var username: String!
    weak var delegate: FollowerListVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.backgroundColor = .systemGray6
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
        
        Task {
            do{
                let user = try await NetworkManager.shared.getUserInfo(for: username)
                configureUIElements(with: user)
            }
            catch{
                if let error = error as? GFError{
                    presentGFAlertOnMainThread(title: "Something went wrong", message: error.localizedDescription, buttonTitle: "OK")
                }
            }
        }
        
        layoutUI()
    }
    
    private func configureUIElements(with user: UserData){
        let repoItemVC = GFRepoItemViewController(user: user)
        repoItemVC.delegate = self
        
        let followerItemVC = GFFollowerItemViewController(user: user)
        followerItemVC.delegate = self
        
        add(childVC: GFUserInfoHeaderViewController(user: user), to: headerView)
        add(childVC: repoItemVC, to: profileView)
        add(childVC: followerItemVC, to: followersView)
        dateLabel.text = "GitHub Since \(user.createdAt.convertToDisplayFormat())"
    }
    
    private func layoutUI(){
        view.addSubview(headerView)
        view.addSubview(profileView)
        view.addSubview(followersView)
        view.addSubview(dateLabel)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        profileView.translatesAutoresizingMaskIntoConstraints = false
        followersView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
            followersView.heightAnchor.constraint(equalToConstant: 150),
            
            dateLabel.topAnchor.constraint(equalTo: followersView.bottomAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
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

extension UserInfoViewController: UserInfoVCDelegate{
    
    func didTapGithubProfile(with user: UserData) {
        guard let url = URL(string: user.htmlUrl) else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The URL attached to this user is invalid.", buttonTitle: "OK")
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    
    func didTapGetFollowers(with user: UserData) {
        guard user.followers != 0 else {
            presentGFAlertOnMainThread(title: "No followers", message: "This user has no followers. What a shame", buttonTitle: "OK")
            return
        }
        
        delegate.didRequestFollowers(for: user.login)
        dismissVC()
    }
    
}
