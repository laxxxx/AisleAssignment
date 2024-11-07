//
//  HomeViewModel.swift
//  AisleAssignment
//
//  Created by Sree Lakshman on 07/11/24.
//

import Foundation
import SwiftyJSON

class HomeViewModel {
    var onSuccess: ((String) -> Void)?
    var onError: ((String) -> Void)?
    var onLikesFetchSuccess: ((Likes) -> Void)?
    var canSeeProfile: Bool = false
    
    var profileName: String = ""
    var profileImageURL: String = ""
    var profileAge: String = ""
    
    private let endpoint = "/users/test_profile_list"
    
    // Fetch notes
    func fetchNotes(authToken: String) {
        let headers = ["Authorization": authToken]
        
        APIManager.shared.getRequest(endPoint: endpoint,
                                     headers: headers) { result in
            switch result {
            case .success(let data):
                self.handleResponseData(data)
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    // Handle the raw response data (string)
    private func handleResponseData(_ data: Data) {
        if let jsonString = String(data: data, encoding: .utf8) {
            self.onSuccess?(jsonString)
        } else {
            self.onError?("Failed to parse data as JSON.")
        }
    }
    
    // Fetch likes data
    func fetchLikes(authToken: String) {
        let headers = ["Authorization": authToken]
        
        APIManager.shared.getRequest(endPoint: endpoint,
                                     headers: headers) { result in
            switch result {
            case .success(let data):
                self.handleLikesResponseData(data)
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
    
    // Handle the likes response data
    private func handleLikesResponseData(_ data: Data) {
        do {
            
            let json = try JSON(data: data)
            
            if let firstProfile = json["invites"]["profiles"].array?.first {
                profileName = firstProfile["general_information"]["first_name"].stringValue
                profileAge = firstProfile["general_information"]["age"].stringValue
                
                // Check the photos array for the selected image
                if let selectedPhoto = firstProfile["photos"].array?.first(where: { $0["selected"].boolValue == true }) {
                    profileImageURL = selectedPhoto["photo"].stringValue
                }
            }
            
            print("[XX] Profile Name: \(profileName), Age: \(profileAge), Image URL: \(profileImageURL)")
            
            // Extracting data from the JSON
            let likedProfiles = json["likes"]["profiles"].arrayValue.map { profileJson in
                return LikedProfile(
                    firstName: profileJson["first_name"].stringValue,
                    avatar: profileJson["avatar"].stringValue
                )
            }
            
            canSeeProfile = json["likes"]["can_see_profile"].boolValue
            let likesReceivedCount = json["likes"]["likes_received_count"].intValue
            
            let likes = Likes(
                profiles: likedProfiles,
                canSeeProfile: canSeeProfile,
                likesReceivedCount: likesReceivedCount)
            
            self.onLikesFetchSuccess?(likes)
        } catch {
            self.onError?("Failed to parse likes data: \(error.localizedDescription)")
        }
    }
    
}
