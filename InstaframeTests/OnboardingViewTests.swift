//
//  OnboardingViewTests.swift
//  InstaframeTests
//
//  Created by Jean-Baptiste Waring on 2021-03-18.
//

import Foundation
import XCTest
import ViewInspector
import SwiftUI
@testable import Instaframe
import Firebase

class OnboardingViewTests: XCTestCase {

    func testOnBoarding() throws {
        let sampleUser = InstaUser()
        let view = OnBoardingView(currentUser: .constant(sampleUser), newUser: true)
        let welcomeView = try view.inspect().findAll(Instaframe.WelcomeView.self)
        let accountCreate = try view.inspect().findAll(Instaframe.OnBoardAccountCreate.self)
        
        XCTAssertEqual(try  welcomeView.first?.actualView().inspect().zStack(0).vStack(0).text(0).string(), "Instaframe")
        XCTAssertEqual(try  welcomeView.first?.actualView().inspect().zStack(0).text(1).string(), "Welcome!\nLet's get you onboard.")
        XCTAssertEqual(try  welcomeView.first?.actualView().inspect().zStack(0).hStack(2).text(0).string(), "Swipe to Start")
        XCTAssertEqual(try  welcomeView.first?.actualView().inspect().zStack(0).hStack(2).image(1).actualImage(), Image(systemName: "arrow.right.square"))
        
        var accountCreateView = try accountCreate.first!.actualView()
        
        XCTAssertEqual(accountCreateView.username, "")
        XCTAssertEqual(accountCreateView.showAlert, false)
        _ = accountCreateView.on(\.didAppear) { view in
            
            XCTAssertEqual(try view.actualView().checkUserUnique(), true)
            XCTAssertEqual(try view.actualView().userUniqueCheckColor(), Color(.green))
            XCTAssertEqual(try view.actualView().userUniqueCheckString(), "Username should be\n at least 6 characters")
            
            try view.actualView().username = "123456"
            
            XCTAssertEqual(try view.actualView().userUniqueCheckString(), "This username is available.")
            
            
        }

        
        
        
    }
    
}

extension OnBoardingView: Inspectable {}
extension WelcomeView: Inspectable {}
extension OnBoardAccountCreate: Inspectable {}

