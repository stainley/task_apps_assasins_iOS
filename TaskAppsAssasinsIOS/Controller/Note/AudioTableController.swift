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
        return audioPath.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let audioPlayerCell = tableView.dequeueReusableCell(withIdentifier: "audioPlayerCell", for: indexPath) as! AudioCustomTableViewCell
    
        let play = audioPlayerCell.audioPlayButton
        if play!.isSelected {
            play!.setImage(UIImage(systemName: "stop.circle.fill"), for: .normal)
        } else {
            play!.setImage(UIImage(systemName: "play.circle"), for: .normal)
        }
        play!.tag = indexPath.row        
        play!.addTarget(self, action: #selector(playAudio(_ : )), for: .touchDown)
        
        return audioPlayerCell
    }
    
}
