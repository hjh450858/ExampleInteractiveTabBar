//
//  ContentView.swift
//  ExampleInteractiveTabBar
//
//  Created by 황재현 on 3/4/25.
//

import SwiftUI

/*
 출처 : https://www.youtube.com/watch?v=tL3n-G5gUZ4
 */

struct ContentView: View {
    @State private var activeTab: TabItem = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if #available (iOS 18, *) {
                TabView(selection: $activeTab) {
                    /// Replace with your tab views
                    ForEach(TabItem.allCases, id: \.rawValue) { tab in
                        Tab.init(value: tab) {
                            Text("Tab = \(tab)")
                            Text(tab.rawValue)
                            /// Must hide the navite tab bar
                                .toolbarVisibility(.hidden, for: .tabBar)
                        }
                    }
                }
            } else {
                TabView(selection: $activeTab) {
                    ForEach(TabItem.allCases, id: \.rawValue) { tab in
                        Text(tab.rawValue)
                            .tag(tab)
                            .toolbar(.hidden, for: .tabBar)
                    }
                }
            }
            
            InteractiveTabBar(activeTab: $activeTab)
        }
    }
}

//#Preview {
//    ContentView()
//}
