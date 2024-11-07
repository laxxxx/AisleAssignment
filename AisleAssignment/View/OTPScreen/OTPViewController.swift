//
//  OTPViewController.swift
//  AisleAssignment
//
//  Created by Sree Lakshman on 06/11/24.
//

import Foundation
import UIKit

class OTPViewController: UIViewController {
    
    @IBOutlet weak var phoneNoLabel: UILabel!
    @IBOutlet weak var enterOTPLabel: UILabel!
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    private let viewModel = OTPViewModel()
    
    var phoneNumber: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.otpTextField.delegate = self
        self.setUpUI()
        self.setUpBinding()
    }
    
    func setUpUI() {
        self.enterOTPLabel.text = "Enter The\nOTP"
        self.phoneNoLabel.font = UIFont(name: "Inter-Medium", size: 18)
        self.phoneNoLabel.text = phoneNumber?.formatPhoneNumber()
        self.enterOTPLabel.font = UIFont(name: "Inter-ExtraBold", size: 30)
        self.continueButton.layer.cornerRadius = 20
        let attributedString = NSAttributedString(
            string: "Continue",
            attributes: [
                .font: UIFont(name: "Inter-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14)
            ]
        )
        self.continueButton.setAttributedTitle(attributedString, for: .normal)
        self.continueButton.setAttributedTitle(attributedString, for: .highlighted)
        self.otpTextField.font = UIFont(name: "Inter-Bold", size: 18)
        self.otpTextField.layer.borderWidth = 1
        self.otpTextField.layer.cornerRadius = 8
        self.otpTextField.layer.borderColor = UIColor(hex: "#C4C4C4").cgColor
        
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        print("Phone Number: \(phoneNumber)")
        guard let otp = self.otpTextField.text, !otp.isEmpty else {
            self.showAlert(message: "Wrong OTP")
            return
        }
        
        self.viewModel.sendOTP(otp: otp, phoneNumber: phoneNumber!)
    }
    
    func setUpBinding() {
        self.viewModel.onSuccess =  { response in
            self.navigate()
        }
        
        self.viewModel.onError = { error in
            print("Error response \(error)")
            self.showAlert(message: "Failed to send phone number: \(error)")
        }
    }
    
    func navigate() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RootViewController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
    }
        
}

extension OTPViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Limit OTP field to 4 characters
        if textField == otpTextField {
            let newLength = (textField.text?.count ?? 0) + string.count - range.length
            return newLength <= 4
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.otpTextField.resignFirstResponder()
        return true
        
    }
}
