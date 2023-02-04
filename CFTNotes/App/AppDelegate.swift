//
//  AppDelegate.swift
//  CFTNotes
//
//  Created by Сергей Бабич on 03.02.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
//        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
//        if !launchedBefore  {
//            UserDefaults.standard.set(true, forKey: "launchedBefore")
//            StorageManager.shared.create("Привет, новый пользователь!\n", "Добро пожаловать в СFTNotes, тут ты можешь записать что-то важное для себя😸")
//        }
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        StorageManager.shared.saveContext()
    }
}
