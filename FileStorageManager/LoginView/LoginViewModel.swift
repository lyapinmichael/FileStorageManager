//
//  LoginViewModel.swift
//  FileStorageManager
//
//  Created by Ляпин Михаил on 16.06.2023.
//

import KeychainSwift

enum PasswordError: String, Error {
    case emptyPasswordNew = "Пароль не может быть пустым. Пожалуйста, придумайте надежный пароль."
    case emptyPasswordStored = "Пароль не может быть пустым. Пожалуйста, введите правильный пароль."
    case passwordTooShort = "Пароль слишком короткий. Пароль должен состоять не менее, чем из 5 символов. Пожалуйста, придумайте более сложный пароль."
    case wrongPassword = "Неверный пароль. Попробуйте снова."
    case passwordsNotMatching = "Пароли не совпадают."
}

class LoginViewModel {
    
    enum State {
        case initial
        case passwordStored
        case passwordNotCreated
        case repeatNewPassword
    }
    
    enum UserInput {
        case didTapLoginButton(password: String?)
    }
    
    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }
    
    var onStateDidChange: ((State) -> Void)?
    
    private var intermediatePassword: String?
    private let keychain = KeychainSwift()
    
    init() {
        guard keychain.get("password") != nil else {
            state = .passwordNotCreated
            return
        }
        state = .passwordStored
    }
    
    func updateState() {
        onStateDidChange?(state)
    }
    
    func updateState(withInput input: UserInput, completion: ((Result<Any, PasswordError>)->Void)? = nil) {
        switch input {
            
        case .didTapLoginButton(let password):
            
            guard let safePassword = password, !safePassword.isEmpty else {
                switch state {
                case .passwordNotCreated:
                    completion?(.failure(.emptyPasswordNew))
                case .passwordStored:
                    completion?(.failure(.emptyPasswordStored))
                default:
                    return
                }
                return
            }
            
            if case .passwordNotCreated = state {
                
                guard safePassword.count > 4 else {
                    completion?(.failure(.passwordTooShort))
                    return
                }
                
                intermediatePassword = safePassword
                state = .repeatNewPassword
                return 
            }
            
            if case .passwordStored = state {
                
                guard safePassword == keychain.get("password") else {
                    completion?(.failure(.wrongPassword))
                    return
                }
                
                completion?(.success(true))
            }
            
            if case .repeatNewPassword = state {
                guard let intermediatePassword = self.intermediatePassword else {
                    return
                }
                
                guard intermediatePassword == safePassword else {
                    completion?(.failure(.passwordsNotMatching))
                    return
                }
                
                keychain.set(safePassword, forKey: "password")
                state = .passwordStored
                completion?(.success(false))
            }
    
        }
    }
}
