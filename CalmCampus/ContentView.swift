//
//  ContentView.swift
//  sample2
//
//  Created by Harshal Dhaduk on 9/18/23.
//

import SwiftUI


struct ProfileView: View {
    var body: some View {
        Text("Profile View")
    }
}

//tabbar
struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            homepage()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            
            relaxpage()
                .tabItem {
                    Image(systemName: "figure.mind.and.body")
                    Text("Relax")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

