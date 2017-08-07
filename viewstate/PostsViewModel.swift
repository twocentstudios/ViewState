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
