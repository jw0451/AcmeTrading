//
//  APIService.swift
//  AcmeTrading
//
//  Created by John Wilson on 27/10/2020.
//

import Foundation

enum APIError: Error {
    case JSONError
    case unauthorized
    case serverError
    var localizedDescription: String {
            
            let message : String
            
            switch self {
            case .JSONError:
                message = "There was a problem parsing the JSON"
            case .unauthorized:
                message = "This username and password combination is not valid"
            case .serverError:
                message = "There was a problem with the server"
            }
            
            return message
        }
}

class APIService {
    
    static let loginURLString = "https://ho0lwtvpzh.execute-api.us-east-1.amazonaws.com/DummyLogin"
    static let profileListURLString =  "https://ypznjlmial.execute-api.us-east-1.amazonaws.com/DummyProfileList"

    fileprivate let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func login(username: String, password: String, completionHandler: @escaping (LoginResponse?, Error?) -> Void) {
        // Prepare URL
        let url = URL(string: APIService.loginURLString)
        
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        // HTTP Request Parameters which will be sent in HTTP Request Body
        let postString =
        """
        {
        "username": "\(username)", "password": "\(password)"
        }
        """
        // Set HTTP Request Body
        request.httpBody = postString.data(using: String.Encoding.utf8);
        // Perform HTTP Request
        let task = session.dataTask(with: request) { (data, response, error) in
            // Check for Error
            if let error = error {
                print("Error logging in \(error)")
                completionHandler(nil, error)
                return
            }
     
            // Parse JSON response data to an object
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                
                print("Response data:\n \(dataString)")
                if let loginResponse = self.parseLoginJSON(json: data) {
                    // handle unauthorised response
                    if loginResponse.meta.statusCode == 401 {
                        completionHandler(loginResponse, APIError.unauthorized)
                    } else if loginResponse.meta.statusCode == 500 {
                        completionHandler(loginResponse, APIError.serverError)
                    } else {
                        completionHandler(loginResponse, nil)
                    }
                } else {
                    completionHandler(nil, APIError.JSONError)
                }
            }
        }
        task.resume()
    }
    
    func parseLoginJSON(json: Data) -> LoginResponse? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let loginResponse: LoginResponse = try decoder.decode(LoginResponse.self, from: json)
            return loginResponse
        } catch let error {
            print(error)
        }
        return nil
    }
    
    
    func getProfileList(completionHandler: @escaping (ProfileResponse?, Error?) -> Void) {
        guard let authToken = UserManager.shared.authToken else {
            completionHandler(nil, APIError.unauthorized)
            return
        }
        // Prepare URL
        let url = URL(string: APIService.profileListURLString)
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
         
        // Add header with authorization token
        request.addValue(authToken, forHTTPHeaderField: "authorization")

        // Perform HTTP Request
        let task = session.dataTask(with: request) { (data, response, error) in
            // Check for Error
            if let error = error {
                print("Error retrieving profile list \(error)")
                completionHandler(nil, error)
                return
            }
     
            // Parse JSON response data to an object
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                
                print("Response data:\n \(dataString)")
                if let profileResponse = self.parseProfileListJSON(json: data) {
                    // handle unauthorised response
                    if profileResponse.meta.statusCode == 401 {
                        completionHandler(profileResponse, APIError.unauthorized)
                    } else {
                        completionHandler(profileResponse, nil)
                    }
                } else {
                    completionHandler(nil, APIError.JSONError)
                }
            }
        }
        task.resume()
    }
    
    func parseProfileListJSON(json: Data) -> ProfileResponse? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let profileResponse: ProfileResponse = try decoder.decode(ProfileResponse.self, from: json)
            return profileResponse
        } catch let error {
            print(error)
        }
        return nil
    }
}
