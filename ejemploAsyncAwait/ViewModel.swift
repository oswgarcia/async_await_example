//
//  ViewModel.swift
//  ejemploAsyncAwait
//
//  Created by Oswaldo Jose Garcia Morales on 15/03/23.
//

import Foundation

class ViewModel {
    
    let usersURL = "https://jsonplaceholder.typicode.com/users/"
    let postsURL = "https://jsonplaceholder.typicode.com/posts/"
    
    // MARK: Callback fectchs
    
    func fetchUsers(completion: @escaping ([UserModel]?, Error?) -> Void) {
        
        Networking.requestData(urlString: usersURL) { (result: Result<[UserModel], Error>) in
            switch result {
            case .success(let users):
                completion(users, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
  
    func fetchPosts(by user: UserModel, completion: @escaping ([PostModel]?, Error?) -> Void) {
        
        let url = makePostUrl(id: user.id)
        Networking.requestData(urlString: url) { (result: Result<[PostModel], Error>) in
            switch result {
            case .success(let posts):
                completion(posts, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func fetchComments(by post: PostModel, completion: @escaping ([CommentsModel]?, Error?) -> Void) {
        
        let url = makeCommentUrl(id: post.id)
        Networking.requestData(urlString: url) { (result: Result<[CommentsModel], Error>) in
            switch result {
            case .success(let comments):
                completion(comments, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func makePostUrl(id:Int) -> String {
        return "\(usersURL)\(id)/posts"
    }
    func makeCommentUrl(id:Int) -> String {
        return "\(postsURL)\(id )/comments"
    }
    

    // MARK: - Async / Await fetchs
    
    func fetchUsers() async throws -> [UserModel] {
        let users: [UserModel] = try await Networking.fetchData(urlString: usersURL)
        return users
    }

    func fetchPosts(by user: UserModel) async throws -> [PostModel] {
        let url = makePostUrl(id: user.id)
        let posts: [PostModel] = try await Networking.fetchData(urlString: url)
        return posts
    }

    func fetchComments(by post: PostModel) async throws -> [CommentsModel] {
        let url = makeCommentUrl(id: post.id)
        let comments: [CommentsModel] = try await Networking.fetchData(urlString: url)
        return comments
    }

    // MARK: - Mixing Async / Await and Completion
    
    func fetchUsersMix() async throws -> [UserModel] {
        return await withCheckedContinuation { continuation in
            Networking.requestData(urlString: usersURL) { (result: Result<[UserModel], Error>) in
                switch result {
                case .success(let users):
                    continuation.resume(returning: users)
                case .failure(let error):
                    continuation.resume(throwing: error as! Never)
                }
            }
        }
    }
}
