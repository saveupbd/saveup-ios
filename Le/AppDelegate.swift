//
//  AppDelegate.swift
//  Le
//
//  Created by 2Base MacBook Pro on 02/03/17.
//  Copyright © 2017 Munesan M. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool{
        
        FirebaseApp.configure()
        //FBSDKApplicationDelegate.sharedInstance().application (application, didFinishLaunchingWithOptions: launchOptions)
        let color1 = UIColor(red: 0.0/255.0, green:170.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor
        let color2 = UIColor(red: 0.0/255.0, green: 170.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor
        let color3 = UIColor(red: 0.0/255.0, green:170.0/255.0, blue: 227.0/255.0, alpha: 1.0).cgColor
        let gradient = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        let defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 64)
        gradient.frame = defaultNavigationBarFrame
        gradient.colors = [color1, color2, color3]
        UINavigationBar.appearance().setBackgroundImage(self.image(fromLayer: gradient), for: .default)
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: titleFont!]
        UINavigationController().navigationBar.tintColor = UIColor.white
        
        
        var rootVC : UIViewController?
        
        if UserDefaults.standard.string(forKey: "AppStatus") == "AppInside"{
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RootTabBarController")
        }else{
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        //TODO: - Enter your credentials
        //PayPalMobile .initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "AaI8As1GGR1r4RS2cVpuxxJdRVYfCePtIFQ1dkuHVNPk7q1eK1isgUCyQQNW2TqIHQCMra2ZIdiXGRoU", PayPalEnvironmentSandbox: "AbP-HxFJayd5yMbUjITsRzIulV7IOZcypwGeDZ9WLeUw9Wihg-PRJlvFVhFyH7mJhXFMyzFEOJppnhtS"])
        UINavigationBar.appearance().tintColor = UIColor.white
        return ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if url.scheme == "fb1653710131594960"{
//            return (FBSDKApplicationDelegate.sharedInstance()?.application(app, open: url, options: options))!
//        }else if url.scheme == "com.googleusercontent.apps.1021147211131-065qt91ch54642s5lhb9qhh0nfqm3akt"{
//            return (GIDSignIn.sharedInstance()?.handle(url))!
//        }
//        return false
//    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool{
        
        if url.scheme == "fb1653710131594960"{
            return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }else if url.scheme == "com.googleusercontent.apps.1021147211131-065qt91ch54642s5lhb9qhh0nfqm3akt"{
            return (GIDSignIn.sharedInstance()?.handle(url))!
        }
        return false
        
    }

    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
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
        AppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

