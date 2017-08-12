//
//  User.swift
//  viewstate
//
//  Created by Christopher Trott on 8/12/17.
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

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id &&
            lhs.avatarURL == rhs.avatarURL &&
            lhs.username == rhs.username &&
            lhs.friendsCount == rhs.friendsCount &&
            lhs.location == rhs.location &&
            lhs.website == rhs.website
    }
}
