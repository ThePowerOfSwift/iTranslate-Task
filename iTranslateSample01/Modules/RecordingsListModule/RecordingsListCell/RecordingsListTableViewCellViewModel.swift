//
//  RecordingsListTableViewCellViewModel.swift
//  iTranslateSample01
//
//  Created by Moataz Afifi on 22/10/2019.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import Foundation


// MARK: - Protocols
protocol RecordingsListTableViewCellViewModelable: CellViewModel {
    
    
    // MARK: - Constants and Variables
    var recordName: String { get }
    var recordDuration: String { get }
    var recordURL: URL { get }
}


// MARK: - ViewModel
class RecordingsListTableViewCellViewModel: RecordingsListTableViewCellViewModelable {
    
    
    // MARK: - Outputs
    internal var recordName: String
    internal var recordDuration: String
    internal var recordURL: URL
    
    
    // MARK: - Init/Deinit
    init(with record: RecordModel) {
        recordName = record.recordName
        recordDuration = record.recordDuration
        recordURL = record.recordURL
    }
    
    
    // MARK: - Custom Functions
    internal func cellReuseIdentifier() -> String {
        return RecordingsListTableViewCell.reuseIdentifier
    }
}
