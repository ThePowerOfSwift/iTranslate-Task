//
//  FileManagerService.swift
//  iTranslateSample01
//
//  Created by Moataz Afifi on 22/10/2019.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import Foundation
import UIKit

protocol HasFileManagerService {
    var fileManagerService: FileManagerServiceable { get }
}

protocol FileManagerServiceable {
    var appFolderURL: URL? { get }
}

final class FileManagerService: FileManagerServiceable {
    internal var appFolderURL: URL?
    
    init() {
        self.appFolderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}

