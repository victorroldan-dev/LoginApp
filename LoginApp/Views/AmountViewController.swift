import UIKit
import Combine

class StateManager{
    var descriptionText = CurrentValueSubject<String, Never>("")
    var interationEnabledButton = CurrentValueSubject<Bool, Never>(false)
    var continueButtonPressed = CurrentValueSubject<Bool, Never>(false)
    
    var didChangeValue = CurrentValueSubject<Date, Never>(Date())
    var anyCancellable: [AnyCancellable] = []
    
    init(){
        //Modificar a CombineLatest cuando tenga mas de uno.
        descriptionText.sink {[weak self] text in
            self?.didChangeValue.send(Date())
        }.store(in: &anyCancellable)
        
        /*
        Publishers.CombineLatest3($description, $amount, $continueButtonPressed)
            .sink { description, amount, continueButton in
                self.didChangeValue = .now
                
                print("description: \(description), amount: \(amount), date: \(self.didChangeValue)")
                
                if continueButton {
                    print("redireccionar a deeplink")
                }
                
            }.store(in: &cancellables)
         */
    }
}

class AmountViewController: BaseViewController {
    var viewModel = AmountPickerViewModel()
    var stateManager = StateManager()
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
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyaboard))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    @objc func dismissKeyaboard(){
        view.endEditing(true)
    }
        
    func subscriptions(){
        viewModel.reload.sink {[weak self] _ in
            guard let self else {return}
            self.configViews()
        }.store(in: &anyCancellable)
        
        stateManager.didChangeValue.sink {[weak self] date in
            guard let self else { return }
            self.validationView()
        }.store(in: &anyCancellable)
        
        stateManager.continueButtonPressed.sink {[weak self] pressed in
            guard let self else { return }
            if pressed {
                print("continueButtonPressed: \(pressed)")
            }
        }.store(in: &anyCancellable)

    }
    
    func validationView(){
        let isValidFooter = viewModel.footerStrategy?.validatorStrategy?.isValid(stateManager: stateManager) ?? false
        let isValidHeader = viewModel.headerStrategy?.validatorStrategy?.isValid(stateManager: stateManager) ?? false
        
        stateManager.interationEnabledButton.send((isValidFooter && isValidHeader))
    }
    
    func configViews(){
        topView = viewModel.headerStrategy?.createView(parentVC: self) ?? UIView()
        view.addSubview(centerView)
        bottomView = viewModel.footerStrategy?.createView(parentVC: self, 
                                                          stateManager: stateManager) ?? UIView()
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

