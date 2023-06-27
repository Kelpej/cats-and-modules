//
//  CatsAndModules_SerhiiHryhorenkoApp.swift
//  CatsAndModules_SerhiiHryhorenko
//
//  Created by Serhii Hryhorenko on 23.05.2023.
//

import SwiftUI
import FirebaseCore
import FirebaseCrashlytics
import CatApiClient

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct CatsAndModulesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State var presentAlert = !UserDefaults.standard.bool(forKey: "shareCrashes")
    
    var body: some Scene {
        WindowGroup {
            CatListView()
                .alert("Do you want to share crash data?", isPresented: $presentAlert) {
                    Button("Yes") {
                        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
                        UserDefaults.standard.set(true, forKey: "shareCrashes")
                    }
                    
                    Button("No") {
                        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
                        UserDefaults.standard.set(false, forKey: "shareCrashes")
                    }
                }
        }
    }
}
