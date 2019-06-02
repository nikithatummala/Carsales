//
//  CarsListViewModel.swift
//  Carsales
//
//  Created by Nikitha Paruchuri on 31/5/19.
//  Copyright © 2019 Nikitha T. All rights reserved.
//

import Foundation
import UIKit

class CarsListViewModel {
    
    var carList : [CarsList] = [CarsList]()
    
    var numberOfItems: Int {
        return carList.count
    }

    //MARK: - Fetch data from API
    /**
     Fetch data from the server url and saves the response Result
     **/
    func loadData(_ url: String, apiHandler: APIHandler = APIHandler(), completion: @escaping () -> Void) {
        
        apiHandler.fetchApiData(urlString: url) { [weak self] (data:Result?, error: ErrorModel?) in
            
            if let error = error {
                print(error)
                return
            }
            guard let data = data else {
                print("Error in getting data")
                return
            }
            
            let result = data.Result.compactMap{ $0 }
            
            self?.carList.removeAll()
            self?.carList = result
            completion()
            
        }
    }
}
