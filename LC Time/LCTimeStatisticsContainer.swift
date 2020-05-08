//
//  LCTimeStatisticsContainer.swift
//  LC Time
//
//  Created by Paul Gu on 2020-05-07.
//  Copyright © 2020 Paul Gu. All rights reserved.
//

import Foundation
import Cocoa

class LCTimeStatisticsContainer: NSViewController {
    @IBOutlet var reset: NSButton!
    
    @objc func resetData(_ sender: Any?){
        let defaults = UserDefaults.standard
        defaults.set([], forKey: "Records")
        print("reset!")
        LCTimeTableViewController().tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        reset.action = #selector(resetData(_:))
        reset.sendAction(on: [.leftMouseUp])
    }
}
