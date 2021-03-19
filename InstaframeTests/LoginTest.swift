//
//  LoginTest.swift
//  InstaframeTests
//
//  Created by Jean-Baptiste Waring on 2021-03-17.
//

import XCTest
import ViewInspector
import Combine
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
    
    func testLoginWithNoPassword() throws {
        let sut = LoginView()
        let exp = XCTestExpectation(description: #function)
        let exp2 = XCTestExpectation(description: #function)
        sut.inspection.inspect(after: 0) {view in
            try view.find(button: "Login").tap()
            exp.fulfill()
        }
        
        sut.inspection.inspect(after: 5) {view in
            XCTAssertEqual(try view.actualView().alertMessage, "Something went wrong.")
            XCTAssertEqual(try view.actualView().showAlert, false)
            exp2.fulfill()
        }
                ViewHosting.host(view: sut)
                wait(for: [exp, exp2], timeout: 6)
    }
    
    func testLoginWithExistingUser() throws {
        let sut = LoginView()
        let exp = XCTestExpectation(description: #function)
        let exp2 = XCTestExpectation(description: #function)
        sut.inspection.inspect(after: 0) {view in
            try view.actualView().password = "123456789"
            try view .actualView().email = "unittesting@apple.com"
            try view.find(button: "Login").tap()
            exp.fulfill()
        }
        
        sut.inspection.inspect(after: 3) {view in
            XCTAssertEqual(try view.actualView().isSuccessful, true)
            exp2.fulfill()
        }
                ViewHosting.host(view: sut)
        wait(for: [exp, exp2], timeout: 3.1)
    }
}

extension LoginView: Inspectable {}
extension Inspection: InspectionEmissary where LoginView: Inspectable { }
