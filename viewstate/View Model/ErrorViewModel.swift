//
//  ErrorViewModel.swift
//  viewstate
//
//  Created by Christopher Trott on 8/12/17.
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

extension ErrorViewModel: Equatable {
    static func == (lhs: ErrorViewModel, rhs: ErrorViewModel) -> Bool {
        return lhs.message == rhs.message &&
            lhs.actionTitle == rhs.actionTitle
    }
}
