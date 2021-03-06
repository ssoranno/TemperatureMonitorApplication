//
//  AppDelegate.swift
//  TempMont1
//
//  Created by Ryan Soranno on 6/8/18.
//  Copyright © 2018 Steven Soranno. All rights reserved.
//

import UIKit
import UserNotifications
import SystemConfiguration.CaptiveNetwork

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if(getWiFiSsid() == "ournetwork"){
            UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        }
        return true
    }
    
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void) {
        // Check for new data.
        if let vc = window?.rootViewController as? MainViewController {
            print("wft")
            var temp:Int = 0
            var err = ""
            let url = URL(string:vc.serverURL)
            DispatchQueue.global(qos: .userInitiated).async { [weak vc] in
                do{
                    let contents = try String(contentsOf: url!)
                    temp = (vc?.getTemp(contents: contents))!
                    DispatchQueue.main.async {
                        vc?.temperature = temp
                        vc?.CheckTemp(temp: (vc?.temperature)!)
                        vc?.er = ""
                    }
                    completionHandler(.newData)
                } catch {
                    print("contents could not be loaded")
                    err = "Error: Server could be down"
                    DispatchQueue.main.async {
                        vc?.er = err
                    }
                    completionHandler(.failed)
                }
            }
        }
        print("wft2")
        completionHandler(.noData)
    }
    
    func getWiFiSsid() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("background________________")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("foreground________________")
        UIApplication.shared.applicationIconBadgeNumber = 0
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

