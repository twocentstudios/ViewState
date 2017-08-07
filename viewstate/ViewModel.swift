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

extension ErrorViewModel {
    init(error: Error) {
        self.message = error.localizedDescription
        self.actionTitle = nil
    }
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
    
    init(state: State) {
        self.state = state
        
        switch state {
        case .initialized:
            self.isLoading = false
            self.text = nil
        case .loading:
            self.isLoading = true
            self.text = nil
        case .loaded(let text):
            self.isLoading = false
            self.text = text
        }
    }
}

struct ProfileHeaderViewModel {
    let avatarURL: URL?
    let username: LoadingTextViewModel
    let friendsCount: LoadingTextViewModel
}

extension ProfileHeaderViewModel {
    init(user: User) {
        self.avatarURL = user.avatarURL
        self.username = LoadingTextViewModel(state: .loaded(NSAttributedString(string: user.username)))
        self.friendsCount = LoadingTextViewModel(state: .loaded(NSAttributedString(string: String(user.friendsCount))))
    }
    
    static func initialized() -> ProfileHeaderViewModel {
        return ProfileHeaderViewModel(avatarURL: nil,
                                      username: LoadingTextViewModel(state: .initialized),
                                      friendsCount: LoadingTextViewModel(state: .initialized))
    }
    
    static func loading() -> ProfileHeaderViewModel {
        return ProfileHeaderViewModel(avatarURL: nil,
                                      username: LoadingTextViewModel(state: .loading),
                                      friendsCount: LoadingTextViewModel(state :.loading))
    }
}

struct ProfileAttributeViewModel {
    let name: String?
    let value: String?
}

extension ProfileAttributeViewModel {
    static func from(_ user: User) -> [ProfileAttributeViewModel] {
        let location = ProfileAttributeViewModel(name: "Location", value: user.location)
        let website = ProfileAttributeViewModel(name: "Website", value: user.website.absoluteString)
        return [location, website]
    }
}

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
        
        let profileViewModels = profileViewModel.viewModels.map(UserViewModel.toViewModel)
        let postsHeaderViewModels = [ViewModelType.contentHeader("Posts")]
        let postsViewModels = postsViewModel.viewModels.map(UserViewModel.toViewModel)
        
        let innerViewModels: [ViewModelType] = profileViewModels + postsHeaderViewModels + postsViewModels
        
        self.viewModels = innerViewModels
    }
    
    private static func toViewModel(_ viewModel: ProfileViewModel.ViewModelType) -> UserViewModel.ViewModelType {
        switch viewModel {
        case .header(let header):
            return ViewModelType.profileHeader(header)
        case .attribute(let attribute):
            return ViewModelType.profileAttribute(attribute)
        case .error(let error):
            return ViewModelType.profileError(error)
        }
    }
    
    private static func toViewModel(_ viewModel: PostsViewModel.ViewModelType) -> UserViewModel.ViewModelType {
        switch viewModel {
        case .loading:
            return ViewModelType.contentLoading
        case .post(let post):
            return ViewModelType.post(post)
        case .empty(let empty):
            return ViewModelType.contentEmpty(empty)
        case .error(let error):
            return ViewModelType.contentError(error)
        }
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
    
    init(state: State) {
        self.state = state
        
        switch state {
        case .initialized:
            let initializedProfileHeaderViewModel = ViewModelType.header(ProfileHeaderViewModel.initialized())
            self.viewModels = [initializedProfileHeaderViewModel]
        case .loading:
            let loadingProfileHeaderViewModel = ViewModelType.header(ProfileHeaderViewModel.loading())
            self.viewModels = [loadingProfileHeaderViewModel]
        case .loaded(let user):
            let profileHeaderViewModel = ViewModelType.header(ProfileHeaderViewModel(user: user))
            let attributes = ProfileAttributeViewModel.from(user).map { ViewModelType.attribute($0) }
            self.viewModels = [profileHeaderViewModel] + attributes
        case .failed:
            let errorViewModel = ViewModelType.error(ErrorViewModel(message: "Couldn't load profile.", actionTitle: "Retry"))
            self.viewModels = [errorViewModel]
        }
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
