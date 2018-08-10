//
//  ViewController.swift
//  Lean Coffee for ArcGIS
//
//  Created by Heather McCracken on 7/13/17.
//  Copyright © 2017 heather.com. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications


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
        
        // Set the Button start state for new topic
        resetButtonStartStates()
        
    }
    
    @IBAction func startTimerTapped(_ sender: UIButton)  {
        if isTimerRunning == false {
            runTimer()
            disableButton(theButton: startButton)
            enableButton(theButton: resetButton)
            


        }
    }
    
    @IBAction func pauseTimerTapped(_ sender: UIButton)  {
        if self.resumeTapped == false {
            timer.invalidate()
            self.resumeTapped = true
            self.pauseButton.setTitle("Resume", for: .normal)
            self.pauseButton.setTitleColor(UIColor.green, for: .normal)
        } else {
            runTimer()
            self.resumeTapped = false
            self.pauseButton.setTitle("Pause", for: .normal)
            self.pauseButton.setTitleColor(UIColor.orange, for: .normal)
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
            self.pauseButton.setTitleColor(UIColor.orange, for: .normal)
        }
        
        // Set the Button start state for new topic
        resetButtonStartStates()

        
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

        
        // Set the Button start state for new topic
        resetButtonStartStates()
        
    }
    
    @IBAction func thumbsDownTapped(_ sender: UIButton)  {
        currentRoundTimer = firstRoundTimer
        seconds = currentRoundTimer
        timer.invalidate()
        myTimerLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false

        // Set the Button start state for new topic
        resetButtonStartStates()
        
    }
    
    func resetButtonStartStates() {

        enableButton(theButton: startButton)
        disableButton(theButton: pauseButton)
        disableButton(theButton: resetButton)
    }
    
    func changeButtonState(theButton: UIButton, setEnabled: Bool, titleColor: UIColor) {
        theButton.isEnabled = setEnabled
        theButton.setTitleColor(titleColor, for: .normal)
        
    }
    
    func enableButton(theButton: UIButton) {
        let titleUIColor: UIColor
        
        switch (theButton){
            
        case startButton:
            titleUIColor = UIColor.green
        case pauseButton:
            titleUIColor = UIColor.orange
        case resetButton:
            titleUIColor = UIColor.white
            
        default:
            titleUIColor = UIColor.lightGray
        }
        
        changeButtonState(theButton: theButton, setEnabled: true, titleColor: titleUIColor)
    }
    
    func disableButton(theButton: UIButton) {
        theButton.isEnabled = false
        theButton.setTitleColor(UIColor.lightGray, for: .normal)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        enableButton(theButton: pauseButton)
        disableButton(theButton: startButton)
        
        // Check to see if User allows local notifications
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
                return;
                
            }
        }
        
        // Define the Notification Content
        let content = UNMutableNotificationContent()
        content.title = "Time's Up"
        content.body = "It's time to Vote!"
        content.sound = UNNotificationSound.default()
        
        
        // Determine trigger time based on current time and fireDate in seconds
        let firedInt = NSInteger(timer.fireDate.timeIntervalSinceNow)
        let test1 = TimeInterval(currentRoundTimer) - timer.fireDate.timeIntervalSinceNow
        
        // Define the trigger for the notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(test1), repeats: false)
        
        
        
        // Schedule the Notification
        let request = UNNotificationRequest(identifier: "TimesUp_Notification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            // Send alert to indicate "time's up!"
            // create a sound ID, in this case its the tweet sound.
           // let systemSoundID: SystemSoundID = 1016 //tweet
            let systemSoundID: SystemSoundID = 1304 //alarm
            disableButton(theButton: pauseButton)
            disableButton(theButton: resetButton)

            
            // to play sound
            AudioServicesPlaySystemSound (systemSoundID)
            
            // Display Alert Dialog
            let alertController = UIAlertController(title: "Time's Up", message:
                "It's time to vote!", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))

            self.present(alertController, animated: true, completion: nil)
            
            
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
        disableButton(theButton: pauseButton)
        
        
    }


}

