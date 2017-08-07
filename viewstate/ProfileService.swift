//
//  ProfileService.swift
//  viewstate
//
//  Created by Christopher Trott on 8/7/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol ProfileServiceType {
    func readProfile(userId: Int) -> SignalProducer<User, NSError>
}

final class ProfileService: ProfileServiceType {
    func readProfile(userId: Int) -> SignalProducer<User, NSError> {
        let user = User(id: userId,
                        avatarURL: URL(string: "https://en.gravatar.com/userimage/30721452/beb8f097031268cc19d5e6261603d419.jpeg")!,
                        username: "twocentstudios",
                        friendsCount: 100,
                        location: "Chicago",
                        website: URL(string: "twocentstudios.com")!)
        return SignalProducer(value: user)
            .delay(3, on: QueueScheduler())
    }
}
