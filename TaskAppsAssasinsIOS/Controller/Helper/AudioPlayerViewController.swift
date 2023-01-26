//
//  AudioPlayerViewController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-25.
//

import Foundation
import AVFAudio

extension NoteDetailViewController {
    

    func loadAudio() {
    do {
        
        //try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
        //scrubber.maximumValue = Float(player.duration)
        } catch {
            print(error)
        }
    }
    
}
