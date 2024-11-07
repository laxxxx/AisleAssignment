//
//  OTPViewModel.swift
//  AisleAssignment
//
//  Created by Sree Lakshman on 06/11/24.
//

import Foundation

class OTPViewModel {
    var onSuccess: ((OTPResponse) -> Void)?
    var onError: ((String) -> Void)?
    
    func sendOTP(otp: String, phoneNumber: String) {
        let parameters = ["number": phoneNumber, "otp": otp]
        
        APIManager.shared.postRequest(
            endPoint: "/users/verify_otp",
            parameters: parameters,
            responseType: OTPResponse.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self.onSuccess?(response)
                        KeychainHelper.shared.saveToken(response.token)
                    case .failure(let error):
                        self.onError?(error.localizedDescription)
                    }
                }
            }
    }
}
