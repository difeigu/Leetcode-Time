//
//  EventMonitor.swift
//  LC Time
//
//  Created by Paul Gu on 2019-12-30.
//  Copyright © 2019 Paul Gu. All rights reserved.
//

import Cocoa

public class EventMonitor {
  private var monitor: Any?
  private let mask: NSEvent.EventTypeMask
  private let handler: (NSEvent?) -> Void

  public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
    self.mask = mask
    self.handler = handler
  }

  deinit {
    stop()
  }

  public func start() {
    monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
  }

  public func stop() {
    if monitor != nil {
      NSEvent.removeMonitor(monitor!)
      monitor = nil
    }
  }
}
