//
//  AmountBasicStrategy.swift
//  LoginApp
//
//  Created by Victor Roldan on 13/01/24.
//

import UIKit
import Combine

enum MessageStatus{
    case success
    case error
    case warning
}

protocol AmountStrategy: UIView {
    var amountSection: AmountPickerModel.AmountSection? {get set}
    var validatorStrategy: AmountValidationStrategy? {get set}
    var parentVC: UIViewController? {get set}
    
    func createView(parentVC: UIViewController?, stateManager: StateManager) -> UIView
    func configParentConstraints()
    func configLocalConstraints()
    
    init(amountSection: AmountPickerModel.AmountSection?, validatorStrategy: AmountValidationStrategy?)
}

class AmountBasicStrategy: UIView, AmountStrategy {
    var amountSection: AmountPickerModel.AmountSection?
    var validatorStrategy: AmountValidationStrategy?
    var parentVC: UIViewController?
    
    private var amountTextFieldText: CurrentValueSubject<String, Never>?
    
    lazy private var amountStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addArrangedSubview(amountTextField)
        view.addArrangedSubview(amountButton)
        view.addArrangedSubview(validationLabel)
        view.spacing = 1
        return view
    }()
    
    lazy private var amountTextField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = .orange.withAlphaComponent(0.5)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.addTarget(self, action: #selector(onChangeAmount(text:)), for: .editingChanged)
        textfield.keyboardType = .numberPad
        textfield.isHidden = true
        return textfield
    }()
    
    lazy private var amountButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onAmountButtonPressed(button:)), for: .touchUpInside)
        return button
    }()
    
    lazy private var validationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    required init(amountSection: AmountPickerModel.AmountSection? = nil,
                  validatorStrategy: AmountValidationStrategy? = nil) {
        self.amountSection = amountSection
        self.validatorStrategy = validatorStrategy
        
        super.init(frame: .zero)
        configViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func onChangeAmount(text: UITextField){
        guard let text = text.text else {return}
        showValidationMessge(text: text)
        let newTitle = (amountSection?.currencySymbol ?? "") + " " + text
        amountButton.setTitle(newTitle, for: .normal)
        
        //This amount must be at the end of conditions
        amountTextFieldText?.send(text)
    }
    
    @objc func onAmountButtonPressed(button: UIButton){
        amountTextField.becomeFirstResponder()
    }
    
    func createView(parentVC: UIViewController?, stateManager: StateManager) -> UIView {
        self.amountTextFieldText = stateManager.amountTextFieldText
        
        self.parentVC = parentVC
        configLocalConstraints()
        configParentConstraints()
        return self
    }
    
    private func showValidationMessge(text: String){
        let validation = validatorStrategy?.validateAmount(amount: Float(text) ?? 0.0)
        
        let color: UIColor = (validation?.status == .success ? .gray : validation?.status == .warning ? .orange : .red)
        
        validationLabel.text = validation?.message
        validationLabel.textColor = color
    }
    
    private func configViews(){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        let newTitle = (amountSection?.currencySymbol ?? "") + " " + "0.0"
        amountButton.setTitle(newTitle, for: .normal)
        showValidationMessge(text: "0.0")
        
        amountButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        amountButton.titleLabel?.textAlignment = .center
    }
    
    func configLocalConstraints(){
        addSubview(amountStackView)
        NSLayoutConstraint.activate([
            amountStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            amountStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            amountStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func configParentConstraints() {
        guard let parentVC else { return }
        parentVC.view.addSubview(self)
        
        NSLayoutConstraint.activate([
            centerYAnchor.constraint(equalTo: parentVC.view.centerYAnchor, constant: 0),
            leadingAnchor.constraint(equalTo: parentVC.view.leadingAnchor),
            trailingAnchor.constraint(equalTo: parentVC.view.trailingAnchor),
            heightAnchor.constraint(equalToConstant: 100),
        ])
    }
}
