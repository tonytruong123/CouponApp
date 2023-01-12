//
//  CouponAppApp.swift
//  CouponApp
//
//  Created by Hoa Truong on 1/10/23.
//

import SwiftUI
import Firebase

@main
struct CouponAppApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
