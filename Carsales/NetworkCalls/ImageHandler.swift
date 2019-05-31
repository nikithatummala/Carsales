//
//  ImageHandler.swift
//  Carsales
//
//  Created by Nikitha Paruchuri on 31/5/19.
//  Copyright © 2019 Nikitha T. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class ImageHandler {
    
    let fileManager = FileManager.default
    let directoryPath : String
    
    init(_ folderName : String) {
        
        directoryPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(folderName)
        configureDirectory()
    }

    /**
     Verifies if folder exists and creates at the mentioned path in 'directoryPath'
     **/
    func configureDirectory() {
        
        if !fileManager.fileExists(atPath: directoryPath) {
            try! fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    /**
     Deletes the content present in the 'directoryPath'
     **/
    func deleteImages() {
        
        if fileManager.fileExists(atPath: directoryPath) {
            try! fileManager.removeItem(atPath: directoryPath)
        }
    }
    
    /**
     Checks if image exists at given path and returns it, otherwise request is made to fetch the image
     **/
    func getImage(_ imageUrl: String, completion: @escaping (UIImage?) -> Void) {
                
        let lastpath = (imageUrl as NSString).lastPathComponent
        let fullPath = directoryPath + "/" + lastpath

        if fileManager.fileExists(atPath: fullPath) {
            let image = UIImage(contentsOfFile: fullPath)
            completion(image)
            return
        }
        
        Alamofire.request(imageUrl, method: .get).responseImage { response in
            if let resultImage = response.result.value  {
                self.saveImageDocumentDirectory(image: resultImage, imageName: lastpath)
                completion(resultImage)
            }
        }
    }
    
    /**
     Image received from the requestURL is saved in the directoryPath
     **/
    func saveImageDocumentDirectory(image: UIImage, imageName: String) {
       
        let finalPath = directoryPath + "/" + imageName
        let imageUrl: URL = URL(fileURLWithPath: finalPath)

        try? image.pngData()?.write(to: imageUrl)
    }
    
}
