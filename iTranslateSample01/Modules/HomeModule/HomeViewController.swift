//
//  HomeViewController.swift
//  iTranslateSample01
//
//  Created by Moataz Afifi on 20/10/2019.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import UIKit
import AVFoundation


// MARK: - Protocols
protocol HomeViewControllerDelegate: class {
    func presentPermissionAlert()
    func presentRecordingsList()
}


// MARK: - Controller
final class HomeViewController: BaseViewController, ViewModelBased {
    
    
    // MARK: - IBOutlets
    @IBOutlet private weak var recordButton: UIButton!
    
    
    // MARK: - Constants and Variables
    private let localizationFileName = "Home"
    internal var viewModel: HomeViewModel!
    weak var delegate: HomeViewControllerDelegate?
    var isAudioRecordingGranted: Bool! {
        didSet{
            if isAudioRecordingGranted { record() }
        }
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - IBActions
    @IBAction func recordAction(_ sender: UIButton) {
        switch viewModel.checkRecordPermission() {
        case .granted:
            record()
            break
        case .denied:
            showPermissionErrorAlert()
            break
        case .undetermined:
            delegate?.presentPermissionAlert()
            break
        @unknown default:
            break
        }
    }
    
    @IBAction func recordingsListAction(_ sender: UIButton) {
        // Stop record before navigating to records list
        viewModel.resetRecorder()
        recordButton.tintColor = Theme.current.color.primaryColor

        delegate?.presentRecordingsList()
    }
    
    
    // MARK: - Permission Functions
    private func showPermissionErrorAlert() {
        // Ask user to allow the app to use the microphone and navigate the user to settings screen
        let alertController = UIAlertController(title: "error".localized(file: localizationFileName), message: "permissionError".localized(file: localizationFileName), preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "settings".localized(file: localizationFileName), style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
        }
        let cancelAction = UIAlertAction(title: "cancel".localized(file: localizationFileName), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Record Functions
    private func record() {
        viewModel.recordAction(delegate: self) { [unowned self] isRecording, error in
            if let error = error { self.showAlert(title: "error".localized(file: localizationFileName), message: error.localizedDescription) }
            recordButton.tintColor = isRecording ? Theme.current.color.greyTextColor : Theme.current.color.primaryColor
        }
    }
}


// MARK: - AVAudioPlayerDelegate
extension HomeViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag { showAlert(title: "error".localized(file: localizationFileName), message: "recordingError".localized(file: localizationFileName)) }
        recordButton.tintColor = Theme.current.color.primaryColor
    }
}
