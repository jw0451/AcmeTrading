//
//  ProfileModel.swift
//  AcmeTrading
//
//  Created by John Wilson on 28/10/2020.
//

import Foundation

struct Profile: Decodable {
    let name: String
    let starLevel: Int
    let distanceFromUser: String
    let numRatings: Int
    let profileImage: String
}

struct ProfileData: Decodable {
    let userMessage: String
    let profiles: [Profile]?
}

struct ProfileMeta: Decodable {
    let statusCode: Int
    let reason: String
}

struct ProfileResponse: Decodable {
    let data: ProfileData
    let meta: ProfileMeta
}
