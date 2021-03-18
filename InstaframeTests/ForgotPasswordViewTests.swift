//
//  ForgotPasswordViewTests.swift
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

class ForgotPasswordTests: XCTestCase {

    func testForgotViewTitles() throws {
        let view = ForgotPassword()
        let title = try view.inspect().vStack(0).text(0)
        let subtitle = try view.inspect().vStack(0).text(1)
        XCTAssertEqual(try title.string(), "Instaframe")
        XCTAssertEqual(try subtitle.string(), "Enter your email and if we find it in our database, you will receive an email with instructions on how to reset your password.")
    }
    
    func testForgotViewFieldEmail() throws {
        let view = ForgotPassword()
        let userField = try view.inspect().vStack(0).findAll(Instaframe.Field.self)
        let userFieldText = try userField[0].hStack(0).textField(1)
        let userFieldImage = try userField[0].hStack(0).image(0)
        XCTAssertEqual(try userFieldText.find(text: "Email").string(), "Email")
        XCTAssertEqual(try userFieldImage.actualImage(), Image(systemName: "envelope"))

    }
    func testForgotViewButton() throws {
        var viewForgot = ForgotPassword()
        let exp = viewForgot.on(\.didAppear) { view in
            try view.actualView().email = "jean@iblueech.ca"
            XCTAssertEqual(try view.actualView().email, "jean@iblueech.ca")
            try view.vStack(0).hStack(6).button(0).tap()
            Thread.sleep(forTimeInterval: 0.2)
            XCTAssertEqual(try view.actualView().errorString, "")
            XCTAssertEqual(try view.actualView().showError, false)
            }
        
        ViewHosting.host(view: viewForgot)
            wait(for: [exp], timeout: 0.5)
        

    }
}

extension ForgotPassword: Inspectable {}
