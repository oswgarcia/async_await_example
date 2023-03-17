//
//  Models.swift
//  ejemploAsyncAwait
//
//  Created by Oswaldo Jose Garcia Morales on 16/03/23.
//


import Foundation

// MARK: - PostModel
struct PostModel: Codable {
    var userID, id: Int
    var title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}
// MARK: - UserModel
struct UserModel : Codable {
    var id: Int
    var name, username, email: String
    var address: Address
    var phone, website: String
    var company: Company
}
// MARK: - Address
struct Address : Codable {
    var street, suite, city, zipcode: String
    var geo: Geo
}
// MARK: - Geo
struct Geo : Codable {
    var lat, lng: String
}
// MARK: - Company
struct Company : Codable {
    var name, catchPhrase, bs: String
}
// MARK: - CommentsModel
struct CommentsModel: Codable {
    var postID, id: Int
    var name, email, body: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case id, name, email, body
    }
}
