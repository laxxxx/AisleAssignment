//
//  ProfileRespose.swift
//  AisleAssignment
//
//  Created by Sree Lakshman on 07/11/24.
//

import Foundation
struct ProfileResponse {
    let likes: Likes
}

struct Likes {
    let profiles: [LikedProfile]
    let canSeeProfile: Bool
    let likesReceivedCount: Int
}

struct LikedProfile {
    let firstName: String
    let avatar: String
}
