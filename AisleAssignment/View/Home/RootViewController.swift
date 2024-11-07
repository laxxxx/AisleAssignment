//
//  RootViewController.swift
//  AisleAssignment
//
//  Created by Sree Lakshman on 07/11/24.
//

import Foundation
import UIKit

class RootViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set global appearance for the selected and unselected tab bar item text color
        let appearance = UITabBarItem.appearance()
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont(name: "Gilroy-Bold", size: 11)!
        ]
        appearance.setTitleTextAttributes(attributes, for: .selected)
        appearance.setTitleTextAttributes(attributes, for: .normal)
        
        // Set the selected tab item tint color and unselected item tint color
        self.tabBar.tintColor = UIColor.black
        self.tabBar.unselectedItemTintColor = UIColor.gray
        
        // Add view controllers to the tab bar
        let discoverVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "DiscoverViewController") as! DiscoverViewController

        discoverVC.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(systemName: "square.grid.2x2"),selectedImage: UIImage(systemName: "square.grid.2x2.fill"))
        
        let notesVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        notesVC.tabBarItem = UITabBarItem(title: "Notes", image: UIImage(systemName: "envelope"), selectedImage: UIImage(systemName: "envelope.fill"))
        notesVC.tabBarItem.badgeValue = "9"
        notesVC.tabBarItem.badgeColor = UIColor(hex: "#8C5CFB")
        
        let matchesVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MatchesViewController") as! MatchesViewController
        matchesVC.tabBarItem = UITabBarItem(title: "Matches", image: UIImage(systemName: "message"), selectedImage: UIImage(systemName: "message.fill"))
        matchesVC.tabBarItem.badgeColor = UIColor(hex: "#8C5CFB")
        matchesVC.tabBarItem.badgeValue = "50+"
        
        let profileVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        self.viewControllers = [notesVC, discoverVC, matchesVC, profileVC]
    }
}
