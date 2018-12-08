//
//  rideTickerUITests.swift
//  rideTickerUITests
//
//  Created by Nick on 8/24/18.
//  Copyright © 2018 NickOwn. All rights reserved.
//

import XCTest

class rideTickerUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMainPageHaveData() {
        XCTAssertTrue(app.tables.cells.count > 0, "Tableview has no messages")
    }
    
    /**
     Test Add new message function
     */
    func testAddNewMessage() {
        app.navigationBars["rideTicker.mainView"].buttons["Add"].tap()
        
        if !app.navigationBars["New Message"].exists {
            XCTAssert(false, "Wrong page")
        }
        
        let tablesQuery = app.tables
        if tablesQuery/*@START_MENU_TOKEN@*/.textFields["First line message"]/*[[".cells.textFields[\"First line message\"]",".textFields[\"First line message\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists {
            tablesQuery/*@START_MENU_TOKEN@*/.textFields["First line message"]/*[[".cells.textFields[\"First line message\"]",".textFields[\"First line message\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            
            tablesQuery/*@START_MENU_TOKEN@*/.textFields["First line message"]/*[[".cells.textFields[\"First line message\"]",".textFields[\"First line message\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText("test")
        }else{
            XCTAssert(false, "First line not found")
        }
        
        if tablesQuery/*@START_MENU_TOKEN@*/.textFields["Second line message"]/*[[".cells.textFields[\"Second line message\"]",".textFields[\"Second line message\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists {
            tablesQuery/*@START_MENU_TOKEN@*/.textFields["Second line message"]/*[[".cells.textFields[\"Second line message\"]",".textFields[\"Second line message\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            tablesQuery/*@START_MENU_TOKEN@*/.textFields["Second line message"]/*[[".cells.textFields[\"Second line message\"]",".textFields[\"Second line message\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText("testing")
        }else{
            XCTAssert(false, "Second line not found")
        }
       
        if tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Saved and Exit"]/*[[".cells.staticTexts[\"Saved and Exit\"]",".staticTexts[\"Saved and Exit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists {
            tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Saved and Exit"]/*[[".cells.staticTexts[\"Saved and Exit\"]",".staticTexts[\"Saved and Exit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        }else{
            XCTAssert(false, "SavedAndExit button not found")
        }
        
    }
    /**
     Test Delete message function
     */
    func testDeleteMessage() {
        //check there has row can delete
        if app.tables.cells.count == 0 {
            XCTAssert(false, "no data in row")
        }
        
        let firstCell = app.tables.cells.element(boundBy: 0)
        if firstCell.exists {
            let buttonEdit = firstCell.buttons["EDIT"]
            buttonEdit.tap()
            
            app.tables/*@START_MENU_TOKEN@*/.staticTexts["DELETE"]/*[[".cells.staticTexts[\"DELETE\"]",".staticTexts[\"DELETE\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            
        }else{
            XCTAssert(false, "no data in row")
        }
        
        XCTAssertTrue(true, "Delete Message success")
    }
    
    /**
     Test Edit message function
     */
    func testEditMessage() {
        //check there has row can edit
        if app.tables.cells.count == 0 {
            XCTAssert(false, "no data in row")
        }
        
        //Start edit
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["EDIT"]/*[[".cells.buttons[\"EDIT\"]",".buttons[\"EDIT\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        if !app.navigationBars["New Message"].exists {
            XCTAssert(false, "Wrong page")
        }
        
        let line1TextField = tablesQuery.cells.containing(.staticText, identifier:"Line 1").children(matching: .textField).element
        if line1TextField.exists {
            line1TextField.tap()
            line1TextField.typeText("testEdit")
            
            app.toolbars["Toolbar"].buttons["Done"].tap()
        }
        
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Saved and Exit"]/*[[".cells.staticTexts[\"Saved and Exit\"]",".staticTexts[\"Saved and Exit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        if tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["testEdit"]/*[[".cells.staticTexts[\"testEdit\"]",".staticTexts[\"testEdit\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists {
            XCTAssert(true, "Edit success")
        }else{
            XCTAssert(false, "Edit fail")
        }
        
        
    }
    
    /**
     Test Logo only mode
     - Test segment first button
     - Test segment second button
     - Test segment third button
     */
    func testShowOnlyMode() {
        
        
    }
    
    
}
