//
//  Mocks.swift
//  viewstateTests
//
//  Created by Christopher Trott on 12/16/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import Foundation
@testable import viewstate

enum Mocks {
    
    static let user = User(id: 0,
                           avatarURL: URL(string: "https://en.gravatar.com/userimage/30721452/beb8f097031268cc19d5e6261603d419.jpeg")!,
                           username: "twocentstudios",
                           friendsCount: 100,
                           location: "Chicago",
                           website: URL(string: "twocentstudios.com")!)
    
    static let error = NSError(domain: "", code: 0, userInfo: nil)
}
