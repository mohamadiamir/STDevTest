//
//  AppDelegate.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setup()
        return true
    }
    
    private func setup(){
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = STDNavigationController()
        appCoordinator = AppCoordinator(navigationController: navigationController, window: window)
        appCoordinator.start()
    }
}
