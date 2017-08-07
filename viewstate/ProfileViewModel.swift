//
//  ProfileViewModel.swift
//  viewstate
//
//  Created by Christopher Trott on 8/7/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import Foundation

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