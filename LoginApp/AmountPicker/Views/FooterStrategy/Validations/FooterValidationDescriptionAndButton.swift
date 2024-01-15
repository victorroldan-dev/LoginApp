//
//  FooterValidationDescription.swift
//  LoginApp
//
//  Created by Victor Roldan on 13/01/24.
//

import Foundation

class FooterValidationDescriptionAndButton: FooterValidationStrategy{
    func isValid(stateManager: StateManager) -> Bool {
        if stateManager.descriptionText.value.isEmpty{
            return false
        }
        return true
    }
}
