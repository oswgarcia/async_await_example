//
//  Network.swift
//  ejemploAsyncAwait
//
//  Created by Oswaldo Jose Garcia Morales on 15/03/23.
//

import Foundation

class Networking {
    
    // MARK: Callback
   static func requestData<T: Codable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else {
                completion(.failure(error ?? NSError(domain: "Unknown error", code: 0, userInfo: nil)))
                return
            }
            do {
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(T.self, from: data)
                completion(.success(responseData))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    // MARK: Asycn / Await
    static func fetchData<T: Codable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NSError(domain: "Unknown error", code: 0, userInfo: nil)
        }
        do {
            let decoder = JSONDecoder()
            let responseData = try decoder.decode(T.self, from: data)
            return responseData
        } catch {
            throw error
        }
    }

    
}


