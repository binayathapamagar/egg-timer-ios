//
//  ViewController.swift
//  EggTimer
//
//  Created by Binaya on 10/05/2021.
//

import UIKit
import AVFoundation

class EggTimerViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var eggTitle: UILabel!
    @IBOutlet weak var eggProgess: UIProgressView!
    @IBOutlet weak var progessPercentage: UILabel!
    let eggTypeAndTime: [String: Int] = ["Soft" : 300, "Medium" : 420, "Hard" : 720]
    var player: AVAudioPlayer?
    var eggTimer: Timer = Timer()
    
    // MARK: - App Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBAction method
 
    @IBAction func eggHardnessSelected(_ sender: UIButton) {
        let hardness = sender.currentTitle!
        eggTitle.text = hardness + " Egg"
        updateEggProgess(boilingTime: eggTypeAndTime[hardness]!)
    }
    
    // MARK: - Methods

    func updateEggProgess(boilingTime: Int) {
        eggTimer.invalidate()
        eggProgess.progress = 0.0
        self.progessPercentage.text = ""
        var maxBoilingTime = boilingTime
        
        self.eggTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if maxBoilingTime >= 0 {
                self.eggProgess.progress =
                    (Float(boilingTime) - Float(maxBoilingTime)) / Float(boilingTime)
                self.progessPercentage.text = String(Int(self.eggProgess.progress * 100)) + "%"
                maxBoilingTime -= 1
            } else {
                self.playAlarmSound()
                self.eggTitle.text = "\(self.eggTitle.text!) egg is done!"
                self.eggTimer.invalidate()
            }
        }
    }
    
    func playAlarmSound() {
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

