//
//  LoginResponseModel.swift
//  AcmeTrading
//
//  Created by John Wilson on 28/10/2020.
//

struct LoginData: Decodable {
    let userMessage: String
    let authToken: String?
    let refreshToken: String?
}

struct LoginMeta: Decodable {
    let statusCode: Int
    let reason: String
}

struct LoginResponse: Decodable {
    let data: LoginData
    let meta: LoginMeta
}
