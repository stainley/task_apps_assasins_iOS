//
//  AudioViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-22.
//

import AVFoundation
import UIKit

extension NoteDetailViewController: AVAudioRecorderDelegate {
    
    
    // Call from ViewDidLoad
    func recordAudio() {
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        print("Failing to record")
                    }
                }
            }
        } catch {
            print("Error recording audio \(error.localizedDescription)")
        }
    }
    
    func loadRecordingUI() {
        //recordAudioButton = UIButton(frame: CGRect(x: 64, y: 64, width: 128, height: 64))
        //recordButton.setTitle("Record", for: .normal)
        //recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        //recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        //view.addSubview(recordButton)
    }
    
    
    

    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func startRecording() {
        let audioFilename = getDocumentDirectory().appendingPathComponent("recording_note.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            //recordButton.setTitle("Tap to stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            //recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            //recordButton.setTitle("Tap to record", for: .normal)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
