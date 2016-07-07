//
//  Sound.swift
//  Faustoteca
//
//  Created by Augusto Boranga on 24/06/16.
//  Copyright © 2016 Augusto Boranga. All rights reserved.
//

import UIKit
import AVFoundation

class Sound: NSObject {
    var title = String()
    var player = AVAudioPlayer()
    
    init(title: String, filePath: String) {
        self.title = title
        let soundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(filePath, ofType: "mp3")!)
        
        do {
            try self.player = AVAudioPlayer(contentsOfURL: soundURL)
            player.prepareToPlay()
        } catch {
            print(error)
        }
    }
    
    func play() {
        self.player.play()
    }
}
