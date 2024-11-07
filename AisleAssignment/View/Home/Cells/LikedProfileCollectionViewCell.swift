//
//  LikedProfileCollectionViewCell.swift
//  AisleAssignment
//
//  Created by Sree Lakshman on 07/11/24.
//

import UIKit
import Kingfisher

class LikedProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with profile: LikedProfile, canSeeProfile: Bool) {
        nameLabel.text = profile.firstName
        nameLabel.font = UIFont(name: "Gilroy-Heavy", size: 18)
        nameLabel.textColor = .white
        avatarImageView.layer.cornerRadius = 10
        // Load the image using Kingfisher
        if let url = URL(string: profile.avatar) {
            avatarImageView.kf.setImage(with: url, placeholder: UIImage(named: ""))
        }
        
        // Set blur based on the `canSeeProfile` flag
        avatarImageView.setBlur(!canSeeProfile)
    }
    
}
