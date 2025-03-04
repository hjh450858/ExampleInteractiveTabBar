//
//  TabItem.swift
//  ExampleInteractiveTabBar
//
//  Created by 황재현 on 3/4/25.
//

import Foundation

/// 탭 아이템
enum TabItem: String, CaseIterable {
    case home = "home"
    case search = "search"
    case notification = "notification"
    case setting = "setting"
    
    var symbolImage: String {
        switch self {
        case .home: "house"
        case .search: "magnifyingglass"
        case .notification: "bell"
        case .setting: "gearshape"
        }
    }
    
    // 인덱스
    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}
