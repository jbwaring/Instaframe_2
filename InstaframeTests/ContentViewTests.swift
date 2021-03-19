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

        let currentUser = Instaframe.InstaUser(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        let sut = ContentView(showSettings: .constant(false), currentUser: .constant(currentUser))
        let exp = XCTestExpectation(description: #function)
        sut.inspection.inspect(after: 0) {view in
            try view.actualView().currentUser = InstaUser(context: try view.actualView().managedObjectContext)
            XCTAssertEqual(try view.actualView().inspect().vStack(0).hStack(0).text(0).string(), "Instaframe")
            try view.vStack(0).hStack(0).button(3).tap()
            
            exp.fulfill()
        }

        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 0.1)
        
        
        
    }
}
extension ContentView: Inspectable { }
extension InspectionContentView: InspectionEmissary where ContentView: Inspectable { }
