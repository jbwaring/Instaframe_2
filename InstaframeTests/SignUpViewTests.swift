//
//  SignUpViewTests.swift
//  InstaframeTests
//
//  Created by Jean-Baptiste Waring on 2021-03-17.
//

import Foundation
import XCTest
import ViewInspector
import SwiftUI
@testable import Instaframe
import Firebase

class SignUpViewTests: XCTestCase {

    func testSignUpViewTitles() throws {
        let view = SignUpView()
        let title = try view.inspect().vStack(0).text(0)
        let subtitle = try view.inspect().vStack(0).text(1)
        XCTAssertEqual(try title.string(), "Instaframe")
        XCTAssertEqual(try subtitle.string(), "Fill this form to create a new account.")
    }
    func testSignUpViewFieldUser() throws {
        let view = SignUpView()
        let userField = try view.inspect().vStack(0).find(Field.self)
        let userFieldText = try userField.hStack(0).textField(1)
        let userFieldImage = try userField.hStack(0).image(0)
        XCTAssertEqual(try userFieldText.find(text: "Username").string(), "Username")
        XCTAssertEqual(try userFieldImage.actualImage(), Image(systemName: "person"))

        
    }
    func testSignUpViewFieldEmail() throws {
        let view = SignUpView()
        let userField = try view.inspect().vStack(0).findAll(Instaframe.Field.self)
        let userFieldText = try userField[1].hStack(0).textField(1)
        let userFieldImage = try userField[1].hStack(0).image(0)
        XCTAssertEqual(try userFieldText.find(text: "Email").string(), "Email")
        XCTAssertEqual(try userFieldImage.actualImage(), Image(systemName: "envelope"))

    }
    
    func testSignUpViewFieldPassword() throws {
        let view = SignUpView()
        let userField = try view.inspect().vStack(0).findAll(Instaframe.SecureTextField.self)
        let userFieldText = try userField[0].hStack(0).secureField(1)
        let userFieldImage = try userField[0].hStack(0).image(0)
        XCTAssertEqual(try userFieldText.find(text: "Password").string(), "Password")
        XCTAssertEqual(try userFieldImage.actualImage(), Image(systemName: "key"))

    }
    
    func testSignUpViewFieldConfirmPassword() throws {
        let view = SignUpView()
        let userField = try view.inspect().vStack(0).findAll(Instaframe.SecureTextField.self)
        let userFieldText = try userField[1].hStack(0).secureField(1)
        let userFieldImage = try userField[1].hStack(0).image(0)
        XCTAssertEqual(try userFieldText.find(text: "Confirm Password").string(), "Confirm Password")
        XCTAssertEqual(try userFieldImage.actualImage(), Image(systemName: "key"))

    }
    
    func testSignUpViewFieldPasswordMatchCheck() throws {
        let view = SignUpView()
        XCTAssertEqual(view.passwordMatchCheck(), "")
        let userField = try view.inspect().vStack(0).findAll(Instaframe.SecureTextField.self)
        let userFieldPSWD = try userField[0].hStack(0).secureField(1)
        view.password = "12345"
        XCTAssertEqual(view.passwordMatchCheck(), "")
        
    }
}

extension SignUpView: Inspectable {}
extension Field: Inspectable {}
extension SecureTextField: Inspectable {}
