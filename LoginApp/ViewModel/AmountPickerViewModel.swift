//
//  AmountPickerViewModel.swift
//  LoginApp
//
//  Created by Victor Roldan on 10/01/24.
//

import Foundation
import Combine

class AmountPickerViewModel{
    var reload = PassthroughSubject<Void, Never>()
    var headerStrategy: HeaderStrategy?
    
    private var provider: AmountPickerProviderProtocol
    
    init(provider: AmountPickerProviderProtocol = AmountPickerProvider()){
        self.provider = provider
    }
    
    @MainActor
    func getAmountPicker() async {
        
        let result = await provider.getAmountPicker(jsonName: JsonName.HeaderVariant1.rawValue)
        
        //defer { loading = false }
        switch result {
        case .success(let response):
            strategyForHeaderView(header: response.headerSection)
            reload.send()
            
        case .failure(let error):
            print("error: \(error.localizedDescription)")
        }
    }
    
    func strategyForHeaderView(header: AmountPickerModel.HeaderSection?){
        guard let header else { return }
        
        switch StrategiesName(rawValue: header.strategy ?? "") {
        case .titleCollector:
            headerStrategy = HeaderBasicStrategy(
                headerSection: header,
                validationStrategy: HeaderValidationBasic())
        default:
            print("no strategies")
        }
    }
}

extension AmountPickerViewModel{
    enum JsonName: String{
        case HeaderVariant1
        case AmountPickerVariant1
        case AmountPickerVariant2
        case FooterDescription
        case FooterDropdown
    }
    
    enum StrategiesName: String{
        //Title
        case onlyTitle = "only-title"
        case titleCollector = "title-collector"
        
        //Amount
        case basic
        case other
        
        //Footer
        case dropdownButton = "dropdown-button"
        case descriptionButton = "description-button"
        case footerOnlyButton = "footer-only-button"
    }
}
