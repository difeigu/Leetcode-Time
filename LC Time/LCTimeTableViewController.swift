//
//  LCTimeTableViewController.swift
//  LC Time
//
//  Created by Paul Gu on 2020-01-04.
//  Copyright © 2020 Paul Gu. All rights reserved.
//

import Cocoa

class LCTimeTableViewController: NSViewController{
    @IBOutlet weak var tableView: NSTableView!
    var timeItems: [(Int, LCTimeViewController.timeRecord)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        tableView.delegate = self
        tableView.dataSource = self
        
//        NotificationCenter.defaultCenter.addObserver(self, selector: "refreshTable:", name: "refresh", object: nil)
//    }
//
//    func refreshTable(notification: NSNotification) {
//        print("Received Notification")
//        self.tableView.reloadData()
    }
}

extension LCTimeTableViewController: NSTableViewDataSource {
  
  func numberOfRows(in tableView: NSTableView) -> Int {
    let decoder = JSONDecoder()
    var decode: [LCTimeViewController.timeRecord] = []
    let userData = UserDefaults.standard.array(forKey: "Records") as? [Data]
    
    for test in userData! {
        if let rec = try? decoder.decode(LCTimeViewController.timeRecord.self, from: test) {
            decode.append(rec)
        }
    }
    for (index, record) in decode.enumerated(){
        timeItems.append((index+1, record))
    }
    print(timeItems.count)
    return timeItems.count
  }
}
extension LCTimeTableViewController: NSTableViewDelegate {

  fileprivate enum CellIdentifiers {
    static let IndexCell = "IndexCellID"
    static let DifficultyCell = "DifficultyCellID"
    static let DateCell = "DateCellID"
    static let TimeCell = "TimeCellID"
  }

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    var text: String = ""
    var cellIdentifier: String = ""
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .long
    
    let item: (Int, LCTimeViewController.timeRecord) = timeItems[row]

    if tableColumn == tableView.tableColumns[0] {
        text = String(item.0)
      cellIdentifier = CellIdentifiers.IndexCell
    } else if tableColumn == tableView.tableColumns[1] {
        text = String(item.1.difficulty)
      cellIdentifier = CellIdentifiers.DifficultyCell
    } else if tableColumn == tableView.tableColumns[2] {
        text = dateFormatter.string(from: item.1.date)
      cellIdentifier = CellIdentifiers.DateCell
    }else if tableColumn == tableView.tableColumns[3] {
        let hours = Int(item.1.time) / 3600
        let minutes = Int(item.1.time) / 60 % 60
        let seconds = Int(item.1.time) % 60
        text =  String(format: "%d : %02d : %02d", hours, minutes, seconds)
        cellIdentifier = CellIdentifiers.TimeCell
    }

    if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
      cell.textField?.stringValue = text
      return cell
    }
    return nil
  }
}
