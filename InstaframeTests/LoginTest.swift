//
//  LoginTest.swift
//  InstaframeTests
//
//  Created by Jean-Baptiste Waring on 2021-03-17.
//

import XCTest
import ViewInspector

@testable import Instaframe
import Firebase

class LoginViewTests: XCTestCase {

    func testAlertMessageWhenTapLogin() throws {
        let view = LoginView()
     //   let loadingView = LoginLoadingView(userUUID: "XXXX")
        view.showAlert = false
        
        let button = try view.inspect().find(button: "Login")
        try button.tap()
        
        XCTAssertEqual(view.alertMessage, "Something went wrong.")
    }

}

extension LoginView: Inspectable {}
