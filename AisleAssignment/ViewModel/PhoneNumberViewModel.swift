//
//  PhoneNumberViewModel.swift
//  AisleAssignment
//
//  Created by Sree Lakshman on 06/11/24.
//

import Foundation

class PhoneNumberViewModel {
    var onSuccess: ((PhoneResponse) -> Void)?
    var onError: ((String) -> Void)?
    
    func sendPhoneNumber(_ number: String) {
        let parameters = ["number": number]
        
        APIManager.shared.postRequest(
            endPoint: "/users/phone_number_login",
            parameters: parameters,
            responseType: PhoneResponse.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("API Response: \(response)")
                    self.onSuccess?(response)
                case .failure(let error):
                    print("API Error: \(error.localizedDescription)")
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
}
