//
//  UserInteractor.swift
//  viewstate
//
//  Created by Christopher Trott on 8/7/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

final class UserInteractor {
    enum Command {
        case loadProfile
        case loadPosts
    }
    
    enum Effect { }
    
    let commandSink: Signal<Command, NoError>.Observer
    private let commandSignal: Signal<Command, NoError>
    
    let viewModel: Property<UserViewModel>
    let effect: Signal<Effect, NoError>
    
    let userId: Int
    
    init(userId: Int, profileService: ProfileServiceType, postsService: PostsServiceType, scheduler: SchedulerContextType = SchedulerContext.interactor()) {
        self.userId = userId
        
        (self.commandSignal, self.commandSink) = Signal<Command, NoError>.pipe()
        
        let profileInteractor = ProfileInteractor(userId: userId, service: profileService)
        let postsInteractor = PostsInteractor(userId: userId, service: postsService)
        
        let initialViewModel = UserViewModel(profileViewModel: profileInteractor.viewModel.value, postsViewModel: postsInteractor.viewModel.value)
        let viewModelSignal = Signal
            .combineLatest(profileInteractor.viewModel.signal, postsInteractor.viewModel.signal)
            .map(UserViewModel.init)
        
        viewModel = Property(initial: initialViewModel, then: viewModelSignal)
        
        commandSignal.map(ProfileInteractor.fromCommand).skipNil().observe(profileInteractor.commandSink)
        commandSignal.map(PostsInteractor.fromCommand).skipNil().observe(postsInteractor.commandSink)
        
        effect = Signal.merge([
            profileInteractor.effect.map(UserInteractor.toEffect).skipNil(),
            postsInteractor.effect.map(UserInteractor.toEffect).skipNil()
            ])
    }
    
    static private func toEffect(_ effect: ProfileInteractor.Effect) -> Effect? {
        return nil
    }
    
    static private func toEffect(_ effect: PostsInteractor.Effect) -> Effect? {
        return nil
    }
}

extension ProfileInteractor {
    static func fromCommand(_ command: UserInteractor.Command) -> Command? {
        switch command {
        case .loadProfile: return .load
        case .loadPosts: return nil
        }
    }
}

extension PostsInteractor {
    static func fromCommand(_ command: UserInteractor.Command) -> Command? {
        switch command {
        case .loadProfile: return nil
        case .loadPosts: return .load
        }
    }
}
