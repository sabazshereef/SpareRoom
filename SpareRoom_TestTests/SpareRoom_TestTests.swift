//
//  SpareRoom_TestTests.swift
//  SpareRoom_TestTests
//
//  Created by sabaz shereef on 31/03/21.
//

import XCTest
@testable import SpareRoom_Test

var TableViewController : ViewController!

let mockDataLoader = MockDataLoader()

class SpareRoom_TestTests: XCTestCase {

    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        TableViewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        _ = TableViewController.view
    
    }
    func testHasATableView() {
        XCTAssertNotNil(TableViewController.upComingEventTable)
    }
    func testTableViewHasDelegate() {
        XCTAssertNotNil(TableViewController.upComingEventTable.delegate)
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(TableViewController.upComingEventTable.dataSource)
    }
    
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(TableViewController.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(TableViewController.responds(to: #selector(TableViewController.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(TableViewController.responds(to: #selector(TableViewController.tableView(_:cellForRowAt:))))
    }
    

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

 //MARK:- Api testing
    
    func testGetDogBreed()  {
        let exp = expectation(description: "Waiting for theupcoming event Api  to complete.")

        mockDataLoader.fetchingForUpcomingEvents { result  in
            
            switch result {
            case .failure(let error):
                XCTAssertNil(error.localizedDescription)
                XCTFail()
               
            case .success(let sucessDetails):
                print(sucessDetails)
                XCTAssertNotNil(sucessDetails)
              
            exp.fulfill()
            }
       
        }
        wait(for: [exp], timeout: 10.0)

    }
    
}
