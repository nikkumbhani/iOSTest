//
//  Comment.swift
//  iOSTest
//
//  Created by MacBook Pro on 29/04/24.
//

import Foundation

struct Comment: Codable {
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
}
