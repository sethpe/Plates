//
//  ContentView.swift
//  Plates
//
//  Created by Seth Petel on 2022-01-21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var appSettings: AppSettings
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WorkoutFilterView().tabItem {
                Image(systemName: "flame")
                    .imageScale(.large)
                Text("Workout")
            }.tag(0)
            HomeView().tabItem {
                Image(systemName: "house.fill")
                    .imageScale(.large)
                Text("Home")
            }.tag(1)
        }
//        .onAppear(perform: {
//            kAppDelegate.configureAppearances(color: AppThemeColours.allCases[self.appSettings.themeColorIndex].uiColor())
//        })
        .accentColor(.mint)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppSettings())
    }
}
