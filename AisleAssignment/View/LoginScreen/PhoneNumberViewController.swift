//
//  PhoneNumberViewController.swift
//  AisleAssignment
//
//  Created by Sree Lakshman on 06/11/24.
//

import Foundation
import UIKit

class PhoneNumberViewController: UIViewController {
    
    @IBOutlet weak var getOtpLabel: UILabel!
    @IBOutlet weak var enterPhoneNumberLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var countryCodeTextField: UITextField!
    
    var phoneNumber: String?
    
    private let viewModel = PhoneNumberViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setupBindings()
        self.countryCodeTextField.delegate = self
        self.phoneNumberTextField.delegate = self
    }
    
    func setUpUI() {
        self.enterPhoneNumberLabel.text = "Enter Your \nPhone Number"
        self.getOtpLabel.font = UIFont(name: "Inter-Medium", size: 18)
        self.enterPhoneNumberLabel.font = UIFont(name: "Inter-ExtraBold", size: 30)
        self.phoneNumberTextField.font = UIFont(name: "Inter-Bold", size: 18)
        self.countryCodeTextField.font = UIFont(name: "Inter-Bold", size: 18)
        self.continueButton.layer.cornerRadius = 20
        self.phoneNumberTextField.layer.borderColor = UIColor(hex: "#C4C4C4").cgColor
        self.phoneNumberTextField.layer.borderWidth = 1
        self.countryCodeTextField.layer.borderColor = UIColor(hex: "#C4C4C4").cgColor
        self.countryCodeTextField.layer.borderWidth = 1
        self.countryCodeTextField.layer.cornerRadius = 8
        self.phoneNumberTextField.layer.cornerRadius = 8
        self.countryCodeTextField.text = "+91"
        
        // Text attributes for button
        let attributedString = NSAttributedString(
            string: "Continue",
            attributes: [
                .font: UIFont(name: "Inter-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14)
            ]
        )
        self.continueButton.setAttributedTitle(attributedString, for: .normal)
        self.continueButton.setAttributedTitle(attributedString, for: .highlighted)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        // Retrieve phone number input and validate
        guard let phoneNo = self.phoneNumberTextField.text, !phoneNo.isEmpty else {
            self.showAlert(message: "Please enter a valid phone number")
            return
        }
        
        guard let countryCode = self.countryCodeTextField.text, !countryCode.isEmpty else {
            self.showAlert(message: "Please enter a valid phone number")
            return
        }
        
        phoneNumber = countryCode + phoneNo
        // Send phone number through the ViewModel
        self.viewModel.sendPhoneNumber(phoneNumber!)
    }
    
    func setupBindings() {
        // Success callback
        self.viewModel.onSuccess = { response in
            self.navigateToOtpScreen()
        }
        
        // failure callback
        self.viewModel.onError = { error in
            print("Error response \(error)")
            self.showAlert(message: "Failed to send phone number: \(error)")
        }
    }
    
    func navigateToOtpScreen() {
        if let otpScreen = UIStoryboard(name: "OTPView", bundle: nil).instantiateViewController(withIdentifier: "OTPViewController") as? OTPViewController {
            otpScreen.phoneNumber = self.phoneNumber
            otpScreen.navigationController?.setNavigationBarHidden(true, animated: false)
            otpScreen.modalPresentationStyle = .fullScreen
            self.present(otpScreen, animated: true)
            
        }
    }
}


//MARK: UITextFieldDelegate
extension PhoneNumberViewController: UITextFieldDelegate {
    
    // UITextFieldDelegate Method to limit character count
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.countryCodeTextField {
            // Limit country code text field to 3 characters (including +)
            let newLength = (textField.text?.count ?? 0) + string.count - range.length
            return newLength <= 3
        } else if textField == self.phoneNumberTextField {
            // Limit phone number text field to 10 characters
            let newLength = (textField.text?.count ?? 0) + string.count - range.length
            return newLength <= 10
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.countryCodeTextField.resignFirstResponder()
        self.phoneNumberTextField.resignFirstResponder()
        return true
        
    }
}
