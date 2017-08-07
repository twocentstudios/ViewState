//
//  ViewModel.swift
//  viewstate
//
//  Created by Christopher Trott on 8/7/17.
//  Copyright © 2017 twocentstudios. All rights reserved.
//

import Foundation

struct ErrorViewModel {
    let message: String?
    let actionTitle: String?
}

extension ErrorViewModel {
    init(error: Error) {
        self.message = error.localizedDescription
        self.actionTitle = nil
    }
}

struct LoadingTextViewModel {
    enum State {
        case initialized
        case loading
        case loaded(NSAttributedString?)
    }
    
    let state: State
    
    let isLoading: Bool
    let text: NSAttributedString?
    
    init(state: State) {
        self.state = state
        
        switch state {
        case .initialized:
            self.isLoading = false
            self.text = nil
        case .loading:
            self.isLoading = true
            self.text = nil
        case .loaded(let text):
            self.isLoading = false
            self.text = text
        }
    }
}

extension ErrorViewModel: Equatable {
    static func == (lhs: ErrorViewModel, rhs: ErrorViewModel) -> Bool {
        return lhs.message == rhs.message &&
            lhs.actionTitle == rhs.actionTitle
    }
}

extension LoadingTextViewModel: Equatable {
    static func == (lhs: LoadingTextViewModel, rhs: LoadingTextViewModel) -> Bool {
        return lhs.state == rhs.state
    }
}

extension LoadingTextViewModel.State: Equatable {
    static func == (lhs: LoadingTextViewModel.State, rhs: LoadingTextViewModel.State) -> Bool {
        switch (lhs, rhs) {
        case (.initialized, .initialized): return true
        case (.loading, .loading): return true
        case let (.loaded(l), .loaded(r)): return l == r
        default: return false
        }
    }
}
