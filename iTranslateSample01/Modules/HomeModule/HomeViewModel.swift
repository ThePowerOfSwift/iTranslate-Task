//
//  HomeViewModel.swift
//  iTranslateSample01
//
//  Created by Moataz Afifi on 20/10/2019.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import Foundation
import AVFoundation


// MARK: - Protocols
protocol HomeViewModelable {
    
    
    // MARK: - Functions
    func recordAction(delegate: AVAudioRecorderDelegate, completionHandler: (_ isRecording: Bool, _ error: Error?) -> Void)
    func resetRecorder()
}


// MARK: - ViewModel
final class HomeViewModel: HomeViewModelable, ServicesViewModel {
    
    
    // MARK: - Constants and Variables
    private let appFolderURL: URL?
    private var audioRecorder: AVAudioRecorder!
    private var isRecording = false
    private var isPlaying = false
    
    
    // MARK: - Dependences
    internal typealias Services = HasFileManagerService
    internal var services: Services!
    
    
    // MARK: - Init/Deinit
    init(services: AppServices) {
        self.services = services
        appFolderURL = services.fileManagerService.appFolderURL
    }
    
    
    // MARK: - Permission Functions
    func checkRecordPermission() -> AVAudioSession.RecordPermission {
        return AVAudioSession.sharedInstance().recordPermission
    }
    
    
    // MARK: - Record Functions
    internal func recordAction(delegate: AVAudioRecorderDelegate, completionHandler: (_ isRecording: Bool, _ error: Error?) -> Void) {
        guard let appFolderURL = appFolderURL else { return }
        // If its not recording setup the recorder and record
        if !isRecording {
            setupRecorder(appFolderURL: appFolderURL, delegate: delegate) { error in
                if let error = error {
                    completionHandler(isRecording, error)
                    return
                }
            }
            
            // Start recording
            audioRecorder.record()
            isRecording = true
        }else{
            // If its recording reset the recorder
            resetRecorder()
        }
        // Send the current state of recording
        completionHandler(isRecording, nil)
    }
    
    private func setupRecorder(appFolderURL: URL, delegate: AVAudioRecorderDelegate,  completionHandler: (_ error: Error?) -> Void) {
        let session = AVAudioSession.sharedInstance()
        do {
            // Configure audio session
            try session.setCategory(.record)
            try session.setActive(true)
            
            // Setup audio player
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
            ]
            let url = createURLForNewRecord(appFolderURL: appFolderURL) { error in
                completionHandler(error)
                return
            }
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder.prepareToRecord()
        }
        catch let error {
            completionHandler(error)
        }
    }
    
    internal func resetRecorder() {
        guard isRecording else { return }
        // Stop recorder
        audioRecorder.stop()
        audioRecorder = nil
        isRecording = false
        
        // Reset audio session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    // MARK: - Path Functions
    private func createURLForNewRecord(appFolderURL: URL, completionHandler: (_ error: Error?) -> Void) -> URL {
        // Create file name by this stamp
        let count = getRecordsCount(appFolderURL: appFolderURL) { error in
            completionHandler(error)
        }
        let fileName = "Record " + "\(count + 1)" + ".m4a"
        return appFolderURL.appendingPathComponent(fileName)
    }
    
    private func getRecordsCount(appFolderURL: URL, completionHandler: (_ error: Error?) -> Void) -> Int {
        do {
            try FileManager.default.createDirectory(atPath: appFolderURL.relativePath, withIntermediateDirectories: true)
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: appFolderURL, includingPropertiesForKeys: nil, options: [])
            // Filter the directory contents you based on extension m4a and return the count
            return directoryContents.filter{ $0.pathExtension == "m4a"}.count
        } catch {
            completionHandler(error)
        }
        return 0
    }
}
