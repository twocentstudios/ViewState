//
//  ProfileInteractor.swift
//  viewstate
//
//  Created by Christopher Trott on 8/7/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import Foundation

struct ProfileViewModelReducer {
    enum Command {
        case load
        case loaded(User)
        case failed(Error)
    }
    
    enum Effect {
        case load
    }
    
    struct State {
        let viewModel: ProfileViewModel
        let effect: Effect?
    }
    
    static func reduce(state: State, command: Command) -> State {
        let viewModel: ProfileViewModel = state.viewModel
        let _: Effect? = state.effect
        let viewModelState: ProfileViewModel.State = viewModel.state
        let noChange = State(viewModel: viewModel, effect: nil)
        
        switch (command, viewModelState) {
            
        case (.load, .initialized),
             (.load, .loaded),
             (.load, .failed):
            return State(viewModel: ProfileViewModel(state: .loading), effect: .load)
            
        case (.load, .loading):
            return noChange // ignore `.load` messages if we're already in a loading state.
            
        case (.loaded(let user), .loading):
            return State(viewModel: ProfileViewModel(state: .loaded(user)), effect: nil)
            
        case (.loaded, _):
            return noChange // `.loaded` command can not be handled from any other view state besides `.loading`.
            
        case (.failed(let error), .loading):
            return State(viewModel: ProfileViewModel(state: .failed(error)), effect: nil)
            
        case (.failed, _):
            return noChange // `.failed` command can not be handled from any other view state besides `.loading`.
        }
    }
}
