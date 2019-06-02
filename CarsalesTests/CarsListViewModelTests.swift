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
        
        let expec = expectation(description: "API call expectation")
        
        viewModel.loadData(apiURl) {
            expec.fulfill()
        }
      
        waitForExpectations(timeout: 1)
        
        XCTAssert(viewModel.isApiCalled, "Viewmodel api is not called")
        XCTAssertEqual(viewModel.numberOfItems, 2, "Viewmodel cars list not added")
    }
    
    func testDatainViewModel() {
        
        let apiURl = "https://demo.url"
        
        let expec = expectation(description: "ass")
        
        viewModel.loadData(apiURl) {
            expec.fulfill()
        }
        
        waitForExpectations(timeout: 1)
        
        let data = viewModel.carList[0]
        XCTAssertEqual(data.carID, "Mcds-1234", "Improper initializtion of carId")
        XCTAssertEqual(data.title, "Mercedes", "Improper initializtion of title")
        XCTAssertEqual(data.location, "VIC", "Improper initializtion of location")
        XCTAssertEqual(data.detailsUrl, "https://detailsurl-mcds.com", "Improper initializtion of details url")
        XCTAssertEqual(data.price, "$55,237", "Improper initializtion of price")
    }
}


class MockCarsListViewModel : CarsListViewModel  {
    
    var isApiCalled = false
    
    override func loadData(_ url: String, apiHandler: APIHandler = APIHandler(), completion: @escaping () -> Void) {
        
        isApiCalled = true
        
        let carListItem1 = CarsList(carID: "Mcds-1234", title: "Mercedes", location: "VIC", price: "$55,237", mainPhoto: "https://photourl.com", detailsUrl: "https://detailsurl-mcds.com")
        let carListItem2 = CarsList(carID: "Jeep-1234", title: "Jeep", location: "NSW", price: "$75,561", mainPhoto: "https://photourl.com", detailsUrl: "https://detailsurl-jeep.com")
        
        carList.append(carListItem1)
        carList.append(carListItem2)
        completion()
    }
    
}
