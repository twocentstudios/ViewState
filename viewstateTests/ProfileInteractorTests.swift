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
    
    func testInitializeLoad() {
        let initialViewModel = ProfileViewModel(state: .initialized)
        let initialState = Reducer.State(viewModel: initialViewModel, effect: nil)
        
        let command = Reducer.Command.load
        
        let targetViewModel = ProfileViewModel(state: .loading)
        let targetEffect = Reducer.Effect.load
        let targetState = Reducer.State(viewModel: targetViewModel, effect: targetEffect)
        
        let result = ProfileInteractor.Reducer.reduce(state: initialState, command: command)
        
        XCTAssertEqual(targetState, result)
    }
}
