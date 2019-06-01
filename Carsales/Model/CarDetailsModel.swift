//
//  CarDetailsModel.swift
//  Carsales
//
//  Created by Nikitha Paruchuri on 1/6/19.
//  Copyright © 2019 Nikitha T. All rights reserved.
//

import Foundation

struct DetailsResult : Codable {
    
    var Result : [Details]?
}

struct Details : Codable {
    
    let carID : String
    let saleStatus : String
    let overview : Overview
    let comments : String
    
    private enum CodingKeys: String, CodingKey {
        case carID = "Id"
        case saleStatus = "SaleStatus"
        case overview = "Overview"
        case comments = "Comments"
    }
}

struct Overview :Codable {
    
    let location : String
    let price : String
    let photos : [String]
    
    private enum CodingKeys: String, CodingKey {
        case location = "Location"
        case price = "Price"
        case photos = "Photos"
    }
}
