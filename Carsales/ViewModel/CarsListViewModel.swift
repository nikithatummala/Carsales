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
    
    lazy var apiRequest: APIHandler = {
        return APIHandler()
    }()
    
    var carList : [CarsList] = [CarsList]()
    
    var numberOfItems: Int {
        return carList.count
    }

    /**
     Fetch data from the server url and saves the response Result
     **/
    func loadData(_ url: String, completion: @escaping () -> Void) {
        
        apiRequest.fetchApiData(urlString: url) { [weak self] (data:Result?, error: ErrorModel?) in
            
            if let error = error {
                print(error)
            }
            guard let data = data else {
                print("EROOR near guard .. returnnn")
                return
            }
            
            let result = data.Result.compactMap{ $0 }
            
            self?.carList.removeAll()
            self?.carList = result
            completion()
            
        }
    }
    
    /**
     Returns the number of items in a row for iphone and ipad based on device orientation
     **/
    func getNumberOfItemsPerRow() -> CGFloat {
        
        var count = 1
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            count = Config.potraitColumnsIpad
            if UIApplication.shared.statusBarOrientation == .landscapeLeft ||
                UIApplication.shared.statusBarOrientation == .landscapeRight {
                count = Config.landscapeColumnsIpad
            }
        }
        else {
            if UIApplication.shared.statusBarOrientation == .landscapeLeft ||
                UIApplication.shared.statusBarOrientation == .landscapeRight {
                count = Config.landscapeColumnsIphone
            }
        }
        
        return CGFloat(count)
    }
    
    /**
     Returns the width and height of the cell based on number of items in the row
     **/
    func getSizeForItems(_ collectionView: UICollectionView?) -> CGSize {
        
        let numberOfItemsPerRow:CGFloat = getNumberOfItemsPerRow()
        let spacingBetweenCells:CGFloat = 10
        
        let totalSpacing = ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        
        if let collectionView = collectionView {
            let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: ((width*2)/3) + 60)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
}
