//
//  HeaderValidationBasic.swift
//  LoginApp
//
//  Created by Victor Roldan on 10/01/24.
//

import Foundation

protocol HeaderValidationStrategy {
    func isValid() -> Bool
}

class HeaderValidationBasic: HeaderValidationStrategy{
    func isValid() -> Bool {
        return true
    }
}
