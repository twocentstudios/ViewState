//
//  ProfileInteractor.swift
//  viewstate
//
//  Created by Christopher Trott on 8/7/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

final class ProfileInteractor {
    enum Command {
        case load
    }
    
    enum OutputAction { }
    
    let commandSink: Signal<Command, NoError>.Observer
    private let commandSignal: Signal<Command, NoError>
    
    let viewModel: Property<ProfileViewModel>
    let action: Signal<OutputAction, NoError>
    
    let userId: Int
    let service: ProfileServiceType
    
    init(userId: Int, service: ProfileServiceType, scheduler: SchedulerContext = SchedulerContext()) {
        self.userId = userId
        self.service = service
        
        (self.commandSignal, self.commandSink) = Signal<Command, NoError>.pipe()
        
        let initialViewModel = ProfileViewModel(state: .initialized)
        let initialEffect: Reducer.Effect? = nil
        let initialState = Reducer.State(viewModel: initialViewModel, effect: initialEffect)
        
        let externalCommandSignal = commandSignal.map(ProfileInteractor.toCommand)
        let (internalCommandSignal, internalCommandSink) = Signal<Reducer.Command, NoError>.pipe()
        let allCommandsSignal = Signal.merge([externalCommandSignal, internalCommandSignal])
        
        let stateReducer = allCommandsSignal
            .observe(on: scheduler.state)
            .scan(initialState) { (state: Reducer.State, command: Reducer.Command) -> Reducer.State in
                return Reducer.reduce(state: state, command: command)
            }
        
        let viewModelSignal = stateReducer
            .map { $0.viewModel }
            // .skipRepeats()  // TODO: equatable definitions
            .observe(on: scheduler.output)
        
        let actionSignal = stateReducer
            .map { $0.effect }
            .skipNil()
            .map(ProfileInteractor.toOutputAction)
            .skipNil()
            .observe(on: scheduler.output)
        
        stateReducer
            .observe(on: scheduler.work)
            .map { $0.effect }
            .skipNil()
            .flatMap(FlattenStrategy.merge) { (effect: Reducer.Effect) -> SignalProducer<Reducer.Command, NoError> in
                return ProfileInteractor.toSignalProducer(effect: effect, userId: userId, service: service)
            }
            .observe(internalCommandSink)
        
        viewModel = Property(initial: initialViewModel, then: viewModelSignal)
        action = actionSignal
    }
    
    static func toCommand(_ command: Command) -> Reducer.Command {
        switch command {
        case .load: return .load
        }
    }
    
    static func toOutputAction(_ effect: Reducer.Effect) -> OutputAction? {
        return nil
    }
    
    static func toSignalProducer(effect: Reducer.Effect, userId: Int, service: ProfileServiceType) -> SignalProducer<Reducer.Command, NoError> {
        switch effect {
        case .load:
            return service.readProfile(userId: userId)
                .map { (user: User) -> Reducer.Command in
                    return Reducer.Command.loaded(user)
                }
                .flatMapError { (error: NSError) -> SignalProducer<Reducer.Command, NoError> in
                    return SignalProducer(value: Reducer.Command.failed(error))
                }
        }
    }
}

extension ProfileInteractor {
    struct Reducer {
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
}
