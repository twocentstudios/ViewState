//
//  UserViewModel.swift
//  viewstate
//
//  Created by Christopher Trott on 8/7/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import Foundation

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

extension UserViewModel {
    func numberOfRows(in section: Int) -> Int {
        return viewModels.count
    }
    
    func viewModel(at indexPath: IndexPath) -> ViewModelType? {
        return viewModels[safe: indexPath.row]
    }
}

extension UserViewModel: Equatable {
    static func == (lhs: UserViewModel, rhs: UserViewModel) -> Bool {
        return lhs.profileViewModel == rhs.profileViewModel &&
            lhs.postsViewModel == rhs.postsViewModel
    }
}

extension UserViewModel.ViewModelType: Equatable {
    static func == (lhs: UserViewModel.ViewModelType, rhs: UserViewModel.ViewModelType) -> Bool {
        switch (lhs, rhs) {
        case let (.profileHeader(l), .profileHeader(r)): return l == r
        case let (.profileError(l), .profileError(r)): return l == r
        case let (.profileAttribute(l), .profileAttribute(r)): return l == r
        case let (.contentHeader(l), .contentHeader(r)): return l == r
        case (.contentLoading, .contentLoading): return true
        case let (.contentEmpty(l), .contentEmpty(r)): return l == r
        case let (.contentError(l), .contentError(r)): return l == r
        case let (.post(l), .post(r)): return l == r
        default: return false
        }
    }
}

extension Collection {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
