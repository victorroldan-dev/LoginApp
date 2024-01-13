import UIKit
import Combine

class StateManager{
    var descriptionText = CurrentValueSubject<String, Never>("")
    var interationEnabledButton = CurrentValueSubject<Bool, Never>(false)
    var continueButtonPressed = CurrentValueSubject<Bool, Never>(false)
    
    var didChangeValue = CurrentValueSubject<Date, Never>(Date())
    var anyCancellable: [AnyCancellable] = []
    
    //Amount Section
    var amountTextFieldText = CurrentValueSubject<String, Never>("")
    
    init(){
        Publishers.CombineLatest(descriptionText, amountTextFieldText)
            .sink {[weak self] description, amount  in
                self?.didChangeValue.send(Date())
            }.store(in: &anyCancellable)
    }
}

class AmountViewController: BaseViewController {
    var viewModel = AmountPickerViewModel()
    var stateManager = StateManager()
    
    var topView: UIView?
    var bottomView: UIView?
    var amountView: UIView?
    
    private var anyCancellable = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptions()
        
        viewModel.getAmountPicker().sink {[weak self] _ in
            guard let self else {return}
            self.configViews()
        }.store(in: &anyCancellable)
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyaboard))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
    }
    
    @objc func dismissKeyaboard(){
        view.endEditing(true)
    }
        
    func subscriptions(){
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
        let isValidAmount = viewModel.amountStrategy?.validatorStrategy?.isValid(stateManager: stateManager) ?? false
        
        stateManager.interationEnabledButton.send((isValidFooter && isValidHeader && isValidAmount))
    }
    
    func configViews(){
        topView = viewModel.headerStrategy?.createView(parentVC: self) ?? UIView()
        
        amountView = viewModel.amountStrategy?.createView(parentVC: self,
                                                          stateManager: stateManager) ?? UIView()
        
        bottomView = viewModel.footerStrategy?.createView(parentVC: self,
                                                          stateManager: stateManager) ?? UIView()
    }
}

