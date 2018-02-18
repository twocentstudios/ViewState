//
//  SchedulerContext.swift
//  viewstate
//
//  Created by Christopher Trott on 8/7/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol SchedulerContextType {
    var state: Scheduler { get }
    var work: Scheduler { get }
    var output: Scheduler { get }
}

struct SchedulerContext: SchedulerContextType {
    let state: Scheduler
    let work: Scheduler
    let output: Scheduler
    
    static func interactor() -> SchedulerContext {
        return SchedulerContext(state: QueueScheduler(), work: QueueScheduler(), output: UIScheduler())
    }
}
