//
//  AmountModel.swift
//  LoginApp
//
//  Created by Victor Roldan on 10/01/24.
//

import Foundation

// MARK: - AmountPickerModel
struct AmountPickerModel: Codable {
    let headerSection: HeaderSection?
    let amountSection: AmountSection?
    let footerSection: FooterSection?
    
    enum CodingKeys: String, CodingKey {
        case headerSection
        case amountSection
        case footerSection
    }
    
    // MARK: - AmountSection
    struct AmountSection: Codable {
        let strategy: String?
        let availableTitle: String?
        let warningTitle: String?
        let errorTitle: String?
        let currencySymbol: String?
        let defaultAmount: Double?
        let amount: Amount?
        
        enum CodingKeys: String, CodingKey {
            case strategy
            case availableTitle
            case warningTitle
            case errorTitle
            case currencySymbol
            case defaultAmount
            case amount
        }
        
        // MARK: - Amount
        struct Amount: Codable {
            let available: Double?
            let min: Double?
            let max: Double?
        }
    }
    
    // MARK: - FooterSection
    struct FooterSection: Codable {
        let strategy: String?
        let dropdownOptions: [String]?
        let continueTitle: String?
        let dropdownPlaceholder: String?
        let descriptionTextfieldTitle: String?
        
        enum CodingKeys: String, CodingKey {
            case strategy
            case dropdownOptions
            case continueTitle
            case dropdownPlaceholder
            case descriptionTextfieldTitle
        }
    }
    
    // MARK: - TitleSection
    struct HeaderSection: Codable {
        let strategy: String?
        let title: Title?
        let collector: Collector?
        
        struct Title: Codable {
            let title: String?
            let size: Float?
        }
    }
    
    // MARK: - Collector
    struct Collector: Codable {
        let name: String?
        let bank: String?
        let alias: String?
        let avatar: String?
        let initials: String?
    }
}
