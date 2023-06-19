//
//  FileManagerService.swift
//  FileStorageManager
//
//  Created by Ляпин Михаил on 08.06.2023.
//

import Foundation

protocol FileManagerServiceProtocol: AnyObject {
    var contentsOfDirectory: [Content] { get  }
    func createDirectory(name: String)
    func createFile(name: String, contents: Data)
    func removeContent(at index: Int)
}

final class FileManagerService: FileManagerServiceProtocol {
    
    
    var currentWorkingDirectory: URL
    
    private var _contentsOfDirectory: [Content] = []
    var contentsOfDirectory: [Content] {
        get {
            return _contentsOfDirectory
        }
        set {
            _contentsOfDirectory = newValue
        }
        
        
    }
    
    init() {
        currentWorkingDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        _contentsOfDirectory = getContentsOfDirectory()
        
    }
    
    init(atDirectory directory: URL) {
        currentWorkingDirectory = directory
        _contentsOfDirectory = getContentsOfDirectory()
    }
    
    func createDirectory(name: String) {
        let newDirectoryURL = currentWorkingDirectory.appending(path: name)
        try? FileManager.default.createDirectory(at: newDirectoryURL, withIntermediateDirectories: true)
        _contentsOfDirectory.append(Content(contentType: .folder(newDirectoryURL), name: name))
        
    }
    
    func createFile(name: String, contents: Data) {
        let newFileURL = currentWorkingDirectory.appending(path: name)
        do {
            try contents.write(to: newFileURL)
            _contentsOfDirectory.append(Content(contentType: .file(newFileURL), name: name))
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func removeContent(at index: Int) {
        
        guard let objectsInDirectory = try? FileManager.default.contentsOfDirectory(at: currentWorkingDirectory, includingPropertiesForKeys: nil) else {
            return
        }
        try? FileManager.default.removeItem(at: objectsInDirectory[index])
        
        if let contentIndex = _contentsOfDirectory.firstIndex(where: {$0.name == objectsInDirectory[index].lastPathComponent}) {
            _contentsOfDirectory.remove(at: contentIndex)
        }
    }
    
    
    private func isDirectory(atPath path: String) -> Bool {
        var isDirectory: ObjCBool = true
        FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
    
    
    private func getContentsOfDirectory() -> [Content] {
        
        guard let objectsInDirectory = try? FileManager.default.contentsOfDirectory(at: currentWorkingDirectory, includingPropertiesForKeys: nil) else {
            return []
        }
        
        var contentsOfDirectory: [Content] = []
        
        for i in 0..<objectsInDirectory.count {
            let url = objectsInDirectory[i]
            if isDirectory(atPath: url.path(percentEncoded: false)) {
                contentsOfDirectory.append(Content(contentType: .folder(url), name: url.lastPathComponent))
            } else {
                contentsOfDirectory.append(Content(contentType: .file(url), name: url.lastPathComponent))
            }
        }
        
        return contentsOfDirectory

    }
}
