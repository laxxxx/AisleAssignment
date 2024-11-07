import Foundation
import SwiftyJSON

class HomeViewModel {
    var onSuccess: ((String) -> Void)?
    var onError: ((String) -> Void)?
    var onLikesFetchSuccess: ((Likes) -> Void)?
    var canSeeProfile: Bool = false
    
    // Fetch notes
    func fetchNotes(authToken: String) {
        let headers = ["Authorization": authToken]
        
        APIManager.shared.getRequest(endPoint: "/users/test_profile_list", headers: headers) { result in
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
        
        APIManager.shared.getRequest(endPoint: "/users/test_profile_list", headers: headers) { result in
            switch result {
            case .success(let data):
                // Log the raw response to debug
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON Response: \(jsonString)")  // Print raw response here
                }
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
            
            // Extracting data from the JSON
            let profiles = json["likes"]["profiles"].arrayValue.map { profileJson in
                return LikedProfile(
                    firstName: profileJson["first_name"].stringValue,
                    avatar: profileJson["avatar"].stringValue
                )
            }
            
            let canSeeProfile = json["likes"]["can_see_profile"].boolValue
            let likesReceivedCount = json["likes"]["likes_received_count"].intValue
            
            let likes = Likes(profiles: profiles, canSeeProfile: canSeeProfile, likesReceivedCount: likesReceivedCount)
            
            let profileResponse = ProfileResponse(likes: likes)
            
            self.onLikesFetchSuccess?(likes)
        } catch {
            self.onError?("Failed to parse likes data: \(error.localizedDescription)")
        }
    }
    
}
