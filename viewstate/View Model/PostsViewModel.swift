//
//  PostsViewModel.swift
//  viewstate
//
//  Created by Christopher Trott on 8/7/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import Foundation

struct PostViewModel {
    let date: String?
    let body: String?
}

extension PostViewModel {
    init(post: Post) {
        self.date = post.date.description // TODO: use DateFormatter
        self.body = post.body
    }
}

struct PostsViewModel {
    enum State {
        case initialized
        case loading
        case loaded([Post])
        case failed(Error)
    }
    
    enum ViewModelType {
        case loading
        case post(PostViewModel)
        case empty(String)
        case error(ErrorViewModel)
    }
    
    let state: State
    
    let viewModels: [ViewModelType]
    
    init(state: State) {
        self.state = state
        
        switch state {
        case .initialized:
            self.viewModels = []
        case .loading:
            let loadingViewModel = ViewModelType.loading
            self.viewModels = [loadingViewModel]
        case .loaded(let posts):
            if posts.count > 0 {
                let postViewModels = posts.map { PostViewModel(post: $0) }.map { ViewModelType.post($0) }
                self.viewModels = postViewModels
            } else {
                let emptyViewModel = ViewModelType.empty("No posts yet")
                self.viewModels = [emptyViewModel]
            }
        case .failed:
            let errorViewModel = ViewModelType.error(ErrorViewModel(message: "Couldn't load posts.", actionTitle: "Retry"))
            self.viewModels = [errorViewModel]
        }
    }
}

extension PostViewModel: Equatable {
    static func == (lhs: PostViewModel, rhs: PostViewModel) -> Bool {
        return lhs.date == rhs.date &&
            lhs.body == rhs.body
    }
}

extension PostsViewModel: Equatable {
    static func == (lhs: PostsViewModel, rhs: PostsViewModel) -> Bool {
        return lhs.state == rhs.state
    }
}

extension PostsViewModel.State: Equatable {
    static func == (lhs: PostsViewModel.State, rhs: PostsViewModel.State) -> Bool {
        switch (lhs, rhs) {
        case (.initialized, .initialized): return true
        case (.loading, .loading): return true
        case let (.loaded(l), .loaded(r)): return l == r
        case let (.failed(l), .failed(r)): return l.localizedDescription == r.localizedDescription
        default: return false
        }
    }
}
