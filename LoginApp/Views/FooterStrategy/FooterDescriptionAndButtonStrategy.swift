//
//  FooterDescriptionAndButtonStrategy.swift
//  LoginApp
//
//  Created by Victor Roldan on 11/01/24.
//

import Foundation
import UIKit
import Combine

protocol FooterValidationStrategy {
    func isValid(/*stateManager: StateManager*/) -> Bool
}

protocol FooterViewStrategy: UIView {
    var footerSection: AmountPickerModel.FooterSection? {get set}
    var validatorStrategy: FooterValidationStrategy? {get set}
    var parentVC: UIViewController? {get set}
    
    func createView(parentVC: UIViewController?, 
                    descriptionText: PassthroughSubject<String, Never>,
                    disableButton: PassthroughSubject<Bool, Never>,
                    continueButtonPressed: PassthroughSubject<Bool, Never>) -> UIView
    func configConstraints()
    
    init(footerSection: AmountPickerModel.FooterSection?, validatorStrategy: FooterValidationStrategy?)
}

class FooterDescriptionAndButtonStrategy: UIView, FooterViewStrategy{
    var footerSection: AmountPickerModel.FooterSection?
    var validatorStrategy: FooterValidationStrategy?
    weak var parentVC: UIViewController?
    
    private var descriptionText: PassthroughSubject<String, Never>?
    private var disableButton: PassthroughSubject<Bool, Never>?
    private var continueButtonPressed: PassthroughSubject<Bool, Never>?
    
    lazy private var footerView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addArrangedSubview(descriptionTextField)
        view.addArrangedSubview(continueButton)
        view.spacing = 10
        return view
    }()
    
    lazy private var descriptionTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(onChangeDescription(text:)), for: .editingChanged)
        return tf
    }()
    
    lazy private var continueButton: UIButton = {
        let tf = UIButton(type: .roundedRect)
        tf.setTitleColor(.white, for: .normal)
        tf.setTitleColor(.gray, for: .focused)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(onButtonPressed(button:)), for: .touchUpInside)
        return tf
    }()
    
    required init(footerSection: AmountPickerModel.FooterSection?,
                  validatorStrategy: FooterValidationStrategy?) {
        self.footerSection = footerSection
        self.validatorStrategy = validatorStrategy
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createView(parentVC: UIViewController?, 
                    descriptionText: PassthroughSubject<String, Never>,
                    disableButton: PassthroughSubject<Bool, Never>,
                    continueButtonPressed: PassthroughSubject<Bool, Never>) -> UIView {
        
        self.descriptionText = descriptionText
        self.disableButton = disableButton
        self.continueButtonPressed = continueButtonPressed
        self.parentVC = parentVC
        
        configViews()
        addConstraintToFooterView()
        configConstraints()
        return self
    }
    
    private func configViews(){
        continueButton.setTitle(footerSection?.continueTitle, for: .normal)
        continueButton.backgroundColor = .blue
        descriptionTextField.placeholder = "Descripción"

    }
    
    @objc func onChangeDescription(text: UITextField){
        guard let text = text.text else {return}
        descriptionText?.send(text)
    }
    
    @objc func onButtonPressed(button: UIButton){
        continueButtonPressed?.send(true)
    }
    
    private func addConstraintToFooterView(){
        NSLayoutConstraint.activate([
            continueButton.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func configConstraints(){
        guard let parentVC else { return }
        addSubview(footerView)
        parentVC.view.addSubview(self)
        
        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: topAnchor),
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
        ])
        
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: parentVC.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            leadingAnchor.constraint(equalTo: parentVC.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: parentVC.view.trailingAnchor),
            heightAnchor.constraint(equalToConstant: 45),
        ])
    }
    
    
}
