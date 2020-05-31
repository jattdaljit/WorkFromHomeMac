//
//  AppDelegate.swift
//  Final
//
//  Created by Daljit Singh on 30/05/20.
//  Copyright © 2020 HackFromHome. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain class AppDelegate : NSObject, NSApplicationDelegate {
    var statusBarItem : NSStatusItem!
    var active = false;
    var timeCalculator: [String: Int] = [:]
    
    func applicationDidFinishLaunching (_ aNotification: Notification)
    {
        let statusBar = NSStatusBar.system
        statusBarItem = statusBar.statusItem (
            withLength: NSStatusItem.squareLength)
        statusBarItem.button?.title = "⏰";
        
        let statusBarMenu = NSMenu (title: "Work From Home")
        statusBarItem.menu = statusBarMenu
        
        statusBarMenu.addItem (
            withTitle : "Enable",
            action : #selector (AppDelegate.enableTracker),
            keyEquivalent : ""
        )
        statusBarMenu.addItem (
            withTitle : "Disable",
            action : #selector (AppDelegate.disableTracker),
            keyEquivalent : ""
        )
        statusBarMenu.addItem (
            withTitle : "Exit",
            action : #selector (AppDelegate.exitTracker),
            keyEquivalent : ""
        )
    }
    @objc func enableTracker()
    {
        getActiveWindow()
        
    }
    @objc func disableTracker()
    {
        if(active){
            print("Disabling")
            active = false
            dump(timeCalculator)
        }
    }
    
    @objc func exitTracker ()
    {
        print("Exiting app")
        exit(0);
        
    }
    
    func getActiveWindow ()
    {
        if (!active)
        {
            print ("Enabling")
            active = true;
            DispatchQueue.global (qos: .background).async {
                self.temp2()
                
            }
        }
    }
    
    func temp2 ()
    {
        while (true)
        {
            if (active)
            {
                let apps = NSWorkspace.shared.runningApplications
                for currentApp in apps.enumerated ()
                {
                    let runningApp = apps [currentApp.offset];
                    if (runningApp.activationPolicy == .regular && runningApp.isActive && runningApp.ownsMenuBar)
                    {
                        let keyExists = timeCalculator[runningApp.localizedName!] != nil
                        if(keyExists){
                            let val = timeCalculator[runningApp.localizedName!]!
                            timeCalculator[runningApp.localizedName!] = val + 1;
                        } else {
                            timeCalculator[runningApp.localizedName!] = 1
                        }
                        print(runningApp.localizedName!);
                    }
                }
                usleep (1000000)
            }
            else {
                break;
                
            }
        }
    }
}

