//
//  HomeCoordinator.swift
//  iTranslateSample01
//
//  Created by Moataz Afifi on 20/10/2019.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import UIKit


// MARK: - Coordinator
final class HomeCoordinator: Coordinator<Any> {
    
    private let services: AppServices
    
    lazy var homeViewController: HomeViewController = {
        let controller = HomeViewController.instantiate(withViewModel: HomeViewModel(services: services))
        controller.delegate = self
        return controller
    }()
    
    lazy var microphonePermissionAlert: MicrophonePermissionAlert = {
        let controller = MicrophonePermissionAlert.instantiate()
        controller.delegate = self
        return controller
    }()
    
    lazy var recordingsListCoordinator: RecordingsListCoordinator = {
        let navigationController = UINavigationController()
        let router = Router(navigationController: navigationController)
        return RecordingsListCoordinator(router: router, services: services)
    }()
    
    init(router: RouterType, services: AppServices) {
        self.services = services
        super.init(router: router)
        router.setRootModule(homeViewController, hideBar: true)
    }
    
    override func toPresentable() -> UIViewController {
        return homeViewController
    }
}


// MARK: - HomeViewControllerDelegate
extension HomeCoordinator: HomeViewControllerDelegate {
    func presentPermissionAlert() {
        microphonePermissionAlert.modalTransitionStyle = .crossDissolve
        self.router.dismissModule(animated: true) {}
        self.router.present(self.microphonePermissionAlert, animated: true)
    }
    
    func presentRecordingsList() {
        recordingsListCoordinator.onDone = { [weak self] in
            self?.router.dismissModule(animated: true) {}
            self?.removeChild(self?.recordingsListCoordinator)
        }
        addChild(recordingsListCoordinator)
        router.present(recordingsListCoordinator, animated: true)
    }
}


// MARK: - MicrophonePermissionAlertDelegate
extension HomeCoordinator: MicrophonePermissionAlertDelegate {
    func allowButtonTapped(isGranted: Bool) {
        homeViewController.isAudioRecordingGranted = isGranted
        router.dismissModule(animated: true, completion: nil)
    }
    
    func cancelButtonTapped() {
        router.dismissModule(animated: true, completion: nil)
    }
}
