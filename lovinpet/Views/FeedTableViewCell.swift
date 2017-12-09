//
//  FeedTableViewCell.swift
//  lovinpet
//
//  Created by Hong Gao on 2017/11/14.
//  Copyright © 2017年 Hong Gao. All rights reserved.
//

import UIKit

protocol CommentProtocal {
    func gotoComment(postId: String)
}

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    var postId: String!
    
    var commentProtocal: CommentProtocal?

    func set(avatar: String, image: String, title: String, nickname: String) {
        nicknameLabel.text = nickname
        titleLabel.text = title
        avatarImageView.kf.setImage(with: URL(string: avatar))
        feedImage.kf.setImage(with: URL(string: image))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        feedImage.layer.masksToBounds = true
        feedImage.contentMode = .scaleAspectFill
        
        avatarImageView.layer.masksToBounds = true
        avatarImageView.backgroundColor = UIColor.white
        avatarImageView.layer.borderColor = UIColor.gray.cgColor
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height / 2
    }
    
    @IBAction func commentClicked(_ sender: Any) {
        if let pro = self.commentProtocal {
            pro.gotoComment(postId: postId)
        }
    }
}
