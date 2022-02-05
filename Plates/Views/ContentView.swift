//
//  ContentView.swift
//  Plates
//
//  Created by Seth Petel on 2022-01-21.
//

import SwiftUI


struct ContentView: View {
    
    
    var body: some View {

//        TabView {
//            HomeView()
//                .tabItem {
//                    Image(systemName: "house")
//                }
//            PlannerView()
//                .tabItem {
//                    Image(systemName: "brain")
//                }
//
//        }
        
        PlannerView()
        
//        HomeView()
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

