//
//  BuzzquizApp.swift
//  Buzzquiz
//
//  Created by Jonathan Huston on 12/23/20.
//

import SwiftUI

@main
struct BuzzquizApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 500, minHeight: 500, alignment: .center)
                .environmentObject(AllQuizzes())
        }
    }
}
