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
    
    @IBOutlet weak var audioIndexLabel: UILabel!
    
    @IBOutlet weak var audioLongLabel: UILabel!
    
    var audioIsPlaying: Bool = false

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
        audioIsPlaying.toggle()
        var iconName: String = "play.circle.fill"
        
        if (audioIsPlaying == true) {
            iconName = "pause.circle.fill"
        }
        else{
            iconName = "play.circle.fill"
        }
        
        if let image = UIImage(systemName:iconName) {
            audioPlayButton.setImage(image, for: .normal)
        }
    }
    
}
