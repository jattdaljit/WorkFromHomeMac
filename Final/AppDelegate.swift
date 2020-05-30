//
//  AppDelegate.swift
//  Final
//
//  Created by Daljit Singh on 30/05/20.
//  Copyright © 2020 HackFromHome. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    var active = true;

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        getActiveWindow()
//        let statusBar = NSStatusBar.system
//        statusBarItem = statusBar.statusItem(
//            withLength: NSStatusItem.squareLength)
//        statusBarItem.button?.title = "⏰"
//
//        let statusBarMenu = NSMenu(title: "Work From Home")
//        statusBarItem.menu = statusBarMenu
//
//        statusBarMenu.addItem(
//            withTitle: "Enable",
//            action: #selector(AppDelegate.orderABurrito),
//            keyEquivalent: "")
//
//        statusBarMenu.addItem(
//            withTitle: "Disable",
//            action: #selector(AppDelegate.cancelBurritoOrder),
//            keyEquivalent: "")
    }


    @objc func orderABurrito() {
        print("Enabling")
        active = true
        getActiveWindow()
    }


    @objc func cancelBurritoOrder() {
        active = false
    }
    
    func getActiveWindow() {
        while(true) {
            if(active) {
                 temp1()
                sleep(4)
            } else {
             break;
          }
        }
    }
    
    func temp2() {
        let app = NSWorkspace.shared.frontmostApplication?.isActive
        print(app)
        
    }
    
    func temp1() {
        let apps = NSWorkspace.shared.runningApplications
        for currentApp in apps.enumerated() { let runningApp = apps[currentApp.offset]; if(runningApp.activationPolicy == .regular && runningApp.isActive && runningApp.ownsMenuBar) {
                  print(runningApp.localizedName);
              
                 }
             }
    
    }
    
    func temp() {
        let apps = NSWorkspace.shared.runningApplications
        for currentApp in apps.enumerated() { let runningApp = apps[currentApp.offset]; if(runningApp.activationPolicy == .regular && runningApp.isActive) {
            print(runningApp.localizedName);
            }
        }

        
        
        let curr_app = NSWorkspace.shared.runningApplications
        print("curr_app name")
        print(curr_app)
        let curr_pid = NSWorkspace.shared.frontmostApplication?.processIdentifier
        
//        print("curr id")
//        print(curr_pid)
       // let curr_app_name = curr_app?.localizedName
        let options = CGWindowListOption.optionOnScreenOnly
        //let windowList = CGWindowListCopyWindowInfo(options, kCGNullWindowID)
        
        
        let windowListInfo = CGWindowListCopyWindowInfo(options, kCGNullWindowID);
        let infoList = windowListInfo as NSArray? as? [[String: AnyObject]]
//        print(infoList)
//        print(type(of: infoList))
        
        
        let infoListUnwrapped: [[String: AnyObject]] = infoList!
    
        
        for info in infoListUnwrapped {
//            print(info.values.contains(where: { (AnyObject) -> Bool in
//                curr_pid == AnyObject
//            }))
            let some = info["kCGWindowOwnerPID"] as! Int32
            if(curr_pid! == some){
                print("final result")
                print(info["kCGWindowOwnerName"])
            }
        }
        
    }
    
}



