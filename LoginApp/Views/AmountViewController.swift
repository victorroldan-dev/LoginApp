import UIKit
import Combine

class StateManager{
    var descriptionText = PassthroughSubject<String, Never>()
    var disableButton = PassthroughSubject<Bool, Never>()
    var continueButtonPressed = PassthroughSubject<Bool, Never>()
}

class AmountViewController: BaseViewController {
    var viewModel = AmountPickerViewModel()
    var stateManager = StateManager()
    var topView: UIView?
    var bottomView: UIView?
    
    /*
    var descriptionText = PassthroughSubject<String, Never>()
    var disableButton = PassthroughSubject<Bool, Never>()
    var continueButtonPressed = PassthroughSubject<Bool, Never>()
    */
    
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
        
        stateManager.descriptionText.sink {[weak self] text in
            guard let self else {return}
            print("description: \(text)")
        }.store(in: &anyCancellable)
        
        stateManager.continueButtonPressed.sink {[weak self] onPressed in
            guard let self else {return}
            print("onPressed: \(onPressed)")
        }.store(in: &anyCancellable)
        
        stateManager.disableButton.sink {[weak self] isDisabled in
            guard let self else {return}
            print("isDisabled: \(isDisabled)")
        }.store(in: &anyCancellable)
    }
    
    func configViews(){
        topView = viewModel.headerStrategy?.createView(parentVC: self) ?? UIView()

        view.addSubview(centerView)
        
        bottomView = viewModel.footerStrategy?.createView(parentVC: self,
                                                          descriptionText: stateManager.descriptionText,
                                                          disableButton: stateManager.disableButton,
                                                          continueButtonPressed: stateManager.continueButtonPressed) ?? UIView()
        
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

