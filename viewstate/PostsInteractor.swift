//
//  PostsInteractor.swift
//  viewstate
//
//  Created by Christopher Trott on 8/7/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import Foundation

struct PostsViewModelReducer {
    enum Command {
        case load
        case loaded([Post])
        case failed(Error)
    }
    
    enum Effect {
        case load
    }
    
    struct State {
        let viewModel: PostsViewModel
        let effect: Effect?
    }
    
    static func reduce(state: State, command: Command) -> State {
        let viewModel: PostsViewModel = state.viewModel
        let _: Effect? = state.effect
        let viewModelState: PostsViewModel.State = viewModel.state
        let noChange = State(viewModel: viewModel, effect: nil)
        
        switch (command, viewModelState) {
            
        case (.load, .initialized),
             (.load, .loaded),
             (.load, .failed):
            return State(viewModel: PostsViewModel(state: .loading), effect: .load)
            
        case (.load, .loading):
            return noChange // ignore `.load` messages if we're already in a loading state.
            
        case (.loaded(let posts), .loading):
            return State(viewModel: PostsViewModel(state: .loaded(posts)), effect: nil)
            
        case (.loaded, _):
            return noChange // `.loaded` command can not be handled from any other view state besides `.loading`.
            
        case (.failed(let error), .loading):
            return State(viewModel: PostsViewModel(state: .failed(error)), effect: nil)
            
        case (.failed, _):
            return noChange // `.failed` command can not be handled from any other view state besides `.loading`.
        }
    }
}
