//
//  AudioTableController.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-25.
//

import Foundation
import UIKit

extension NoteDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(audioPath.count)
        return audioPath.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let audioPlayerCell = tableView.dequeueReusableCell(withIdentifier: "audioPlayerCell", for: indexPath) as! AudioCustomTableViewCell
    
        var play = audioPlayerCell.audioPlayButton
        play?.addTarget(self, action: #selector(playAudio), for: .touchDown)
        
        return audioPlayerCell
    }
    
}
