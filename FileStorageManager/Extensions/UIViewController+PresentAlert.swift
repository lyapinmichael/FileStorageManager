//
//  UIViewController+PresentAlert.swift
//  FileStorageManager
//
//  Created by Ляпин Михаил on 18.06.2023.
//

import Foundation

import UIKit

extension UIViewController {
    
    /// Method used to presend alert which shows some infromation and can take optional no handlers
    func presentAlert(message: String, title: String? = nil, handler:(() -> Void)? = nil, actionTitle: String? = nil) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: actionTitle ?? "Close",
                                          style: .cancel) { action in
            guard handler != nil else { return }
            handler!()
        }
        
        alert.addAction(dismissAction)
        self.present(alert, animated: true)
    
    }
}
