//
//  RecordingsListViewController.swift
//  iTranslateSample01
//
//  Created by Moataz Afifi on 21/10/2019.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import UIKit
import AVFoundation


// MARK: - Protocols
protocol RecordingsListViewControllerDelegate: class {}


// MARK: - Controller
class RecordingsListViewController: BaseViewController, ViewModelBased {
    
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    
    // MARK: - Constants and Variables
    internal var viewModel: RecordingsListViewModel!
    private var selectedRow: IndexPath!
    private var recordingsList: [RecordingsListTableViewCellViewModel] = []
    private let localizationFileName = "RecordingsList"
    weak var delegate: RecordingsListViewControllerDelegate?
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellType: RecordingsListTableViewCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRecords()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Reset the player if the user will close the screen
        viewModel.resetPlayer()
    }
    
    
    // MARK: - Records Functions
    private func getRecords() {
        viewModel.getRecords { [unowned self] recordingsList, error in
            if let error = error {
                // If there is error in getting records show an error
                self.showAlert(title: "error".localized(file: localizationFileName), message: error.localizedDescription)
                return
            }
            // Store recordings list and reload tableview using them
            self.recordingsList = recordingsList
            self.tableView.reloadData()
        }
    }
}


// MARK: - Data Source Functions
extension RecordingsListViewController : UITableViewDataSource {
    
    // Section Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // Customize header view and header label
        let headerView = (view as? UITableViewHeaderFooterView)
        headerView?.backgroundView?.backgroundColor = .clear
        let headerLabel = headerView?.textLabel
        headerLabel?.font = Theme.current.font.subText
        headerLabel?.textColor = Theme.current.color.greyTextColor
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "recentlyUsed".localized(file: localizationFileName)
    }
    
    // Cells methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Prepare the cell using the proper view model
        let cellViewModel = recordingsList[indexPath.row]
        if let recordingsListTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellReuseIdentifier()) as? RecordingsListTableViewCell {
            recordingsListTableViewCell.configure(with: cellViewModel)
            return recordingsListTableViewCell
        }else{
            return UITableViewCell()
        }
    }
}


// MARK: - UITableView Selections
extension RecordingsListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Store the selected row index to unselet it after the record ends
        selectedRow = indexPath
        viewModel.playRecord(delegate: self, by: indexPath.row) { [unowned self] error in
            if let error = error {
                // If there is error in playing show an error and deselect the row
                tableView.deselectRow(at: indexPath, animated: true)
                self.showAlert(title: "error".localized(file: localizationFileName), message: error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        // Remove the record
        viewModel.removeRecord(by: indexPath.row) { [unowned self] error in
            if let error = error {
                // If there is error in removing show an error
                self.showAlert(title: "error".localized(file: localizationFileName), message: error.localizedDescription)
                return
            }
            // Reload the records after removing
            self.getRecords()
        }
    }
}


// MARK: - AVAudioPlayerDelegate
extension RecordingsListViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Deslect the selected row after the record ends
        tableView.deselectRow(at: selectedRow, animated: true)
    }
}
