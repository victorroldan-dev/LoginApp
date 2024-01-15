//
//  DropdownViewController.swift
//  LoginApp
//
//  Created by Victor Roldan on 14/01/24.
//

import UIKit
import Combine

class DropdownViewController: BaseViewController{
    var options: [String] = []
    var titleView: String = ""
    var callback = PassthroughSubject<String, Never>()
    
    lazy var tableView: UITableView = .view { tableView in
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    lazy private var titleLabel: UILabel = .view { label in
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    init(options: [String], titleView: String) {
        super.init(nibName: nil, bundle: nil)
        self.options = options
        self.titleView = titleView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
    }
    
    func setupTableView() {
        titleLabel.text = titleView
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension DropdownViewController: UITableViewDelegate{
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        callback.send(options[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}

extension DropdownViewController: UITableViewDataSource{
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }
}
