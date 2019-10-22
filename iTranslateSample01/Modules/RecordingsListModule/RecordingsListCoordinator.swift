//
//  RecordingsListCoordinator.swift
//  iTranslateSample01
//
//  Created by Moataz Afifi on 20/10/2019.
//  Copyright © 2019 iTranslate. All rights reserved.
//
import UIKit


// MARK: - Coordinator
final class RecordingsListCoordinator: Coordinator<Any> {
    
    private let services: AppServices
    private let localizationFileName = "RecordingsList"

    lazy var recordingsListViewController: RecordingsListViewController = {
        let controller = RecordingsListViewController.instantiate(withViewModel: RecordingsListViewModel(services: services))
        controller.delegate = self
        controller.title = "recordings".localized(file: localizationFileName)
        return controller
    }()
    
    init(router: RouterType, services: AppServices) {
        self.services = services
        super.init(router: router)
        router.setRootModule(recordingsListViewController, hideBar: false)
        setupNavBarItems()
    }
    
    override func toPresentable() -> UIViewController {
        return router.navigationController
    }
    
    func setupNavBarItems() {
        let doneButton = UIBarButtonItem(title: "done".localized(file: localizationFileName), style: .plain, target: self, action: #selector(doneButtonTapped))
        router.rootViewController?.navigationItem.rightBarButtonItem = doneButton
    }
    
    
    // MARK: - Actions
    var onDone: (() -> Void)?
    @objc func doneButtonTapped(sender: Any) {
        onDone?()
    }
}


// MARK: - RecordingsListViewControllerDelegate
extension RecordingsListCoordinator: RecordingsListViewControllerDelegate {}
