//
//  UIInterfaceApp.swift
//  UIInterface
//
//  Created by Prathik Kallepalli on 4/22/24.
//

import SwiftUI
import SwiftData

@main
struct StreakifyApp: App
{
    var body: some Scene
    {
        WindowGroup
        {
            LoginView()
            SignUpView()
        }
        .modelContainer(for: Database.self)
        
    }
}
