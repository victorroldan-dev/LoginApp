//
//  FooterDropdowAndButtonStrategy.swift
//  LoginApp
//
//  Created by Victor Roldan on 11/01/24.
//

import Foundation
import UIKit
import Combine

class FooterDropdowAndButtonStrategy: UIView, FooterViewStrategy{
    var footerSection: AmountPickerModel.FooterSection?
    var validatorStrategy: FooterValidationStrategy?
    weak var parentVC: UIViewController?
    
    func createView(parentVC: UIViewController?) -> UIView {
        self.parentVC = parentVC
        configConstraints()
        return self
    }
    
    required init(footerSection: AmountPickerModel.FooterSection?, validatorStrategy: FooterValidationStrategy?) {
        self.footerSection = footerSection
        self.validatorStrategy = validatorStrategy
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .green
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configConstraints(){
        guard let parentVC else { return }
        parentVC.view.addSubview(self)
        
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: parentVC.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            leadingAnchor.constraint(equalTo: parentVC.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: parentVC.view.trailingAnchor),
            heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
}
