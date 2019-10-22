//
//  MicrophonePermissionAlert.swift
//  iTranslateSample01
//
//  Created by Moataz Afifi on 20/10/2019.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import UIKit
import AVFoundation

protocol MicrophonePermissionAlertDelegate: class {
    func allowButtonTapped(isGranted: Bool)
    func cancelButtonTapped()
}

class MicrophonePermissionAlert: BaseViewController, Themeable {
    
    
    // MARK: - IBOutlets
    @IBOutlet private weak var alertView: UIView!
    
    
    // MARK: - Constants and Variables
    weak var delegate: MicrophonePermissionAlertDelegate?
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(with: Theme.current)
    }
    
    
    // MARK: - IBActions
    @IBAction func allowAction(_ sender: Any) {
        AVAudioSession.sharedInstance().requestRecordPermission { [unowned self] (allowed) in
            DispatchQueue.main.async { [unowned self] in
                self.delegate?.allowButtonTapped(isGranted: allowed)
            }
        }
    }
    
    @IBAction func maybeLaterAction(_ sender: Any) {
        delegate?.cancelButtonTapped()
    }
}


// MARK: - UI setup
internal extension MicrophonePermissionAlert {
    func setupUI(with theme: Theme) {
        // Alert view shadow
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOffset = CGSize(width: 0.5, height: 4)
        alertView.layer.shadowOpacity = 0.2
        alertView.layer.shadowRadius = 5.0
    }
}
