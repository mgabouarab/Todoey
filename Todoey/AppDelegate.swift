//
//  AppDelegate.swift
//  Todoey
//
//  Created by Mohammed Abouarab on 4/23/19.
//  Copyright © 2019 Mohammed Abouarab. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            _ = try Realm()
        }
        catch {
            print("error With prsisting Realm:\(error)")
        }
        return true
    }
}

