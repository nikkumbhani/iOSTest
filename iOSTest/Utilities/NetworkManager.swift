//
//  NetworkManager.swift
//  iOSTest
//
//  Created by MacBook Pro on 29/04/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchPosts(page: Int, completion: @escaping ([Post]?, Error?) -> Void) {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts?_page=\(page)")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                completion(posts, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func fetchComments(forPostId postId: Int, completion: @escaping ([Comment]?, Error?) -> Void) {
        // Construct the URL
        let urlString = "https://jsonplaceholder.typicode.com/comments?postId=\(postId)"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        // Create a URLSessionDataTask
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Handle the response
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                completion(nil, NSError(domain: "HTTP Error", code: statusCode, userInfo: nil))
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No Data", code: 0, userInfo: nil))
                return
            }
            
            // Parse the JSON data into an array of Comment objects
            do {
                let comments = try JSONDecoder().decode([Comment].self, from: data)
                completion(comments, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        // Start the URLSessionDataTask
        task.resume()
    }
}
