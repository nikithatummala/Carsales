//
//  Helper.swift
//  Carsales
//
//  Created by Nikitha Paruchuri on 1/6/19.
//  Copyright © 2019 Nikitha T. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    static var shared: Helper = {
        return Helper()
    }()
    
    let themeColor = UIColor(red: 22/255, green: 123/255, blue: 201/255, alpha: 1.0) //blue
    
    var mediumFontSize : CGFloat {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 28
        }
        return 18
    }
    
    var smallFontSize : CGFloat {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 26
        }
        return 16
    }
    
    var isIpad : Bool {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        }
        return false
    }
    
}
