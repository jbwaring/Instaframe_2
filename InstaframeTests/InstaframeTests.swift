//
//  InstaframeTests.swift
//  InstaframeTests
//
//  Created by Jean-Baptiste Waring on 2021-03-16.
//


import XCTest
import ViewInspector

@testable import Instaframe
import Firebase

class ContentViewTests: XCTestCase {

    func testExample() throws {
        let subject = TestLogin()
        let text = try subject.inspect().text().string()
        XCTAssertEqual(text, /*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }

}

extension TestLogin: Inspectable {}
