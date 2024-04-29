//
//  Post.swift
//  iOSTest
//
//  Created by MacBook Pro on 29/04/24.
//

import Foundation

struct Post: Codable {
    let id: Int
    let title: String
    let body: String
    var additionalDetails: String? // Additional details to be computed later
}
