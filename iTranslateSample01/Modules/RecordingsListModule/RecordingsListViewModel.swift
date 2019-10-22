//
//  RecordingsListViewModel.swift
//  iTranslateSample01
//
//  Created by Moataz Afifi on 20/10/2019.
//  Copyright © 2019 iTranslate. All rights reserved.
//

import Foundation
import AVFoundation


// MARK: - Protocols
protocol RecordingsListViewModelable {
    
    
    // MARK: - Functions
    func getRecords(completionHandler: (_ result: [RecordingsListTableViewCellViewModel], _ error: Error?) -> Void)
    func playRecord(delegate: AVAudioPlayerDelegate, by index: Int, completionHandler: (_ error: Error?) -> Void)
    func removeRecord(by index: Int, completionHandler: (_ error: Error?) -> Void)
    func resetPlayer()
}


// MARK: - ViewModel
final class RecordingsListViewModel: RecordingsListViewModelable {
    
    
    // MARK: - Constants and Variables
    private let appFolderURL: URL?
    private var records: [RecordModel]!
    private var player: AVAudioPlayer?
    
    
    // MARK: - Dependences
    internal typealias Services = HasFileManagerService
    internal var services: Services!
    
    
    // MARK: - Init/Deinit
    init(services: AppServices) {
        self.services = services
        appFolderURL = services.fileManagerService.appFolderURL
    }
    
    
    // MARK: - Records Functions
    func getRecords(completionHandler: (_ result: [RecordingsListTableViewCellViewModel], _ error: Error?) -> Void) {
        guard let appFolderURL = appFolderURL else { return }
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: appFolderURL, includingPropertiesForKeys: nil, options: [])
            // Filter the directory contents you based on extension m4a
            records = directoryContents
                .filter{ $0.pathExtension == "m4a"}
                .map { RecordModel(recordName: $0.deletingPathExtension().lastPathComponent, recordDuration: getAudioDuration($0), recordURL: $0) }
            // Send array of cells view models
            completionHandler(records.map{ RecordingsListTableViewCellViewModel(with: $0) }, nil)
        } catch {
            // Send the error
            completionHandler([], error)
        }
    }
    
    private func getAudioDuration(_ fileURL: URL) -> String {
        let audioAsset = AVURLAsset.init(url: fileURL, options: nil)
        let totalSeconds = audioAsset.duration.seconds
        let min = Int(totalSeconds / 60)
        let sec = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        let totalTimeString = String(format: "%02d:%02d", min, sec)
        return totalTimeString
    }
    
    internal func playRecord(delegate: AVAudioPlayerDelegate, by index: Int, completionHandler: (_ error: Error?) -> Void) {
        let session = AVAudioSession.sharedInstance()
        do {
            // Configure audio session
            try session.setCategory(.playback)
            try session.setActive(true)
            
            // Setup audio player
            player = try AVAudioPlayer(contentsOf: records[index].recordURL)
            guard let player = player else { return }
            player.delegate = delegate
            player.prepareToPlay()

            // Play record
            player.play()
            completionHandler(nil)
        } catch let error as NSError {
            // Send the error
            completionHandler(error)
        }
    }
    
    internal func resetPlayer() {
        // Stop player
        player?.stop()
        player = nil
        
        // Reset audio session
        let session = AVAudioSession.sharedInstance()
         do {
             try session.setActive(false)
         } catch {
             print(error.localizedDescription)
         }
    }
    
    internal func removeRecord(by index: Int, completionHandler: (_ error: Error?) -> Void) {
        let recordPath = records[index].recordURL.path
        do {
            // Remove the selected file by its path
            try FileManager.default.removeItem(atPath: recordPath)
            completionHandler(nil)
        } catch let error as NSError {
            // Send the error
            completionHandler(error)
        }
    }
}
