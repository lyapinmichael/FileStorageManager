//
//  ImagePicker.swift
//  FileStorageManager
//
//  Created by Ляпин Михаил on 16.06.2023.
//

import UIKit

final class ImagePicker: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    static let shared = ImagePicker()
    
    var imagePickerController: UIImagePickerController!
    
    var completion: ((_ imageName: String, _ imageData: Data) -> Void)?
    
    func presentPicker(in viewController: UIViewController, completion: @escaping ((_ imageName: String, _ imageData: Data) -> Void)) {
        
        self.completion = completion
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        viewController.present(imagePickerController, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
           completion?(imageName, jpegData)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
