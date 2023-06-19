//
//  ChangePasswordViewController.swift
//  FileStorageManager
//
//  Created by Ляпин Михаил on 19.06.2023.
//

import UIKit
import KeychainSwift

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var newPasswordField: UITextField!
    
    @IBAction func changePasswordButton(_ sender: Any) {
        
        guard let newPassword = newPasswordField.text, !newPassword.isEmpty else {
            presentAlert(message: PasswordError.emptyPasswordNew.rawValue)
            return
        }
            
        guard newPassword.count > 4 else {
            presentAlert(message: PasswordError.passwordTooShort.rawValue)
            return
        }
        
        if keychain.set(newPassword, forKey: "password") {
            presentAlert(message: "Пароль успешно изменен.", handler: { [weak self] in
                self?.dismiss(animated: true)
            })
        }
    }
    
    private let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
