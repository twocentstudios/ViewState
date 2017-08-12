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
        let post1 = Post(id: 0, date: Date(), body: "Who decided to call it \"toothpaste\" and not \"floss sauce\"?")
        return SignalProducer(value: [post1])
            .delay(4, on: QueueScheduler())
    }
}

final class PostsErrorService: PostsServiceType {
    func readPosts(userId: Int) -> SignalProducer<[Post], NSError> {
        let post1 = Post(id: 0, date: Date(), body: "This is a post")
        let error = NSError(domain: "", code: 0, userInfo: nil)
        return SignalProducer(value: [post1])
            .delay(4, on: QueueScheduler())
            .attempt { posts in
                return Result(error: error)
            }
    }
}
