//
//  Mocks.swift
//  viewstateTests
//
//  Created by Christopher Trott on 12/16/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
@testable import viewstate

enum Mocks {
    
    static let user = User(id: 0,
                           avatarURL: URL(string: "https://en.gravatar.com/userimage/30721452/beb8f097031268cc19d5e6261603d419.jpeg")!,
                           username: "twocentstudios",
                           friendsCount: 100,
                           location: "Chicago",
                           website: URL(string: "twocentstudios.com")!)
    
    static let error = NSError(domain: "", code: 0, userInfo: nil)
    
    final class ProfileService: ProfileServiceType {
        
        private var result: Result<User, NSError>
        
        init(_ user: User) {
            result = Result(value: user)
        }
        
        init(_ error: NSError) {
            result = Result(error: error)
        }
        
        func setUser(_ user: User) {
            result = Result(value: user)
        }
        
        func setError(_ error: NSError) {
            result = Result(error: error)
        }
        
        func readProfile(userId: Int) -> SignalProducer<User, NSError> {
            return SignalProducer(result: result)
        }
    }
}

struct TestSchedulerContext: SchedulerContextType {
    
    var state: Scheduler {
        return testState
    }
    var work: Scheduler {
        return testWork
    }
    var output: Scheduler {
        return testOutput
    }
    
    private let testState: TestScheduler
    private let testWork: TestScheduler
    private let testOutput: TestScheduler
    
    init(state: TestScheduler = TestScheduler(), work: TestScheduler = TestScheduler(), output: TestScheduler = TestScheduler()) {
        self.testState = state
        self.testWork = work
        self.testOutput = output
    }
    
    func nextOutput() {
        testState.advance()
        testOutput.advance()
    }
    
    func doWork() {
        testWork.advance()
    }
}
