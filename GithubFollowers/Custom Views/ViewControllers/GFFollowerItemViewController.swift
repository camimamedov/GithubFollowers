//
//  GFFollowerItemViewController.swift
//  GithubFollowers
//
//  Created by Cami Mamedov on 05.05.24.
//

import UIKit

class GFFollowerItemViewController: GFItemInfoViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems(){
        itemInfoView1.set(itemInfoType: .followers, count: user.followers)
        itemInfoView2.set(itemInfoType: .following, count: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
}
