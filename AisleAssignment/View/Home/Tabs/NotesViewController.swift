//
//  NotesViewController.swift
//  AisleAssignment
//
//  Created by Sree Lakshman on 07/11/24.
//

import Foundation
import UIKit

class NotesViewController: UIViewController {
    
    @IBOutlet weak var notesTitle: UILabel!
    @IBOutlet weak var notesSubtitle: UILabel!
    @IBOutlet weak var interestedLabel: UILabel!
    @IBOutlet weak var premiumLabel: UILabel!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var colectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel = HomeViewModel()
    var likesData: [LikedProfile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupBindings()
    }
    
    func setupUI() {
        self.notesTitle.font = UIFont(name: "Gilroy-Bold", size: 27)
        self.notesSubtitle.font = UIFont(name: "Gilroy-Medium", size: 18)
        self.interestedLabel.font = UIFont(name: "Gilroy-Bold", size: 22)
        self.premiumLabel.text = "Premium members can \nview all their likes at once"
        self.premiumLabel.font = UIFont(name: "Gilroy-Medium", size: 15)
        self.premiumLabel.textColor = UIColor(hex: "#9B9B9B")
        self.upgradeButton.layer.cornerRadius = 24
        let attributedString = NSAttributedString(
            string: "Continue",
            attributes: [
                .font: UIFont(name: "Gilroy-Bold", size: 15) ?? UIFont.systemFont(ofSize: 14)
            ]
        )
        
        self.upgradeButton.setAttributedTitle(attributedString, for: .normal)
        self.upgradeButton.setAttributedTitle(attributedString, for: .highlighted)
        
        self.imageView.image = UIImage(named: "Meena")
        self.imageView.contentMode = .scaleAspectFit
        
        self.colectionView.dataSource = self
        self.colectionView.delegate = self
        self.colectionView.register(UINib(nibName: "LikedProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    func setupBindings() {
        guard let authToken = KeychainHelper.shared.getToken() else {
            print("Auth token not found")
            return
        }
        viewModel.fetchLikes(authToken: authToken)
        
        viewModel.onLikesFetchSuccess = { [weak self] likes in
            DispatchQueue.main.async {
                self?.likesData = likes.profiles
                self?.colectionView.reloadData()
            }
        }
        
        self.viewModel.onError = { error in
            print("Error response \(error)")
            self.showAlert(message: "Failed get liked profiles \(error)")
        }
    }
}


extension NotesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? LikedProfileCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let profile = likesData[indexPath.item]
        cell.configure(with: profile, canSeeProfile: viewModel.canSeeProfile)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let numberOfItemsPerRow: CGFloat = 2
            let padding: CGFloat = 10
            let totalPadding: CGFloat = padding * (numberOfItemsPerRow - 1)
            let availableWidth = collectionView.frame.width - totalPadding
            let itemWidth = availableWidth / numberOfItemsPerRow
            
            // Set a fixed height for each item
            let itemHeight: CGFloat = 160 // Adjust as needed
            
            return CGSize(width: itemWidth, height: itemHeight)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 10 // Spacing between cells horizontally
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10 // Spacing between rows vertically
        }
}
