//
//  AppDelegate.swift
//  LC Time
//
//  Created by Paul Gu on 2019-12-30.
//  Copyright © 2019 Paul Gu. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    //var window: NSWindow!
    //add status application icon in the menu bar
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.variableLength)
    
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
//        let contentView = ContentView()
//
//        // Create the window and set the content view.
//        window = NSWindow(
//            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
//            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
//            backing: .buffered, defer: false)
//        window.center()
//        window.setFrameAutosaveName("Main Window")
//        window.contentView = NSHostingView(rootView: contentView)
//        window.makeKeyAndOrderFront(nil)
        
        if let button = statusItem.button {
          button.image = NSImage(named:NSImage.Name("leetcodetime_2x"))
            button.action = #selector(statusBarButtonClicked(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        popover.contentViewController = LCTimeViewController.freshController()
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown])
        {[weak self] event in
          if let strongSelf = self, strongSelf.popover.isShown {
            strongSelf.closePopover(sender: event)
          }
        }
    }
    
    @objc func statusBarButtonClicked(_ sender: Any?){
        print("in")
        let event = NSApp.currentEvent!
        print(event.type, NSEvent.EventType.rightMouseUp)
        if event.type == NSEvent.EventType.rightMouseUp {
            print("in1")
            constructMenu()
        } else {
            print("in2")
            togglePopover(nil)
        }
    }
    
    func togglePopover(_ sender: Any?) {
      if popover.isShown {
        closePopover(sender: sender)
      } else {
        showPopover(sender: sender)
      }
    }

    func showPopover(sender: Any?) {
      if let button = statusItem.button {
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        if LCTimeViewController.folding == true{
            LCTimeViewController.resizePopup(changeFrame: LCTimeViewController.changesize, controller: popover.contentViewController!)
        }
      }
        eventMonitor?.start()
    }

    func closePopover(sender: Any?) {
      popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func constructMenu() {
      let menu = NSMenu()

      menu.addItem(NSMenuItem(title: "Reset Statistics", action: #selector(AppDelegate.resetData(_:)), keyEquivalent: "r"))
      menu.addItem(NSMenuItem.separator())
      menu.addItem(NSMenuItem(title: "Quit LC Time", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

      statusItem.menu = menu
    }
    
    @objc func resetData(_ sender: Any?){
        UserDefaults.standard.removeObject(forKey: "Record")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

