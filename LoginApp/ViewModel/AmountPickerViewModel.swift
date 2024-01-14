//
//  AmountPickerViewModel.swift
//  LoginApp
//
//  Created by Victor Roldan on 10/01/24.
//

import Foundation
import Combine

class AmountPickerViewModel{
    var headerStrategy: HeaderStrategy?
    var footerStrategy: FooterViewStrategy?
    var amountStrategy: AmountStrategy?
    
    private var provider: AmountPickerProviderProtocol
    
    init(provider: AmountPickerProviderProtocol = AmountPickerProvider()){
        self.provider = provider
    }
    
    @MainActor
    func getAmountPicker() -> AnyPublisher<Void, Never> {
        Future<Void, Never> { promise in
            Task.init {
                let result = await self.provider.getAmountPicker(jsonName: JsonName.FooterDropdown.rawValue)
                
                switch result {
                case .success(let response):
                    self.strategyForHeaderView(header: response.headerSection)
                    self.strategyForFooterView(footer: response.footerSection)
                    self.strategyForAmountView(amountSection: response.amountSection)
                    
                case .failure(let error):
                    print("error: \(error.localizedDescription)")
                }
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func strategyForHeaderView(header: AmountPickerModel.HeaderSection?){
        guard let header else { return }
        
        switch StrategiesName(rawValue: header.strategy ?? "") {
        case .titleCollector:
            headerStrategy = HeaderBasicStrategy(
                headerSection: header,
                validatorStrategy: HeaderValidationBasic())
        
        default:
            print("no strategies")
        }
    }
    
    func strategyForAmountView(amountSection: AmountPickerModel.AmountSection?){
        guard let amountSection else { return }
        
        switch StrategiesName(rawValue: amountSection.strategy ?? "") {
        case .basic:
            amountStrategy = AmountBasicStrategy(amountSection: amountSection,
                                                 validatorStrategy: AmountValidationBasic(amountSection: amountSection))
        default:
            print("no strategies")
        }
    }
    
    
    func strategyForFooterView(footer: AmountPickerModel.FooterSection?){
        guard let footer else { return }
        
        //switch
        switch StrategiesName(rawValue: footer.strategy ?? ""){
            
        case .dropdownButton:
            footerStrategy = FooterDropdowAndButtonStrategy(footerSection: footer,
                                                            validatorStrategy: FooterValidationDropdownAndButton())
            
        case .descriptionButton:
            footerStrategy = FooterDescriptionAndButtonStrategy(footerSection: footer,
                                                                validatorStrategy: FooterValidationDescriptionAndButton())
            /*
        case .footerOnlyButton:
            footerStrategy = FooterOnlyButton(footerSection: footer,
                                                                validatorStrategy: FooterValidationOnlyButton())
             */
            
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
