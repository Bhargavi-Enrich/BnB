//
//  AppDelegate.swift
//  EnrichDraw
//
//  Created by Apple on 22/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    var window: UIWindow?
    var avBackgroundMusic: AVAudioPlayer?
//    var gListOfImages : [ModelAzureData] = []
    var gListOfImages : [[String : Any]]? = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        self.appLaunch()
//        setImageData()
        if let data = UserDefaults.standard.array(forKey: gUDKeyImagesVideosData) as? [[String : Any]] {
            self.gListOfImages = data
        }
        downloadImagesVideos()
        return true
    }
    
    func setImageData() {
        
        DownloadManager.shared.startDownload(strFilePath: "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4", title: "1")
        DownloadManager.shared.startDownload(strFilePath: "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4", title: "2")

       let strData =  [["id" : "1","title": "Test Video","url": "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4"],
                       ["id" : "2","title": "Test Video 2","url": "https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_480_1_5MG.mp4"]]

        UserDefaults.standard.set(strData, forKey: gUDKeyImagesVideosData)
        
//        let spinWheelController = EN_VC_Setting.instantiate(fromAppStoryboard: .Main)
//        self.window?.rootViewController!.present(spinWheelController, animated: false, completion: nil)
        
    }
    
//    func startScreenSaver() {
//            let slideShow = EN_VC_SlideShow.instantiate(fromAppStoryboard: .Main)
//            self.window?.rootViewController!.present(slideShow, animated: false)  {
//        }
//    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if let wd = self.window {
            var vc = wd.rootViewController
            if(vc is UINavigationController){
                vc = (vc as! UINavigationController).visibleViewController
                vc?.view.endEditing(true)
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if let lastDate = UserDefaults.standard.value(forKey: UserDefaultKeys.lastLoginDate.rawValue) as? String {
            if GlobalFunctions.shared.needToLogoutFromapp(lastDate: lastDate) {
                APICallsManagerClass.shared.appLogOut()
                self.appLaunch()
                UserDefaults.standard.set(GlobalFunctions.shared.getCurrentDate(), forKey: UserDefaultKeys.lastLoginDate.rawValue)
            }
        } else {
            UserDefaults.standard.set(GlobalFunctions.shared.getCurrentDate(), forKey: UserDefaultKeys.lastLoginDate.rawValue)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    //MARK: - DownloadImagesVideos
    func downloadImagesVideos() {
            EN_Service_AdminLogin.sharedInstance.downloadImageAndVideos() { (errorCode, errorMsg, dictData) in
                if errorCode != 0 {} else {
                    if let status = (dictData?["status"] as? Bool), status == false { //, let message = dictData?["message"] as? String {
                        return
                    }
                    
                    if let dataObj = dictData?["data"] as? [[String : Any]] {
                        UserDefaults.standard.set(dataObj, forKey: gUDKeyImagesVideosData)
                        UserDefaults.standard.synchronize()
                        
                        for model in dataObj {
                            if let strURL = model["url"] as? String, !strURL.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty, let strId = model["id"] as? String {
                            DownloadManager.shared.startDownload(strFilePath: strURL, title: strId)
                        }
                    }
                }
            }
        }
    }

    // MARK: - App Launch
    func appLaunch()
    {
        DispatchQueue.main.async {
                  if UserDefaultUtility.shared.isKeyPresentInUserDefaults(key: UserDefaultKeys.modelAdminUserIdAndPassword.rawValue) == true
                   // if true
                  {
            //            NavigationControllerLandingScreen
                         let spinWheelController = EN_VC_LandingScreen.instantiate(fromAppStoryboard: .Main)
                        let nvc: UINavigationController = UINavigationController(rootViewController: spinWheelController)
                        nvc.isNavigationBarHidden = true
                        self.window?.rootViewController = nvc
                    }
                    else
                    {
                        let spinWheelController = EN_VC_AdminAuthentication.instantiate(fromAppStoryboard: .Main)
                        let nvc: UINavigationController = UINavigationController(rootViewController: spinWheelController)
                        nvc.isNavigationBarHidden = true
                        self.window?.rootViewController = nvc
                    }

        }
    
    }
    
    // MARK: - Play Background Music
    func playBackgroundMusic()
    {
        let path = Bundle.main.path(forResource: "woosh.aac", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            self.avBackgroundMusic = try AVAudioPlayer(contentsOf: url)
            self.avBackgroundMusic?.numberOfLoops = -1
            self.avBackgroundMusic?.play()
            self.avBackgroundMusic?.volume = 1
            
            
        } catch {
            // couldn't load file :(
        }
    }
    func stopBackgroundMusic()
    {
        self.avBackgroundMusic?.stop()
    }
    
    
 
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SplitViewController")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

