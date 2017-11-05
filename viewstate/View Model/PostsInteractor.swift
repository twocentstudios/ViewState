//
//  PostsInteractor.swift
//  viewstate
//
//  Created by Christopher Trott on 8/7/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

final class PostsInteractor {
    enum Command {
        case load
    }
    
    enum Effect { }
    
    let commandSink: Signal<Command, NoError>.Observer
    private let commandSignal: Signal<Command, NoError>
    
    let viewModel: Property<PostsViewModel>
    let effect: Signal<Effect, NoError>
    
    let userId: Int
    let service: PostsServiceType
    
    init(userId: Int, service: PostsServiceType, scheduler: SchedulerContext = SchedulerContext()) {
        self.userId = userId
        self.service = service
        
        (self.commandSignal, self.commandSink) = Signal<Command, NoError>.pipe()
        
        let initialViewModel = PostsViewModel(state: .initialized)
        let initialEffect: Reducer.Effect? = nil
        let initialState = Reducer.State(viewModel: initialViewModel, effect: initialEffect)
        
        let externalCommandSignal = commandSignal.map(PostsInteractor.toCommand)

        let (internalCommandSignal, internalCommandSink) = Signal<Reducer.Command, NoError>.pipe()
        let allCommandsSignal = Signal.merge([externalCommandSignal, internalCommandSignal])
        
        let stateReducer = allCommandsSignal
            .observe(on: scheduler.state)
            .scan(initialState) { (state: Reducer.State, command: Reducer.Command) -> Reducer.State in
                return Reducer.reduce(state: state, command: command)
            }
        
        let viewModelSignal = stateReducer
            .map { $0.viewModel }
            .skipRepeats()
            .observe(on: scheduler.output)
        
        let effectSignal = stateReducer
            .map { $0.effect }
            .skipNil()
            .map(PostsInteractor.toEffect)
            .skipNil()
            .observe(on: scheduler.output)
        
        stateReducer
            .observe(on: scheduler.work)
            .map { $0.effect }
            .skipNil()
            .flatMap(FlattenStrategy.merge) { (effect: Reducer.Effect) -> SignalProducer<Reducer.Command, NoError> in
                return PostsInteractor.toSignalProducer(effect: effect, userId: userId, service: service)
            }
            .observe(internalCommandSink)
        
        viewModel = Property(initial: initialViewModel, then: viewModelSignal)
        effect = effectSignal
    }
    
    static private func toCommand(_ command: Command) -> Reducer.Command {
        switch command {
        case .load: return .load
        }
    }
    
    static private func toEffect(_ effect: Reducer.Effect) -> Effect? {
        return nil
    }
    
    static private func toSignalProducer(effect: Reducer.Effect, userId: Int, service: PostsServiceType) -> SignalProducer<Reducer.Command, NoError> {
        switch effect {
        case .load:
            return service.readPosts(userId: userId)
                .map { (posts: [Post]) -> Reducer.Command in
                    return Reducer.Command.loaded(posts)
                }
                .flatMapError { (error: NSError) -> SignalProducer<Reducer.Command, NoError> in
                    return SignalProducer(value: Reducer.Command.failed(error))
                }
        }
    }
}

extension PostsInteractor {
    struct Reducer {
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
}
