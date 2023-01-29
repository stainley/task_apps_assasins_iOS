//
//  AudioViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-22.
//

import AVFoundation
import UIKit

extension NoteDetailViewController {

    func finishRecording(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil
        recordAudioButton.image = UIImage(systemName: "mic")

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
        
        audioPath.append(soundURL!)
        newAudioPath.append(soundURL!)
        audioTableView.reloadData()
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if error != nil {
            let errorAlert = UIAlertController(title: "Recording Audio", message: error!.localizedDescription, preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(errorAlert, animated: true)
        }
    }
      
    func finishRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    func startRecording() {
        
        let directoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in:
                    FileManager.SearchPathDomainMask.userDomainMask).first
                
        let audioFileName = UUID().uuidString + ".m4a"
                let audioFileURL = directoryURL!.appendingPathComponent(audioFileName)
                soundURL = audioFileName

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            recordAudioButton.image = UIImage(systemName: "stop.circle.fill")
        } catch {
            finishRecording(success: false)
        }
    }
    
    func loadRecordingFuntionality() {

        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordAudioButton.isEnabled = true
                    } else {
                        self.recordAudioButton.isEnabled = false
                    }
                }
            }
        } catch {
            print("An error had ocurred configuring the Audio Rec functionality \(error.localizedDescription)")
        }
    }

    // MARK: Play audio button
    @objc func playAudio(_ sender: UIButton) {
        if audioRecorder == nil {
            do {
                var documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                documentPath.append("/\(audioPath[sender.tag])")

                let url = NSURL(fileURLWithPath: documentPath)
                
                try player = AVAudioPlayer(contentsOf: url as URL)
                scrubber[sender.tag].maximumValue = Float(player!.duration)
                                
                player?.volume = 1.0
                player?.play()
                timer.invalidate()

                timer  = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateScrubber(sender: )), userInfo: sender.tag, repeats: true)
            } catch {
                print(error.localizedDescription)
                timer  = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateScrubber(sender: )), userInfo: sender.tag, repeats: true)
            }
        }
    }

    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
}
