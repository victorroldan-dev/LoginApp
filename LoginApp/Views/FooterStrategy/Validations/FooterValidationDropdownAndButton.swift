//
//  FooterValidationDropdownAndButton.swift
//  LoginApp
//
//  Created by Victor Roldan on 11/01/24.
//

import Foundation
import Combine

protocol FooterValidationStrategy {
    func isValid(stateManager: StateManager) -> Bool
}

class FooterValidationDropdownAndButton: FooterValidationStrategy{
    func isValid(stateManager: StateManager) -> Bool {
        true
    }
}
