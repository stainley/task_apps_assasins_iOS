//
//  AudioViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-22.
//

import AVFoundation
import UIKit

// TODO: Jay
extension NoteDetailViewController {
    
    func loadRecordingUI() {
        //recordTapped()
        prepareForRecording()

    }
    
    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
 
    func stopRecording() {
        if let recorder = audioRecorder {
           if recorder.isRecording {
               audioRecorder?.stop()
               let audioSession = AVAudioSession.sharedInstance()
               do {
                   try audioSession.setActive(false)
               } catch _ {
               }
           }
       }
       
       // Stop the audio player if playing
       if let player = player {
           if player.isPlaying {
               player.stop()
           }
       }
    }
    
    
    func saveRecordingToCoreData (title:String, comments:String) {

    }
    
    //func startRecording() {
    func prepareForRecording() {
        recordAudioButton.image = UIImage(systemName: "mic")
        
        // Set the audio file
       let directoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
        
        print(directoryURL!)
        let audioFileName = UUID().uuidString + ".m4a"
        let audioFileURL = directoryURL!.appendingPathComponent(audioFileName)
        print(audioFileURL)
        //let audioFilename = getDocumentDirectory().appendingPathExtension(audioFilename)
        soundURL = audioFileName
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            try audioRecorder = AVAudioRecorder(url: audioFileURL, settings: settings)
       
        } catch {
            recordAudioButton.image = UIImage(systemName: "mic")
            finishRecording(success: false)
        }
    }    
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func finishRecording(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil
        recordAudioButton.image = UIImage(systemName: "mic")

        if success {
            print("Tap to Re-record, for: .normal")
            //recordButton.setTitle("Tap to Re-record", for: .normal)

        } else {
            //recordButton.setTitle("Tap to record", for: .normal)
            print("Tap to record, for: .normal")
        }
    }

    // TODO: Elvin - When audio is completed save the path to the DB
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            // Show in UI the audio recording has stopped
            finishRecording(success: false)
        }
        
        audioPath.append(soundURL!)
        print("Audio was successfully recorded!")
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        // Show in UI, error happened in audio recording
        //audioReocrding(with error: error)
        if error != nil {
            print("Recording audio error \(error!.localizedDescription)")
        }
    }
     
      
    func finishRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
    }
    


}
