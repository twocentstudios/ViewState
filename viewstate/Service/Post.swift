//
//  Post.swift
//  viewstate
//
//  Created by Christopher Trott on 8/12/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import Foundation

struct Post {
    let id: Int
    let date: Date
    let body: String
}

extension Post: Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id &&
            lhs.date == rhs.date &&
            lhs.body == rhs.body
    }
}
