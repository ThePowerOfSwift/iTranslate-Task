//
//  HomeViewModelTests.swift
//  HomeViewModelTests
//
//  Created by Andreas Gruber on 04.07.19.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import XCTest
import AVFoundation
@testable import iTranslateSample01

class HomeViewModelTests: XCTestCase {
    
    fileprivate var viewModel : HomeViewModel!
    fileprivate var services : AppServices!

    override func setUp() {
        self.services = AppServices(fileManagerService: FileManagerService())
        self.viewModel = HomeViewModel(services: services)
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.services = nil
        super.tearDown()
    }
    
    // MARK: - Successful Tests
    func testRecordAction() {
        
        //Eexpected to be be able to start recording
        viewModel.recordAction(delegate: self) { isRecording, error in
            if !isRecording {
                XCTAssert(false, "recording didn't start")
            }
        }
    }
    
    func testResetRecorder() {
         // Expected to be able to reset the recorder before initializing it
            viewModel.resetRecorder()
     }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

extension HomeViewModelTests: AVAudioRecorderDelegate {
    
}
