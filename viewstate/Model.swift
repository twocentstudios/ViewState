//
//  Model.swift
//  viewstate
//
//  Created by Christopher Trott on 8/7/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import Foundation

struct User {
    let id: Int
    let avatarURL: URL
    let username: String
    let friendsCount: Int
    let location: String
    let website: URL
}

struct Post {
    let id: Int
    let date: Date
    let body: String
}

struct Photo {
    let id: Int
    let date: Date
    let url: URL
}
