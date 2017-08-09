//
//  PostsService.swift
//  viewstate
//
//  Created by Christopher Trott on 8/8/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol PostsServiceType {
    func readPosts(userId: Int) -> SignalProducer<[Post], NSError>
}

final class PostsService: PostsServiceType {
    func readPosts(userId: Int) -> SignalProducer<[Post], NSError> {
        let post1 = Post(id: 0, date: Date(), body: "This is a post")
        return SignalProducer(value: [post1])
            .delay(3, on: QueueScheduler())
    }
}
