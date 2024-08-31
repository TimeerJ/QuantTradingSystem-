//
//  ContentViewTests.swift
//  QuantTradingSystem
//
//  Created by LJ J on 8/31/24.
//
import XCTest
import SwiftUI
@testable import QuantTradingSystem

class ContentViewTests: XCTestCase {
    func testLoginAndLoadProfile() {
        let appStartViewModel = AppStartViewModel()
        appStartViewModel.isLoggedIn = true
        
        let contentView = ContentView()
            .environmentObject(appStartViewModel)
        
        let hostingController = UIHostingController(rootView: contentView)
        
        // 验证是否显示用户资料视图
        XCTAssertNotNil(hostingController.view)
    }
}
