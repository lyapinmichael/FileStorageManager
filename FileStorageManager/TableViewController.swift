//
//  TableViewController.swift
//  FileStorageManager
//
//  Created by Ляпин Михаил on 08.06.2023.
//

import UIKit

final class TableViewController: UITableViewController {
    

    @IBAction func addImageButton(_ sender: UIBarButtonItem) {
        presentImagePicker(delegate: self)
    }
    
    @IBAction func addFolderButton(_ sender: UIBarButtonItem) {
        self.presentTextPicker(title: "Enter folder name") { [weak self] text in
            self?.fileManagerService.createDirectory(name: text)
            self?.tableView.reloadData()
        }
        
    }
    
    var fileManagerService: FileManagerServiceProtocol = FileManagerService()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileManagerService.contentsOfDirectory().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        var configuration = UIListContentConfiguration.cell()
        
        let tableContent = fileManagerService.contentsOfDirectory()
        configuration.text = tableContent[indexPath.row].url.lastPathComponent
        
        switch tableContent[indexPath.row].contentType {
        case .folder:
            cell.accessoryType = .disclosureIndicator
        case .file:
            cell.selectionStyle = .none
        }
        
        cell.contentConfiguration = configuration
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let tableContent = fileManagerService.contentsOfDirectory()
        
        if case .folder(let url) = tableContent[indexPath.row].contentType {
            TableViewController.push(from: self, folderService: FileManagerService(atDirectory: url))
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        fileManagerService.removeContent(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension TableViewController {
    static func push(from controller: TableViewController, folderService: FileManagerService) {
        guard let tableController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TableViewController") as? TableViewController else { return }
        tableController.fileManagerService = folderService
        tableController.title = folderService.currentWorkingDirectory.lastPathComponent
        controller.navigationController?.pushViewController(tableController, animated: true)
        
    }
}

extension TableViewController: ImagePickerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            fileManagerService.createFile(name: imageName, contents: jpegData)
            tableView.reloadData()
        }
        
        dismiss(animated: true)
    }
}
