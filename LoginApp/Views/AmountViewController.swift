import UIKit
import Combine

class AmountViewController: UIViewController {
    var viewModel = AmountPickerViewModel()
    var topView: UIView?
    var bottomView: UIView?
    
    var centerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
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
        viewModel.reload.sink {[weak self] _ in
            guard let self else {return}
            self.configViews()
        }.store(in: &anyCancellable)
    }
    
    func configViews(){
        topView = viewModel.headerStrategy?.createView(parentVC: self) ?? UIView()
        //FooterDescriptionAndButtonStrategy
        view.addSubview(centerView)
        //view.addSubview(bottomView)
        bottomView = viewModel.footerStrategy?.createView(parentVC: self) ?? UIView()
        
        configConstratins()
    }
    
    func configConstratins(){
        NSLayoutConstraint.activate([
            centerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            centerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            centerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            centerView.heightAnchor.constraint(equalToConstant: 100),
            
            /*
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 100),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
             */
        ])
    }
}

