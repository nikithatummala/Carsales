//
//  Constants.swift
//  Carsales
//
//  Created by Nikitha Paruchuri on 31/5/19.
//  Copyright © 2019 Nikitha T. All rights reserved.
//

import Foundation

enum Config {
    
    static let appTitle = "Carsales"

    static let apiBaseURL = "https://app-car.carsalesnetwork.com.au"
    static let listingURI = "/stock/car/test/v1/listing"
    
    static let requestCredentials = "?username=test&password=2h7H53eXsQupXvkz"
    
    static let imageFolderName = "carsalesImages"
    
    static let internetErrorMsg = "Something wrong..\n Please use wifi or turn on the mobile data to continue!!"
}

enum Constants {
    
    static let potraitColumnsIpad = 2
    static let landscapeColumnsIpad = 3
    static let landscapeColumnsIphone = 2
    
    static let collectionViewCellSpacing = 85
}
