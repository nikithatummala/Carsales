//
//  CarsListModel.swift
//  Carsales
//
//  Created by Nikitha Paruchuri on 31/5/19.
//  Copyright © 2019 Nikitha T. All rights reserved.
//

import Foundation

struct Result : Codable {
    
    var Result : [CarsList]
}

struct CarsList : Codable {
    
    let carID : String
    let title : String
    let location : String
    let price : String
    let mainPhoto : String
    let detailsUrl : String
    
    private enum CodingKeys: String, CodingKey {
        case carID = "Id"
        case title = "Title"
        case location = "Location"
        case price = "Price"
        case mainPhoto = "MainPhoto"
        case detailsUrl = "DetailsUrl"
    }
}

public struct ErrorModel: Decodable {
    let Code: String?
    let Message: String?
}
