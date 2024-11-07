//
//  ProfileViewController.swift
//  AisleAssignment
//
//  Created by Sree Lakshman on 07/11/24.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributedString = NSAttributedString(
            string: "Log Out",
            attributes: [
                .font: UIFont(name: "Gilroy-Bold", size: 15) ?? UIFont.systemFont(ofSize: 14)
            ]
        )
        
        self.signOutButton.setAttributedTitle(attributedString, for: .normal)
        self.signOutButton.layer.cornerRadius = 10
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        self.logOutAndNavigate()
    }
    
    private func logOutAndNavigate() {
        let alert = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            KeychainHelper.shared.deleteToken()
            
            let storyboard = UIStoryboard(name: "PhoneNumber", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PhoneNumberViewController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}
