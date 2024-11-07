//
//  DiscoverViewController.swift
//  AisleAssignment
//
//  Created by Sree Lakshman on 07/11/24.
//

import Foundation
import UIKit

class DiscoverViewController: UIViewController {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var responseButton: UIButton!
    @IBOutlet weak var responseLabel: UILabel!
    
    private let viewModel = HomeViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpBinding()
        label1.text = "Not sure what to render here"
        label2.text = "Click the below button to make the API call"
        label1.font = UIFont(name: "Gilroy-Medium", size: 17)
        label2.font = UIFont(name: "Gilroy-Medium", size: 17)
        responseLabel.font = UIFont(name: "Gilroy-Regular", size: 17)
        
        let attributedString = NSAttributedString(
            string: "see response",
            attributes: [
                .font: UIFont(name: "Gilroy-Bold", size: 15) ?? UIFont.systemFont(ofSize: 14)
            ]
        )
        
        self.responseButton.setAttributedTitle(attributedString, for: .normal)
        self.responseButton.layer.cornerRadius = 10
    }
    
    func setUpBinding() {
            // Success closure to update the label with the entire response string
            self.viewModel.onSuccess = { responseText in
                DispatchQueue.main.async {
                    self.responseLabel.text = responseText
                }
            }
            
            // Error closure to handle any API or parsing errors
            self.viewModel.onError = { error in
                DispatchQueue.main.async {
                    self.responseLabel.text = "Error: \(error)"
                }
            }
        }
        
        @IBAction func responseButtonTapped(_ sender: UIButton) {
            guard let authToken = KeychainHelper.shared.getToken() else {
                print("Auth token not found")
                return
            }
            self.viewModel.fetchNotes(authToken: authToken)
        }
}
