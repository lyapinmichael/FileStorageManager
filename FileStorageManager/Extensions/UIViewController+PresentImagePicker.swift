//
//  UIViewController+PresentImagePicker.swift
//  FileStorageManager
//
//  Created by Ляпин Михаил on 12.06.2023.
//

import Foundation
import UIKit

protocol ImagePickerDelegate: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}

extension UIViewController {
    
    func presentImagePicker(delegate: ImagePickerDelegate) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true 
        imagePicker.delegate = delegate
        present(imagePicker, animated: true)
    }
    
}
