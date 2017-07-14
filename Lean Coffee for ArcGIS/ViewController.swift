//
//  ViewController.swift
//  Lean Coffee for ArcGIS
//
//  Created by Heather McCracken on 7/13/17.
//  Copyright © 2017 heather.com. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet var startNewTopicLabel: UILabel!
    @IBOutlet var myTimerLabel: UILabel!
    @IBOutlet var pauseButton: UIButton!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var thumbsDownButton: UIButton!
    @IBOutlet var thumbsUpButton: UIButton!
    
    let firstRoundTimer = 300
    let secondRoundTimer = 180
    let finalRoundTimer = 60
    var currentRoundTimer = 300
    var seconds = 300
    
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    var resumeTapped = false
    
    @IBAction func startNewTopicTapped(_ sender: UIButton) {
        currentRoundTimer = firstRoundTimer
        seconds = currentRoundTimer
        timer.invalidate()
        myTimerLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        
        //Check to see if the Pause button was tapped - if so, switch it back
        if self.resumeTapped == true {
            self.resumeTapped = false
            self.pauseButton.setTitle("Pause", for: .normal)
        }
        pauseButton.isEnabled = false
        startButton.isEnabled = true
        resetButton.isEnabled = false
        
    }
    
    @IBAction func startTimerTapped(_ sender: UIButton)  {
        if isTimerRunning == false {
            runTimer()
            self.startButton.isEnabled = false
            self.resetButton.isEnabled = true
        }
    }
    
    @IBAction func pauseTimerTapped(_ sender: UIButton)  {
        if self.resumeTapped == false {
            timer.invalidate()
            self.resumeTapped = true
            self.pauseButton.setTitle("Resume", for: .normal)
        } else {
            runTimer()
            self.resumeTapped = false
            self.pauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    @IBAction func resetTimerTapped(_ sender: UIButton)  {
        timer.invalidate()
        seconds = currentRoundTimer
        myTimerLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        
        //Check to see if the Pause button was tapped - if so, switch it back
        if self.resumeTapped == true {
            self.resumeTapped = false
            self.pauseButton.setTitle("Pause", for: .normal)
        }
        
        pauseButton.isEnabled = false
        startButton.isEnabled = true
        resetButton.isEnabled = false
        
    }
    
    @IBAction func thumbsUpTapped(_ sender: UIButton)  {
        switch currentRoundTimer {
        case firstRoundTimer:
            currentRoundTimer = secondRoundTimer
            seconds = currentRoundTimer
        case secondRoundTimer:
            currentRoundTimer = finalRoundTimer
            seconds = currentRoundTimer
        default:
            currentRoundTimer = finalRoundTimer
            seconds = currentRoundTimer
        }
        timer.invalidate()
        myTimerLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        pauseButton.isEnabled = false
        startButton.isEnabled = true
    }
    
    @IBAction func thumbsDownTapped(_ sender: UIButton)  {
        currentRoundTimer = firstRoundTimer
        seconds = currentRoundTimer
        timer.invalidate()
        myTimerLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        pauseButton.isEnabled = false
        startButton.isEnabled = true
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        pauseButton.isEnabled = true
    }
    
    func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            // Send alert to indicate "time's up!"
            // create a sound ID, in this case its the tweet sound.
            let systemSoundID: SystemSoundID = 1016 //tweet
            //let systemSoundID: SystemSoundID = 1304 //alarm
            
            // to play sound
            AudioServicesPlaySystemSound (systemSoundID)
        } else {
            seconds -= 1     //This will decrement(count down)the seconds.
            // myTimerLabel.text = "\(seconds)" //This will update the label.
            myTimerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    func timeString(time:TimeInterval) -> String {
       // let hours = Int(time)/3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02i:%02i", minutes, seconds)
        //return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGray
        pauseButton.isEnabled = false
    }


}

