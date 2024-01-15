//
//  AmountValidationBasic.swift
//  LoginApp
//
//  Created by Victor Roldan on 13/01/24.
//

import Foundation

protocol AmountValidationStrategy {
    var amountSection: AmountPickerModel.AmountSection? {get set}
    var isValidAmount: Bool? {get set}
    
    func isValid(stateManager: StateManager) -> Bool
    func validateAmount(amount: Float) -> (message: String, status: MessageStatus)
    
    init (amountSection: AmountPickerModel.AmountSection?, isValidAmount: Bool?)
}

class AmountValidationBasic: AmountValidationStrategy{
    var amountSection: AmountPickerModel.AmountSection?
    var isValidAmount: Bool?
    
    required init(amountSection: AmountPickerModel.AmountSection?, isValidAmount: Bool? = false) {
        self.amountSection = amountSection
        self.isValidAmount = isValidAmount
    }
    
    func isValid(stateManager: StateManager) -> Bool {
        if amountSection == nil {
            return false
        }
        
        return isValidAmount ?? false
    }
    
    func validateAmount(amount: Float) -> (message: String, status: MessageStatus) {
        let availableAmount = Float(amountSection?.amount?.available ?? 0)
        let min = Float(amountSection?.amount?.min ?? 0.1)
        let max = Float(amountSection?.amount?.max ?? 0)
        let symbol = amountSection?.currencySymbol ?? ""
        
        isValidAmount = false
        if amount < min{
            return ("Debe ser mayor a \(min)", .error)
        
        }else if(amount > max){
            return ("Ingrese un monto menor \(symbol) {\(max)}", .error)
            
        }else if(amount > availableAmount){
            isValidAmount = true
            return ("Se programará proque supera el límite diario", .warning)

        }else{
            isValidAmount = true
            return ("Disponible \(symbol) \(availableAmount)", .success)
        }
    }
}
