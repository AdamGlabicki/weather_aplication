//
//  AppDelegate.swift
//  weather_aplication
//
//  Created by Adam Głąbicki Airnauts on 29/07/2022.
//

import UIKit
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window: UIWindow
    
    override init(){
        self.window = UIWindow()
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSPlacesClient.provideAPIKey("YOUR_API_KEY")
        let navigationController = UINavigationController()
        let viewController = HomeViewController()
        navigationController.setViewControllers([viewController], animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        return true
    }


}

