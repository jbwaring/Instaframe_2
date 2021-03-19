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
    
    func testLoginWithExistingUser() throws {
        var logsToBePrinted = [String()]
        var viewLogin = LoginView()
        
        _ = viewLogin.on(\.didAppear) { view in
            
            try view.actualView().email = "unittesting@1234.com"
            try view.actualView().password = "1234578" //Wrong Password
            
            let loginButton = try view.actualView().inspect().find(button: "Login")
            try loginButton.tap()
            
            
            Thread.sleep(forTimeInterval: 3)
            logsToBePrinted.append("alertMessage = \(try view.actualView().alertMessage)")
            logsToBePrinted.append("email = \(try view.actualView().email)")
            logsToBePrinted.append("password = \(try view.actualView().password)")
            XCTAssertEqual(try view.actualView().alertMessage, "Something went wrong.")
            
            }
        
        for line in logsToBePrinted {
            print(line)
            print("...")
        }
        
        
    }
}

extension LoginView: Inspectable {}
