//
//  AudioCustomTableViewCell.swift
//  TaskAppsAssasinsIOS
//
//  Created by Stainley A Lebron R on 2023-01-24.
//

import UIKit

class AudioCustomTableViewCell: UITableViewCell {

    
    @IBOutlet weak var audioPlayButton: UIButton!
    
    @IBOutlet weak var scrubber: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // TODO: change icon from stop to play
    @IBAction func playPauseAudioButton(_ sender: UIButton) {
        var changeIcon: Bool = false
        changeIcon.toggle()
    }
    
}
