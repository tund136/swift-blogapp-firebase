//
//  BlogAppFirebaseApp.swift
//  BlogAppFirebase
//
//  Created by Danh Tu on 06/10/2021.
//

import SwiftUI
import Firebase

@main
struct BlogAppFirebaseApp: App {
    
    // Initializing Firebase
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
