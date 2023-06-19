//
//  SettingTableControllerTableViewController.swift
//  FileStorageManager
//
//  Created by Ляпин Михаил on 18.06.2023.
//

import UIKit

class SettingTableController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    var isSorted: Bool = true

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        
        switch indexPath.row {
        case 0:
            cell.accessoryType = isSorted ? .checkmark : .none
            configuration.text = "Сортирвать файлы"
        case 1:
            cell.accessoryType = .disclosureIndicator
            configuration.text = "Сменить пароль"
        default:
            return cell
        }
        
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
       
        case 0:
            isSorted.toggle()
            switch isSorted {
            case true:
                CurrentFileManagerService.shared.sortingDirection = .ascending
                CurrentFileManagerService.shared.sort()
            case false:
                CurrentFileManagerService.shared.sortingDirection = .descending
                CurrentFileManagerService.shared.sort()
            }
            tableView.cellForRow(at: indexPath)?.accessoryType = isSorted ? .checkmark : .none
            tableView.deselectRow(at: indexPath, animated: true)
            
        case 1:
            performSegue(withIdentifier: "presentChangePasswordView", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
            
        default:
            return
        }
    }
}
