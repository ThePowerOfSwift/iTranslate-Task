//
//  RecordingsListViewModelTests.swift
//  iTranslateSample01Tests
//
//  Created by Moataz Afifi on 22/10/2019.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import XCTest
import AVFoundation
@testable import iTranslateSample01

class RecordingsListViewModelTests: XCTestCase {
    
    fileprivate var viewModel : RecordingsListViewModel!
    fileprivate var services : AppServices!
    
    override func setUp() {
        self.services = AppServices(fileManagerService: FileManagerService())
        self.viewModel = RecordingsListViewModel(services: services)
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.services = nil
        super.tearDown()
    }
    
    // MARK: - Successful Tests
    func testGetRecordsAndPlayRecord() {
        viewModel.getRecords { records,error in
            if let error = error {
                XCTAssert(false, error.localizedDescription)
            }
            if records.count > 0 {
                // Eexpected to be be able to start the record
                viewModel.playRecord(delegate: self, by: 0) { error in
                    if let error = error {
                        XCTAssert(false, error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func testResetPlayer() {
        // Expected to be able to reset the player before initializing it
        viewModel.resetPlayer()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

extension RecordingsListViewModelTests: AVAudioPlayerDelegate {
    
}

