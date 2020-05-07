//
//  LCTimeStatusViewController.swift
//  LC Time
//
//  Created by Paul Gu on 2020-01-04.
//  Copyright © 2020 Paul Gu. All rights reserved.
//

import Cocoa

class LCTimeStatisticsViewController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
}
    
extension LCTimeStatisticsViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> LCTimeStatisticsViewController {
      let storyboard = NSStoryboard(name: NSStoryboard.Name("Statistics"), bundle: nil)
      let identifier = NSStoryboard.SceneIdentifier("LCTimeStatisticsViewController")
      guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? LCTimeStatisticsViewController else {
        fatalError("Component missing - Check Main.storyboard")
      }
      return viewcontroller
    }
}
