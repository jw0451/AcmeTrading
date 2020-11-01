//
//  LoginViewModel.swift
//  AcmeTrading
//
//  Created by John Wilson on 01/11/2020.
//

import Foundation

protocol LoginViewModelDelegate {
    func showError(_ error: String)
    func showViewController(_ vc: UIViewController)
}

class LoginViewModel {
    fileprivate let apiService: APIService
    var delegate: LoginViewModelDelegate?
    
    init(delegate: LoginViewModelDelegate, apiService: APIService = APIService()) {
        self.delegate = delegate
        self.apiService = apiService
    }
    
    func login(username: String, password: String) {
        apiService.login(username: username, password: password) { (loginResponse, error) in
            if let error = error {
                print(error)
                self.delegate?.showError(error.localizedDescription)
            }
            if let loginResponse = loginResponse {
                print(loginResponse.data.userMessage)
                if let authToken = loginResponse.data.authToken, let refreshToken = loginResponse.data.refreshToken {
                    UserManager.shared.authToken = authToken
                    UserManager.shared.refreshToken = refreshToken
                    DispatchQueue.main.async {
                        let profileVC = ProfileListViewController()
                        self.delegate?.showViewController(profileVC)
                    }
                } else {
                    self.delegate?.showError(loginResponse.data.userMessage)
                }
            }
        }
    }
}
