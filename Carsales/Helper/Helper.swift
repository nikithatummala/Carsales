//
//  Helper.swift
//  Carsales
//
//  Created by Nikitha Paruchuri on 1/6/19.
//  Copyright © 2019 Nikitha T. All rights reserved.
//

import Foundation
import UIKit
import Network

class Helper {
    
    static var shared: Helper = {
        return Helper()
    }()
    
    let themeColor = UIColor(red: 22/255, green: 123/255, blue: 201/255, alpha: 1.0) //blue
    
    let monitor = NWPathMonitor()
    var isNetworkActive = true
    
    var isIpad : Bool {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        }
        return false
    }
    
    /**
     Starts network checking to check internet status if it is active or not, and updates the isNetworkActive flag accordingly
     **/
    func startNetworkCheck() {
        
        monitor.pathUpdateHandler = { path in
            
            if path.status == .satisfied {
                self.isNetworkActive = true
            } else {
                self.isNetworkActive = false
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    /**
     Displays a label with given text in the center of the given view
     **/
    func showErrorLabel(_ view: UIView, text: String) {
        
        let errorLabel = UILabel(frame: CGRect(x: 0,
                                               y: 0,
                                               width: view.frame.size.width - 30,
                                               height: view.frame.size.height - 50))
        errorLabel.numberOfLines = 0
        errorLabel.center = view.center
        errorLabel.text = text
        errorLabel.textAlignment = .center
        errorLabel.textColor = Helper.shared.themeColor
        
        view.addSubview(errorLabel)
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
            return CGSize(width: width, height: ((width*2)/3) +  CGFloat(Config.collectionViewCellSpacing))
        }
        else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    /**
     Returns the number of items in a row for iphone and ipad based on device orientation
     **/
    func getNumberOfItemsPerRow() -> CGFloat {
        
        var count = 1
        
        if Helper.shared.isIpad == true {
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
    
}
