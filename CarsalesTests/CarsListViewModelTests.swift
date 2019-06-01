//
//  CarsListViewModelTests.swift
//  CarsalesTests
//
//  Created by Nikitha Paruchuri on 1/6/19.
//  Copyright © 2019 Nikitha T. All rights reserved.
//

import XCTest
@testable import Carsales

class CarsListViewModelTests: XCTestCase {
    
    var viewModel : MockCarsListViewModel!

    override func setUp() {
        
        super.setUp()
        viewModel = MockCarsListViewModel()
    }

    override func tearDown() {
        
        viewModel = nil
        super.tearDown()
    }
    
    func testLoadData() {
        
        let apiURl = "https://demo.url"
        
        let expec = expectation(description: "ass")
        
        viewModel.loadData(apiURl) {
            expec.fulfill()
        }
      
        waitForExpectations(timeout: 1)
        
        XCTAssert(viewModel.isApiCalled, "Viewmodel api is not called")
        XCTAssertEqual(viewModel.carList.count, 1, "Viewmodel cars list not added")
    }

}


class MockCarsListViewModel : CarsListViewModel  {
    
    var isApiCalled = false
    
    override func loadData(_ url: String, apiHandler: APIHandler = APIHandler(), completion: @escaping () -> Void) {
        
        isApiCalled = true
        
        let carListItem = CarsList(carID: "Abcd", title: "xyz", location: "Melb", price: "$35,567", mainPhoto: "https://abcd.com", detailsUrl: "https://qwerty.com")
        
        carList.append(carListItem)
        completion()
    }
    
}
