//
//  UserManager.swift
//  AcmeTrading
//
//  Created by John Wilson on 28/10/2020.
//

import Foundation

class UserManager {
    static let shared = UserManager()    
    var authToken: String?
    var refreshToken: String?
    
    func logout() {
        authToken = nil
        refreshToken = nil
    }
}
