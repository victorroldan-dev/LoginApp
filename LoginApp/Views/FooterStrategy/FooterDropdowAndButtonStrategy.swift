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
    
    private var descriptionText: CurrentValueSubject<String, Never>?
    private var interationEnabledButton: CurrentValueSubject<Bool, Never>?
    private var continueButtonPressed: CurrentValueSubject<Bool, Never>?
    private var anyCancellable: [AnyCancellable] = []
    
    private var dropdownView: UIView = .view { view in
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
    }
    
    lazy private var footerView: UIStackView = .view { view in
        view.axis = .horizontal
        view.addArrangedSubview(dropdownView)
        view.addArrangedSubview(continueButton)
        view.spacing = 10
        view.distribution = .fillProportionally
    }
    
    private var dropdownIcon: UIImageView = .view { image in
        image.image = UIImage(systemName: "chevron.down")
    }
    
    lazy private var continueButton: UIButton = .view { button in
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(UIImage(color: UIColor.gray), for: .disabled)
        button.addTarget(self, action: #selector(onContinueButtonPressed(button:)), for: .touchUpInside)
    }
    
    lazy private var dropdownLabel: UILabel = .view { label in
        label.text = ""
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onDropdownPressed))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gesture)
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
    
    func createView(parentVC: UIViewController?, 
                    stateManager: StateManager) -> UIView {
        
        self.descriptionText = stateManager.descriptionText
        self.interationEnabledButton = stateManager.interationEnabledButton
        self.continueButtonPressed = stateManager.continueButtonPressed
        
        self.parentVC = parentVC
        subscriptions()
        configParentConstraints()
        createDropdown()
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
    
    func createDropdown(){
        addSubview(footerView)
        footerView.addSubview(dropdownView)
        dropdownView.addSubview(dropdownLabel)
        dropdownView.addSubview(dropdownIcon)
        
        dropdownLabel.text = footerSection?.dropdownPlaceholder
        continueButton.setTitle(footerSection?.continueTitle, for: .normal)
        
        
        NSLayoutConstraint.activate([
            //Continue Button
            continueButton.widthAnchor.constraint(equalToConstant: 100),
            
            //Dropdown Icon
            dropdownIcon.trailingAnchor.constraint(equalTo: dropdownLabel.trailingAnchor, constant: -20),
            dropdownIcon.centerYAnchor.constraint(equalTo: dropdownLabel.centerYAnchor),
            dropdownIcon.widthAnchor.constraint(equalToConstant: 20),
            dropdownIcon.heightAnchor.constraint(equalToConstant: 20),
            
            //Dropdown View
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 45),
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            //Dropdown Label
            dropdownLabel.trailingAnchor.constraint(equalTo: dropdownView.trailingAnchor, constant: 10),
            dropdownLabel.leadingAnchor.constraint(equalTo: dropdownView.leadingAnchor, constant: 10),
            dropdownLabel.heightAnchor.constraint(equalTo: dropdownView.heightAnchor),
            dropdownLabel.centerYAnchor.constraint(equalTo: dropdownView.centerYAnchor),
        ])
    }
    
    @objc func onContinueButtonPressed(button: UIButton){
        continueButtonPressed?.send(true)
    }
    
    @objc func onDropdownPressed(){
        print("buttonPressed:")
        //Add deeplink here
        let dropdownVC = DropdownViewController(options: footerSection?.dropdownOptions.map{$0} ?? [],
                                                titleView: footerSection?.dropdownPlaceholder ?? "")
        
        dropdownVC.callback.sink {[weak self] selectedOption in
            guard let self else { return }
            self.descriptionText?.send(selectedOption)
            self.dropdownLabel.text = selectedOption
        }.store(in: &anyCancellable)
        
        if let presentationController = dropdownVC.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        parentVC?.present(dropdownVC, animated: true)
    }
    
    func configParentConstraints(){
        guard let parentVC else { return }
        parentVC.view.addSubview(self)
        
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: parentVC.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            leadingAnchor.constraint(equalTo: parentVC.view.leadingAnchor, constant: 15),
            trailingAnchor.constraint(equalTo: parentVC.view.trailingAnchor, constant: -15),
            heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
}
