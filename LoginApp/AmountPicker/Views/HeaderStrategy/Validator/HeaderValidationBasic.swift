//
//  HeaderValidationBasic.swift
//  LoginApp
//
//  Created by Victor Roldan on 10/01/24.
//

import Foundation

protocol HeaderValidationStrategy {
    func isValid(stateManager: StateManager) -> Bool
}

class HeaderValidationBasic: HeaderValidationStrategy{
    func isValid(stateManager: StateManager) -> Bool {
        return true
    }
}
