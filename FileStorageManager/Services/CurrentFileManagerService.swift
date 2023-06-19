//
//  CurrentFileManagerService.swift
//  FileStorageManager
//
//  Created by Ляпин Михаил on 18.06.2023.
//

import Foundation

class CurrentFileManagerService {
    
    enum SortingDirection {
        case ascending
        case descending
    }
    
    static let shared = CurrentFileManagerService()
    
    var currentService: FileManagerService = FileManagerService()
    var sortingDirection: SortingDirection
    
    private init() {
        sortingDirection = .ascending
    }
    
    func sort() {
        switch sortingDirection {
        case .ascending:
            currentService.contentsOfDirectory.sort(by: {$0.name < $1.name})
        case .descending:
            currentService.contentsOfDirectory.sort(by: {$0.name > $1.name})
        }
        
    }
}
