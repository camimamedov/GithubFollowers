//
//  GFRepoItemViewController.swift
//  GithubFollowers
//
//  Created by Cami Mamedov on 04.05.24.
//

import UIKit

class GFRepoItemViewController: GFItemInfoViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems(){
        itemInfoView1.set(itemInfoType: .repos, count: user.publicRepos)
        itemInfoView2.set(itemInfoType: .gists, count: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
}
