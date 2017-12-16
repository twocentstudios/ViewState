//
//  ProfileInteractorTests.swift
//  viewstateTests
//
//  Created by Christopher Trott on 12/16/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import XCTest
import Foundation
import ReactiveSwift
import Result
@testable import viewstate

class ProfileInteractorTests: XCTestCase {

    typealias Command = ProfileInteractor.Command
    typealias Effect = ProfileInteractor.Effect
    
    let user = Mocks.user
    let error = Mocks.error
    
    func testInitialState() {
        let schedulerContext = TestSchedulerContext()
        
        let interactor = ProfileInteractor(userId: user.id, service: Mocks.ProfileService(user), scheduler: schedulerContext)
        
        let targetViewModel = ProfileViewModel(state: .initialized)
        
        let result = interactor.viewModel.value
        
        XCTAssertEqual(targetViewModel, result)
    }
    
    func testInitializedLoad() {
        let schedulerContext = TestSchedulerContext()
        
        let interactor = ProfileInteractor(userId: user.id, service: Mocks.ProfileService(user), scheduler: schedulerContext)
        
        let effect: TestObserver<Effect, NoError> = TestObserver()
        interactor.effect.observe(effect.observer)
        
        let command = Command.load
        
        let loadingViewModel = ProfileViewModel(state: .loading)
        let loadedViewModel = ProfileViewModel(state: .loaded(user))
        
        interactor.commandSink.send(value: command)
        
        schedulerContext.nextOutput()
        
        let loadingResult = interactor.viewModel.value
        
        XCTAssertEqual(loadingViewModel, loadingResult)
        effect.assertValueCount(0)
        effect.assertDidNotComplete()
        
        schedulerContext.doWork()
        schedulerContext.nextOutput()
        
        let loadedResult = interactor.viewModel.value
        
        XCTAssertEqual(loadedViewModel, loadedResult)
        effect.assertValueCount(0)
        effect.assertDidNotComplete()
    }
}

class ProfileInteractorReducerTests: XCTestCase {
    
    typealias Reducer = ProfileInteractor.Reducer
    
    let user = Mocks.user
    let error = Mocks.error
    
    func testInitializedLoad() {
        let initialViewModel = ProfileViewModel(state: .initialized)
        let initialState = Reducer.State(viewModel: initialViewModel, effect: nil)
        
        let command = Reducer.Command.load
        
        let targetViewModel = ProfileViewModel(state: .loading)
        let targetEffect = Reducer.Effect.load
        let targetState = Reducer.State(viewModel: targetViewModel, effect: targetEffect)
        
        let result = Reducer.reduce(state: initialState, command: command)
        
        XCTAssertEqual(targetState, result)
    }

    func testLoadingLoaded() {
        let initialViewModel = ProfileViewModel(state: .loading)
        let initialState = Reducer.State(viewModel: initialViewModel, effect: nil)

        let command = Reducer.Command.loaded(user)
        
        let targetViewModel = ProfileViewModel(state: .loaded(user))
        let targetEffect: Reducer.Effect? = nil
        let targetState = Reducer.State(viewModel: targetViewModel, effect: targetEffect)
        
        let result = Reducer.reduce(state: initialState, command: command)
        
        XCTAssertEqual(targetState, result)
    }
    
    func testLoadingFailed() {
        let initialViewModel = ProfileViewModel(state: .loading)
        let initialState = Reducer.State(viewModel: initialViewModel, effect: nil)
        
        let command = Reducer.Command.failed(error)
        
        let targetViewModel = ProfileViewModel(state: .failed(error))
        let targetEffect: Reducer.Effect? = nil
        let targetState = Reducer.State(viewModel: targetViewModel, effect: targetEffect)
        
        let result = Reducer.reduce(state: initialState, command: command)
        
        XCTAssertEqual(targetState, result)
    }
    
    func testFailedLoad() {
        let initialViewModel = ProfileViewModel(state: .failed(error))
        let initialState = Reducer.State(viewModel: initialViewModel, effect: nil)
        
        let command = Reducer.Command.load
        
        let targetViewModel = ProfileViewModel(state: .loading)
        let targetEffect: Reducer.Effect? = Reducer.Effect.load
        let targetState = Reducer.State(viewModel: targetViewModel, effect: targetEffect)
        
        let result = Reducer.reduce(state: initialState, command: command)
        
        XCTAssertEqual(targetState, result)
    }
    
    func testLoadedLoad() {
        let initialViewModel = ProfileViewModel(state: .loaded(user))
        let initialState = Reducer.State(viewModel: initialViewModel, effect: nil)
        
        let command = Reducer.Command.load
        
        let targetViewModel = ProfileViewModel(state: .loading)
        let targetEffect: Reducer.Effect? = Reducer.Effect.load
        let targetState = Reducer.State(viewModel: targetViewModel, effect: targetEffect)
        
        let result = Reducer.reduce(state: initialState, command: command)
        
        XCTAssertEqual(targetState, result)
    }
}

