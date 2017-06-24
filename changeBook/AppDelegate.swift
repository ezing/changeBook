//
//  AppDelegate.swift
//  changeBook
//
//  Created by Jvaeyhcd on 14/06/2017.
//  Copyright © 2017 Jvaeyhcd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setRootViewController()
        setGolbalUIConfig()
        
        return true
    }
    
    // 设置根界面
    private func setRootViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        let rootViewController = RootViewController.init(contentViewController: RootTabBarViewController(), leftMenuViewController: MenuViewController(), rightMenuViewController: nil)
        window?.rootViewController = rootViewController
        
        window?.makeKeyAndVisible()
    }
    
    // 设置全局的UI样式
    private func setGolbalUIConfig() {
        
        UINavigationBar.appearance().tintColor = UIColor(hex: 0x919191)
        UINavigationBar.appearance().barTintColor = kMainColor
        UINavigationBar.appearance().backgroundColor = kMainColor
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),NSForegroundColorAttributeName: kNavTintColor!]
        
        // 设置字体颜色
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(hex: 0x919191)!], for: UIControlState.normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: kMainColor!], for: UIControlState.selected)
        // 设置字体大小
//        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 12.0)], for: UIControlState.normal)
        // 设置字体偏移
//        UITabBarItem.appearance().titlePositionAdjustment = UIOffsetMake(0.0, -5.0)
        // 设置图标选中时颜色
        UITabBar.appearance().tintColor = UIColor.red
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

