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

protocol ProfileServiceType {
    func readProfile(userId: Int) -> SignalProducer<User, NSError>
}

struct SchedulerContext {
    let state: Scheduler
    let work: Scheduler
    let output: Scheduler
}

extension SchedulerContext {
    static func interactor() -> SchedulerContext {
        return SchedulerContext(state: QueueScheduler(), work: QueueScheduler(), output: UIScheduler())
    }
}

class ProfileInteractor {
    enum OutputAction { }
    
    let loadSink: Signal<Void, NoError>.Observer
    private let loadSignal: Signal<Void, NoError>
    
    let viewModel: Property<ProfileViewModel>
    let action: Signal<OutputAction, NoError>
    
    private let stateScheduler = QueueScheduler()
    private let workScheduler = QueueScheduler()
    private let outputScheduler = UIScheduler()

    let userId: Int
    let service: ProfileServiceType
    
    init(userId: Int, service: ProfileServiceType, scheduler: SchedulerContext = SchedulerContext.interactor()) {
        self.userId = userId
        self.service = service
        
        (self.loadSignal, self.loadSink) = Signal<Void, NoError>.pipe()
        
        let initialViewModel = ProfileViewModel(state: .initialized)
        let initialEffect: ProfileViewModelReducer.Effect? = nil
        let initialState = ProfileViewModelReducer.State(viewModel: initialViewModel, effect: initialEffect)
        
        let loadCommand = loadSignal.map { _ in ProfileViewModelReducer.Command.load }
        let (internalCommandSignal, internalCommandSink) = Signal<ProfileViewModelReducer.Command, NoError>.pipe()
        
        let allCommands = Signal.merge([loadCommand, internalCommandSignal])
        
        let stateReducer = allCommands
            .observe(on: scheduler.state)
            .scan(initialState) { (state: ProfileViewModelReducer.State, command: ProfileViewModelReducer.Command) -> ProfileViewModelReducer.State in
                return ProfileViewModelReducer.reduce(state: state, command: command)
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
            .flatMap(FlattenStrategy.merge) { (effect: ProfileViewModelReducer.Effect) -> SignalProducer<ProfileViewModelReducer.Command, NoError> in
                return ProfileInteractor.toSignalProduer(effect: effect, userId: userId, service: service)
            }
            .observe(internalCommandSink)
        
        viewModel = Property(initial: initialViewModel, then: viewModelSignal)
        action = actionSignal
    }
    
    static func toOutputAction(_ effect: ProfileViewModelReducer.Effect) -> OutputAction? {
        return nil
    }
    
    static func toSignalProduer(effect: ProfileViewModelReducer.Effect, userId: Int, service: ProfileServiceType) -> SignalProducer<ProfileViewModelReducer.Command, NoError> {
        switch effect {
        case .load:
            return service.readProfile(userId: userId)
                .map { (user: User) -> ProfileViewModelReducer.Command in
                    return ProfileViewModelReducer.Command.loaded(user)
                }
                .flatMapError { (error: NSError) -> SignalProducer<ProfileViewModelReducer.Command, NoError> in
                    return SignalProducer(value: ProfileViewModelReducer.Command.failed(error))
                }
        }
    }
}

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
