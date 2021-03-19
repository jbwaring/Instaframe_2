//
//  ContentViewTests.swift
//  InstaframeTests
//
//  Created by Jean-Baptiste Waring on 2021-03-18.
//

import Foundation
import XCTest
import ViewInspector
import SwiftUI
@testable import Instaframe

class ContentViewTests: XCTestCase {
    
    func testHome() throws {
        let currentUser = Instaframe.InstaUser()
        var contentView = ContentView(showSettings: .constant(false), currentUser: .constant(currentUser))
        
        let exp2  = contentView.on(\.didAppear) { view in
            try view.actualView().currentUser = InstaUser(context: try view.actualView().managedObjectContext)
            XCTAssertEqual(try view.actualView().inspect().vStack(0).hStack(0).text(0).string(), "Instaframe")
            XCTAssertEqual(try view.actualView().inspect().vStack(0).hStack(0).image(2).actualImage(), Image(uiImage: UIImage(data: try view.actualView().currentUser.avatar!)!))
            try view.actualView().inspect().vStack(0).hStack(0).button(3).tap()
            XCTAssertTrue(try view.actualView().showSettings)

            
        }
//        ViewHosting.host(view: contentView)
//            wait(for: [exp2], timeout: 2)
       
        
    }
}

extension ContentView: Inspectable {}


