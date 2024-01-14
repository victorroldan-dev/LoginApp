//
//  StateManager.swift
//  LoginApp
//
//  Created by Victor Roldan on 14/01/24.
//

import Foundation
import Combine

class StateManager{
    var descriptionText = CurrentValueSubject<String, Never>("")
    var interationEnabledButton = CurrentValueSubject<Bool, Never>(false)
    var continueButtonPressed = CurrentValueSubject<Bool, Never>(false)
    
    var didChangeValue = CurrentValueSubject<Date, Never>(Date())
    var anyCancellable: [AnyCancellable] = []
    
    //Amount Section
    var amountTextFieldText = CurrentValueSubject<String, Never>("")
    
    init(){
        Publishers.CombineLatest(descriptionText, amountTextFieldText)
            .sink {[weak self] description, amount  in
                guard let self else { return }
                self.didChangeValue.send(Date())
            }.store(in: &anyCancellable)
    }
}
