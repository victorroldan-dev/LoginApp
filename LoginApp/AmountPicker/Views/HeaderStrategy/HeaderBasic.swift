//
//  HeaderBasic.swift
//  LoginApp
//
//  Created by Victor Roldan on 10/01/24.
//

import Foundation
import UIKit

protocol HeaderStrategy: UIView {
    var headerSection: AmountPickerModel.HeaderSection? {get}
    var validatorStrategy: HeaderValidationStrategy? {get}
    var parentVC: UIViewController? {get}
    func createView(parentVC: UIViewController?) -> UIView
    func configConstraints()
    init(headerSection: AmountPickerModel.HeaderSection?,
         validatorStrategy: HeaderValidationStrategy?)
}

class HeaderBasic: UIView, HeaderStrategy{
    weak var parentVC: UIViewController?
    var validatorStrategy: HeaderValidationStrategy?
    var headerSection: AmountPickerModel.HeaderSection?
    
    private var headerStackView: UIStackView = .view { view in
        view.axis = .vertical
        view.spacing = 30
    }
    
    lazy private var collectorInfoView: UIStackView = .view { view in
        view.axis = .vertical
        view.addArrangedSubview(userNameLabel)
        view.addArrangedSubview(bankNameLabel)
        view.addArrangedSubview(aliasLabel)
        view.spacing = 1
        view.distribution = .fillEqually
    }
    
    lazy private var collectorView: UIStackView = .view { view in
        view.axis = .horizontal
        view.addArrangedSubview(circleView)
        view.addArrangedSubview(collectorInfoView)
        view.spacing = 5
        view.distribution = .fill
    }
    
    var circleView: UIView = .view { view in
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
    }
    
    private var titleLabel: UILabel = .view { label in
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 1
    }
    
    private var userNameLabel: UILabel = .view { label in
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .left
    }
    
    private var bankNameLabel: UILabel = .view { label in
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
    }
    
    private var aliasLabel: UILabel = .view { label in
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
    }
    
    private var initials: UILabel = .view { label in
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .black
    }
    
    required init(headerSection: AmountPickerModel.HeaderSection?,
                  validatorStrategy: HeaderValidationStrategy?) {
        self.headerSection = headerSection
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
    
    func createView(parentVC: UIViewController?) -> UIView {
        self.parentVC = parentVC
        setupView()
        configLocalConstraints()
        configConstraints()
        return self
    }
    
    func setupView(){
        userNameLabel.text = headerSection?.collector?.name
        bankNameLabel.text = headerSection?.collector?.bank
        aliasLabel.text = headerSection?.collector?.alias
        initials.text = headerSection?.collector?.initials
        titleLabel.text = headerSection?.title?.title
        
        if hasTitle(){
            headerStackView.addArrangedSubview(titleLabel)
        }
        
        if hasCollector(){
            headerStackView.addArrangedSubview(collectorView)
        }
    }
    
    private func hasCollector() -> Bool {
        return (headerSection?.collector != nil)
    }
    
    private func hasTitle() -> Bool {
        return (headerSection?.title != nil)
    }
}

extension HeaderBasic{
    private func configLocalConstraints(){
        addSubview(headerStackView)
        
        if headerSection?.collector?.initials != nil{
            circleView.addSubview(initials)
            NSLayoutConstraint.activate([
                initials.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
                initials.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            ])
        }
        
        NSLayoutConstraint.activate([
            circleView.widthAnchor.constraint(equalToConstant: 40),
            circleView.heightAnchor.constraint(equalToConstant: 40),
            
            headerStackView.topAnchor.constraint(equalTo: topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
    
    func configConstraints(){
        guard let parentVC else { return }
        parentVC.view.addSubview(self)
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parentVC.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            leadingAnchor.constraint(equalTo: parentVC.view.leadingAnchor, constant: 15),
            trailingAnchor.constraint(equalTo: parentVC.view.trailingAnchor, constant: -15),
            heightAnchor.constraint(equalToConstant: hasCollector() ? 80 : 40),
        ])
    }
}
