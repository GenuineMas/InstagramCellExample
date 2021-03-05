//
//  Posts.swift
//  InstagramCellExample
//
//  Created by Genuine on 05.03.2021.
//

import Foundation


struct Post: Codable {
    let id: String
    let username: String
    let location: String
    let userPhoto: String
    let postPhoto: String
    let liked_by: String
    let comments: String
    let dateOfPublic: String
}

struct Posts: Codable {
    var posts: [Post]
}


