//
//  AmountPickerProvider.swift
//  LoginApp
//
//  Created by Victor Roldan on 10/01/24.
//

import Foundation

enum CustomError: Error {
    case genericError
    case specificError(message: String)
}

protocol AmountPickerProviderProtocol{
    func getAmountPicker(jsonName: String) async -> Result<AmountPickerModel, Error>
}

class AmountPickerProvider: AmountPickerProviderProtocol{
    func getAmountPicker(jsonName: String) async -> Result<AmountPickerModel, Error> {
        if let amountPicker: AmountPickerModel = Helper.decodeJSON(jsonName){
            return .success(amountPicker)
        }
        return .failure(CustomError.genericError)
    }
}
