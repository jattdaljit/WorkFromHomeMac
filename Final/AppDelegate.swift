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
class AppDelegate : NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    var statusBarItem : NSStatusItem!
    var active = false;
    var filePath = "";
    var folderUrl = "";
    var timeCalculator: [String: Int] = [:]
    var notificationCounter: Int = 0;
 
    
    func applicationDidFinishLaunching (_ aNotification: Notification)
    {
        
        NSUserNotificationCenter.default.delegate = self
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
            withTitle : "See History",
            action : #selector (AppDelegate.seeHistory),
            keyEquivalent : ""
        )
        
        statusBarMenu.addItem (
            withTitle : "Exit",
            action : #selector (AppDelegate.exitTracker),
            keyEquivalent : ""
        )
        
        enableTracker();
        
    }
    
    @objc func seeHistory()
    {
        print(folderUrl)
        NSWorkspace.shared.openFile(folderUrl, withApplication: "Finder")
        
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
            writeToFile()
            showNotification()
        }
    }
    
    @objc func exitTracker ()
    {
        print("Exiting app")
        writeToFile()
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
    
    func temp2()
    {
        while (true)
        {
            if (active)
            {
                if(notificationCounter >= 7200) {
                    writeToFile();
                    showNotification();
                    notificationCounter = 0;
                }
                
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
                        notificationCounter = notificationCounter + 1;
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
    
    func writeToFile() {
        print("starting writing")
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        
        let file = "wfh-" + result + ".txt";

        let text = createReadableData();

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            folderUrl = dir.absoluteString;
            let fileURL = dir.appendingPathComponent(file)
            filePath = fileURL.absoluteString;
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {
            print("Unable to write to file")
                
            }
        }
        print("done writing")
    }
    
    func showNotification() -> Void {
        let notification = NSUserNotification()
        
        
        notification.hasActionButton = true
        notification.actionButtonTitle = "Report"
        notification.title = "Work From Home"
        notification.subtitle = "Click on report button to see details"
        notification.soundName = NSUserNotificationDefaultSoundName
        
        NSUserNotificationCenter.default.deliver(notification)
        
        
    }
    
    func createReadableData() -> String {
        var result: String = "Time spent on each app\n";
        for (key, value) in timeCalculator{
            result = result +  key;
            result = result + " : ";
            result = result + String(value/60);
            result = result + " minute(s)";
            result = result + "\n";
        }
        print(result);
        return result
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification)  {
        switch (notification.activationType) {
            case .actionButtonClicked:
                NSWorkspace.shared.openFile(filePath, withApplication: "TextEdit")
            default:
                break;
        }
    }
}

