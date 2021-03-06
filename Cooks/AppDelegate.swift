//
//  AppDelegate.swift
//  Cooks
//
//  Created by Jonathan Long on 9/8/17.
//  Copyright © 2017 jlo. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        let tabBarController = UITabBarController()
		
		let allRecipesViewController = AllRecipesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
		allRecipesViewController.title = "Recipes"
		
		allRecipesViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
		
//		let controllers = [allRecipesViewController]
//		tabBarController.viewControllers = controllers.map {
//			let navController = FloatingButtonNavigationController(rootViewController: $0)
//			navController.isNavigationBarHidden = true
//
//			return navController
//		}
		let navController = FloatingButtonNavigationController(rootViewController: allRecipesViewController)
		navController.isNavigationBarHidden = true
		
//		let textTypeSelectionViewController = TextTypeSelectionViewController()
		
//		let multiSelectionPhotoViewController = MultiPhotoSelectionCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
		
		window?.rootViewController = navController
		
		CKContainer.default() .accountStatus { (status, errorOrNil) in
			if status == CKAccountStatus.noAccount {
				let alert = UIAlertController(title: "Sign in to iCloud", message: "Sign in to your iCloud account to use Sous Chef. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap Create a new Apple ID.", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
				self.window?.rootViewController?.present(alert, animated: true, completion: nil)
			}
		}
        return true
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
		CKContainer.default() .accountStatus { (status, errorOrNil) in
			if status == CKAccountStatus.noAccount {
				let alert = UIAlertController(title: "Sign in to iCloud", message: "Sign in to your iCloud account to use Sous Chef. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap Create a new Apple ID.", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
				self.window?.rootViewController?.present(alert, animated: true, completion: nil)
			}
		}
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

