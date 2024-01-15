//
//  FooterDescriptionAndButton.swift
//  LoginApp
//
//  Created by Victor Roldan on 11/01/24.
//

import Foundation
import UIKit
import Combine

protocol FooterViewStrategy: UIView {
    var footerSection: AmountPickerModel.FooterSection? {get set}
    var validatorStrategy: FooterValidationStrategy? {get set}
    var parentVC: UIViewController? {get set}
    
    func createView(parentVC: UIViewController?, stateManager: StateManager) -> UIView
    func configParentConstraints()
    
    init(footerSection: AmountPickerModel.FooterSection?, validatorStrategy: FooterValidationStrategy?)
}

class FooterDescriptionAndButton: UIView, FooterViewStrategy{
    var footerSection: AmountPickerModel.FooterSection?
    var validatorStrategy: FooterValidationStrategy?
    weak var parentVC: UIViewController?
    
    private var descriptionText: CurrentValueSubject<String, Never>?
    private var interationEnabledButton: CurrentValueSubject<Bool, Never>?
    private var continueButtonPressed: CurrentValueSubject<Bool, Never>?
    private var anyCancellable: [AnyCancellable] = []
    
    lazy private var footerView: UIStackView = .view { view in
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addArrangedSubview(descriptionTextField)
        view.addArrangedSubview(continueButton)
        view.spacing = 10
    }
    
    lazy private var descriptionTextField: UITextField = .view { textfield in
        textfield.borderStyle = .roundedRect
        textfield.backgroundColor = .white
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.addTarget(self, action: #selector(onChangeDescription(text:)), for: .editingChanged)
    }
    
    lazy private var continueButton: UIButton = .view { button in
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(color: UIColor.gray), for: .disabled)
        button.addTarget(self, action: #selector(onButtonPressed(button:)), for: .touchUpInside)
    }
    
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
    
    func createView(parentVC: UIViewController?, stateManager: StateManager) -> UIView {
        
        self.descriptionText = stateManager.descriptionText
        self.interationEnabledButton = stateManager.interationEnabledButton
        self.continueButtonPressed = stateManager.continueButtonPressed
        
        self.parentVC = parentVC
        subscriptions()
        configViews()
        addConstraintToFooterView()
        configParentConstraints()
        
        return self
    }
    
    private func subscriptions(){
        interationEnabledButton?.sink{[weak self] enabled in
            guard let self else { return }
            print("default sate: \(enabled)")
            self.continueButton.isUserInteractionEnabled = enabled
            let bgColor: UIColor = (enabled) ? .blue : .gray
            continueButton.backgroundColor = bgColor
        }.store(in: &anyCancellable)
    }
    
    private func configViews(){
        continueButton.setTitle(footerSection?.continueTitle, for: .normal)
        descriptionTextField.placeholder = "Descripción"
    }
    
    @objc func onChangeDescription(text: UITextField){
        guard let text = text.text else {return}
        print("asignando: \(text)")
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
    
    func configParentConstraints(){
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

extension UIImage {
    convenience init(color: UIColor) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(cgImage: image.cgImage!)
    }
}
