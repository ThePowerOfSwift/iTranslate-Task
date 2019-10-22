//
//  Extensions+.swift
//  iTranslateSample01
//
//  Created by Moataz Afifi on 21/10/2019.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import Foundation

extension String {
   func localized(file: String = "") -> String {
        return Bundle.main.localizedString(forKey: self, value: nil, table: file)
    }
}
