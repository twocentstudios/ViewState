//
//  ProfileInteractorTests.swift
//  viewstateTests
//
//  Created by Christopher Trott on 12/16/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import XCTest
@testable import viewstate

class ProfileInteractorTests: XCTestCase {
    
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
