//
//  LoginViewController.swift
//  FileStorageManager
//
//  Created by Ляпин Михаил on 16.06.2023.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func loginButton(_ sender: Any) {
        viewModel?.updateState(withInput: .didTapLoginButton(password: passwordField.text)){ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.performSegue(withIdentifier: "pushToMainTable", sender: self)
            case .failure(let error):
                presentAlert(message: error.rawValue)
            }
           
        }
    }
    
    var viewModel: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        passwordField.delegate = self
        bindViewModel()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let backBarButton = UIBarButtonItem()
         backBarButton.title = "Выйти"
         navigationItem.backBarButtonItem = backBarButton
 
     }
    
    // MARK: - Private methods
    
    private func bindViewModel() {
        self.viewModel = LoginViewModel()
        viewModel?.onStateDidChange = { [weak self] state in
            switch state {
            case .initial:
                return
            case .passwordNotCreated:
                self?.passwordField.placeholder = "Придумайте надежный пароль"
                self?.loginButton.setTitle("Сохранить пароль", for: .normal)
            case .passwordStored:
                self?.passwordField.placeholder = "Введите пароль"
                self?.loginButton.setTitle("Войти", for: .normal)
            }
        }
        viewModel?.updateState()
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    
}
