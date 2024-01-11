//
//  HeaderBasicStrategy.swift
//  LoginApp
//
//  Created by Victor Roldan on 10/01/24.
//

import Foundation
import UIKit

protocol HeaderStrategy: UIView {
    var headerSection: AmountPickerModel.HeaderSection? {get set}
    var validationStrategy: HeaderValidationStrategy? {get set}
    func createView(parentVC: UIViewController?) -> UIView
    var parentVC: UIViewController? {get set}
    func configConstraints()
    init(headerSection: AmountPickerModel.HeaderSection?,
         validationStrategy: HeaderValidationStrategy?)
}

class HeaderBasicStrategy: UIView, HeaderStrategy{
    weak var parentVC: UIViewController?
    var validationStrategy: HeaderValidationStrategy?
    var headerSection: AmountPickerModel.HeaderSection?
    
    required init(headerSection: AmountPickerModel.HeaderSection?,
                  validationStrategy: HeaderValidationStrategy?) {
        self.headerSection = headerSection
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .purple
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createView(parentVC: UIViewController?) -> UIView {
        self.parentVC = parentVC
        configConstraints()
        return self
    }
    
    func configConstraints(){
        guard let parentVC else { return }
        parentVC.view.addSubview(self)
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parentVC.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            leadingAnchor.constraint(equalTo: parentVC.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: parentVC.view.trailingAnchor),
            heightAnchor.constraint(equalToConstant: 100),
        ])
    }
     
}
