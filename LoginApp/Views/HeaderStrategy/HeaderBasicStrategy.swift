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
    var validatorStrategy: HeaderValidationStrategy? {get set}
    func createView(parentVC: UIViewController?) -> UIView
    var parentVC: UIViewController? {get set}
    func configConstraints()
    init(headerSection: AmountPickerModel.HeaderSection?,
         validatorStrategy: HeaderValidationStrategy?)
}

class HeaderBasicStrategy: UIView, HeaderStrategy{
    weak var parentVC: UIViewController?
    var validatorStrategy: HeaderValidationStrategy?
    var headerSection: AmountPickerModel.HeaderSection?
    
    private var headerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 30
        return view
    }()
    
    lazy private var collectorInfoView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addArrangedSubview(userNameLabel)
        view.addArrangedSubview(bankNameLabel)
        view.addArrangedSubview(aliasLabel)
        view.spacing = 1
        view.distribution = .fillEqually
        return view
    }()
    
    lazy private var collectorView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addArrangedSubview(circleView)
        view.addArrangedSubview(collectorInfoView)
        view.spacing = 5
        view.distribution = .fill
        return view
    }()
    
    var circleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    private var bankNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    private var aliasLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var initials: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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

extension HeaderBasicStrategy{
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
