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
     Starts network checking to check internet status if it is active or not, updates the isNetworkActive flag accordingly and posts notification when active network connection is detected
     **/
    func startNetworkCheck() {
        
        monitor.pathUpdateHandler = { path in
            
            if path.status == .satisfied {
                
                self.isNetworkActive = true
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .didNetworkStatusChange, object: nil, userInfo: ["status": self.isNetworkActive])
                }
            } else {
                self.isNetworkActive = false
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
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
            return CGSize(width: width, height: ((width*2)/3) +  CGFloat(Constants.collectionViewCellSpacing))
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
            count = Constants.potraitColumnsIpad
            if UIApplication.shared.statusBarOrientation == .landscapeLeft ||
                UIApplication.shared.statusBarOrientation == .landscapeRight {
                count = Constants.landscapeColumnsIpad
            }
        }
        else {
            if UIApplication.shared.statusBarOrientation == .landscapeLeft ||
                UIApplication.shared.statusBarOrientation == .landscapeRight {
                count = Constants.landscapeColumnsIphone
            }
        }
        
        return CGFloat(count)
    }
    
}

extension Notification.Name {
    
    static let didNetworkStatusChange = NSNotification.Name("didNetworkStatusChange")
}
