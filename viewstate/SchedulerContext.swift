//
//  SchedulerContext.swift
//  viewstate
//
//  Created by Christopher Trott on 8/7/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import Foundation
import ReactiveSwift

struct SchedulerContext {
    let state: Scheduler
    let work: Scheduler
    let output: Scheduler
    
    init(state: Scheduler = QueueScheduler(), work: Scheduler = QueueScheduler(), output: Scheduler = UIScheduler()) {
        self.state = state
        self.work = work
        self.output = output
    }
}
