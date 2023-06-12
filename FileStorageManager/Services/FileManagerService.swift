//
//  FileManagerService.swift
//  FileStorageManager
//
//  Created by Ляпин Михаил on 08.06.2023.
//

import Foundation

protocol FileManagerServiceProtocol: AnyObject {
    func contentsOfDirectory() -> [Content]
    func createDirectory(name: String)
    func createFile(name: String, contents: Data)
    func removeContent(at index: Int)
}

final class FileManagerService: FileManagerServiceProtocol {
    
    
    var currentWorkingDirectory: URL
    
    init() {
        currentWorkingDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    init(atDirectory directory: URL) {
        currentWorkingDirectory = directory
    }
    
    func contentsOfDirectory() -> [Content] {
        
        guard let objectsInDirectory = try? FileManager.default.contentsOfDirectory(at: currentWorkingDirectory, includingPropertiesForKeys: nil) else {
            return []
        }
        
        var contentsOfDirectory: [Content] = []
        
        for i in 0..<objectsInDirectory.count {
            let url = objectsInDirectory[i]
            if isDirectory(atPath: url.path()) {
                contentsOfDirectory.append(Content(contentType: .folder(url)))
            } else {
                contentsOfDirectory.append(Content(contentType: .file(url)))
            }
        }
        
        return contentsOfDirectory

    }
    
    func createDirectory(name: String) {
        let newDirectoryURL = currentWorkingDirectory.appending(path: name)
        try? FileManager.default.createDirectory(at: newDirectoryURL, withIntermediateDirectories: true)
        
    }
    
    func createFile(name: String, contents: Data) {
        let newFileURL = currentWorkingDirectory.appending(path: name)
        do {
            try contents.write(to: newFileURL)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func removeContent(at index: Int) {
        
        guard let objectsInDirectory = try? FileManager.default.contentsOfDirectory(at: currentWorkingDirectory, includingPropertiesForKeys: nil) else {
            return
        }
        try? FileManager.default.removeItem(at: objectsInDirectory[index])
    }
    
    
    private func isDirectory(atPath path: String) -> Bool {
        var isDirectory: ObjCBool = true
        FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
}
