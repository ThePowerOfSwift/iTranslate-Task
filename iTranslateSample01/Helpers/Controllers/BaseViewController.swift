//
//  BaseViewController.swift
//  iTranslateSample01
//
//  Created by Moataz Afifi on 21/10/2019.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, StoryboardBased {
    
    
    // MARK: - Life Cycle
     override func viewDidLoad() {
         super.viewDidLoad()
     }
    
    
    // MARK: - Custom Functions
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok".localized(file: "Home"), style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


