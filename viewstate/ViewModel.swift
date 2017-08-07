//
//  ViewModel.swift
//  viewstate
//
//  Created by Christopher Trott on 8/7/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import Foundation

struct ErrorViewModel {
    let message: String?
    let actionTitle: String?
}

struct LoadingTextViewModel {
    enum State {
        case initialized
        case loading
        case loaded(NSAttributedString?)
    }
    
    let state: State
    
    let isLoading: Bool
    let text: NSAttributedString?
}

struct ProfileHeaderViewModel {
    let avatarURL: URL?
    let username: LoadingTextViewModel
    let friendsCount: LoadingTextViewModel
}

struct ProfileAttributeViewModel {
    let name: String?
    let value: String?
}

struct PostViewModel {
    let date: String?
    let body: String?
}

struct UserViewModel {
    enum ViewModelType {
        case profileHeader(ProfileHeaderViewModel)
        case profileError(ErrorViewModel)
        case profileAttribute(ProfileAttributeViewModel)
        case contentHeader(String)
        case contentLoading
        case contentEmpty(String)
        case contentError(ErrorViewModel)
        case post(PostViewModel)
    }
    
    let profileViewModel: ProfileViewModel
    let postsViewModel: PostsViewModel
    
    let viewModels: [ViewModelType]
    
    init(profileViewModel: ProfileViewModel, postsViewModel: PostsViewModel) {
        self.profileViewModel = profileViewModel
        self.postsViewModel = postsViewModel
        
        var innerViewModels: [ViewModelType] = []
        
        // Convert ProfileViewModel.ViewModelType to UserViewModel.ViewModelType
        let profileInnerViewModels = profileViewModel.viewModels.map(UserViewModel.toViewModels)
        innerViewModels.append(contentsOf: profileInnerViewModels)
        
        // Convert PostsViewModel.ViewModelType to UserViewModel.ViewModelType
        let postsViewModel = postsViewModel.viewModels.map(UserViewModel.toViewModels)
        innerViewModels.append(contentsOf: postsViewModel)
        
        self.viewModels = innerViewModels
    }
    
    private static func toViewModels(_ viewModels: ProfileViewModel.ViewModelType) -> UserViewModel.ViewModelType {
        fatalError()
        /* ... */
    }
    
    private static func toViewModels(_ viewModels: PostsViewModel.ViewModelType) -> UserViewModel.ViewModelType {
        fatalError()
        /* ... */
    }
}

struct ProfileViewModel {
    enum ViewModelType {
        case header(ProfileHeaderViewModel)
        case attribute(ProfileAttributeViewModel)
        case error(ErrorViewModel)
    }
    
    enum State {
        case initialized
        case loading
        case loaded(User)
        case failed(Error)
    }
    
    let state: State
    
    let viewModels: [ViewModelType]
    
    init(state: State) { /* ... */ fatalError() }
}

struct PostsViewModel {
    enum State {
        case initialized
        case loading
        case loaded([PostViewModel])
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
    
    //        init(state: State) { /* ... */ }
}
