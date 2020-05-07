//
//  LCTimeViewController.swift
//  LC Time
//
//  Created by Paul Gu on 2019-12-30.
//  Copyright © 2019 Paul Gu. All rights reserved.
//

import Cocoa

class LCTimeViewController: NSViewController {
    @IBOutlet var textLable: NSTextField!
    @IBOutlet var toggleButton: NSButton!
    @IBOutlet var stopButton: NSButton!
    @IBOutlet var difficultyLable: NSTextField!
    @IBOutlet var difficultySelector: NSPopUpButton!
    @IBOutlet var statisticsButton: NSButton!
    
    struct timeRecord: Codable{
        var date: Date
        var difficulty: String
        var time: Int
        init(_ date: Date, _ difficulty: String, _ time: Int) {
            self.date = date
            self.difficulty = difficulty
            self.time = time
        }
    }
    
    var seconds = 0
    var timer = Timer()
    var isTimerRunning = false
    
    static var folding = false
    static var changesize = 100
    static var difficutiesList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        LCTimeViewController.difficutiesList = difficultySelector.itemTitles
        stopButton.isHidden = true
        showTime()
    }
    
    //start the timer when start button is pressed
    func runTimer(){
        //configure timer
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: (#selector(updateTimer)),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func updateTimer(){
        seconds+=1
        showTime()
    }
    
    func showTime(){
        //update the label
        textLable.stringValue = timeString(time: TimeInterval(seconds))
    }
    
    func timeString(time: TimeInterval) ->String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02d : %02d : %02d", hours, minutes, seconds)
    }
    
    static func resizePopup(changeFrame:Int, controller:NSViewController) {
        var contentSize: NSSize
        guard let window = controller.view.window else{
            return
        }
        contentSize = controller.view.frame.size
        contentSize.height = contentSize.height - CGFloat(changeFrame)

        let newWindowSize = window.frameRect(forContentRect: NSRect(origin: NSPoint.zero, size: contentSize)).size

        var frame = window.frame
        frame.origin.y += frame.height
        frame.origin.y -= newWindowSize.height
        frame.size = newWindowSize
        window.animator().setFrame(frame, display: false)
    }
    
}

extension LCTimeViewController {
  // MARK: Storyboard instantiation
  static func freshController() -> LCTimeViewController {
    let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
    let identifier = NSStoryboard.SceneIdentifier("LCTimeViewController")
    guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? LCTimeViewController else {
      fatalError("Component missing - Check Main.storyboard")
    }
    return viewcontroller
  }
    
    // Mark: Actions
    @IBAction func startPauseToggle(_ sender: NSButton){
        if isTimerRunning == false{
            runTimer()
            isTimerRunning = true
            //toggle button image
            sender.image = NSImage(named:"NSStatusPartiallyAvailable")
            //show setting components
            stopButton.isHidden = false
            difficultyLable.isHidden = true
            difficultySelector.isHidden = true
            statisticsButton.isHidden = true
            //change size of window to show settings
            if LCTimeViewController.folding == false{
                LCTimeViewController.resizePopup(changeFrame: LCTimeViewController.changesize, controller: self)
            }
            LCTimeViewController.folding = true
            
        }else{
            timer.invalidate()
            isTimerRunning = false
            //toggle button image
            sender.image = NSImage(named:"NSStatusAvailable")
        }
    }
    @IBAction func stop(_ sender: NSButton){
        timer.invalidate()
        
        //store time result for each stop action pressed
        let selectedItem = difficultySelector.titleOfSelectedItem
        let test = timeRecord(Date.init(), selectedItem!, seconds)
        let encoder = JSONEncoder()
        
        if var present = UserDefaults.standard.array(forKey: "Records"){
            print(present)
            if let encoded = try? encoder.encode(test) {
                present.append(encoded)
            }
            UserDefaults.standard.set(present, forKey: "Records")
        }else{
            if let encoded = try? encoder.encode(test) {
                UserDefaults.standard.set([encoded], forKey: "Records")
            }
            print("data encoded")
        }
        
        //reset time
        seconds = 0
        showTime()
        isTimerRunning = false
        //toggle button image
        toggleButton.image = NSImage(named:"NSStatusAvailable")
        //show setting components
        stopButton.isHidden = true
        difficultyLable.isHidden = false
        difficultySelector.isHidden = false
        statisticsButton.isHidden = false
        //change size of window to hide settings
        if LCTimeViewController.folding == true{
            LCTimeViewController.resizePopup(changeFrame: -1*LCTimeViewController.changesize, controller: self)
        }
        LCTimeViewController.folding = false
    }
    @IBAction func launchWindow(_ sender: NSButton){
        let statisticWindow = LCTimeStatisticsViewController.freshController()
        statisticWindow.showWindow(statisticWindow)
    }
}
