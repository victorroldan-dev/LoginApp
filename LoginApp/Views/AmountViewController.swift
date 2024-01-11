import UIKit
import Combine

class AmountViewController: UIViewController {
    var viewModel = AmountPickerViewModel()
    
    var topView: UIView?
    
    var centerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var anyCancellable = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptions()
        
        Task{
            await viewModel.getAmountPicker()
        }
    }
    
    func subscriptions(){
        viewModel.reload.sink { _ in
            self.configViews()
        }.store(in: &anyCancellable)
    }
    
    func configViews(){
        topView = viewModel.headerStrategy?.createView(parentVC: self) ?? UIView()
        
        view.addSubview(centerView)
        view.addSubview(bottomView)
        
        configConstratins()
    }
    
    func configConstratins(){
        NSLayoutConstraint.activate([
            
            
            centerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            centerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            centerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            centerView.heightAnchor.constraint(equalToConstant: 100),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 100),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
    }
}

