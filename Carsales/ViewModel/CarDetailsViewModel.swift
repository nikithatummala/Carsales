//
//  CarDetailsViewModel.swift
//  Carsales
//
//  Created by Nikitha Paruchuri on 1/6/19.
//  Copyright © 2019 Nikitha T. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class CarDetailsViewModel {
    
    
    var carDetails:[String] = [String]()
    var carPhotosUrl:[String]?
    
    var images:[Image] = [Image]()
    
    var apiHandler : APIHandler
    var imageHandler : ImageHandler
    
    var request: Request?
    
    var numberOfRows: Int {
        return carDetails.count
    }
    
    init(withApiHandler apiHandler: APIHandler = APIHandler(), imageHandler: ImageHandler = ImageHandler()) {
        
        self.apiHandler = apiHandler
        self.imageHandler = imageHandler
    }
    
    func loadData(_ url: String, completion: @escaping () -> Void) {
        
        apiHandler.fetchApiData(urlString: url) { [weak self] (data:DetailsResult?, error: ErrorModel?) in
            
            if let error = error {
                print(error)
            }
            guard let data = data else {
                print("EROOR near guard .. returnnn")
                return
            }
            
            guard let result = data.Result, result.count > 0 else {
                print("Errorr")
                return
            }
            
            let obj = result[0]
            
            self?.carDetails.append(obj.overview.photos[0])
            self?.carDetails.append(obj.overview.location)
            self?.carDetails.append(obj.overview.price)
            self?.carDetails.append(obj.saleStatus)
            self?.carDetails.append(obj.comments)
            
            self?.carPhotosUrl = obj.overview.photos
            completion()
        }
    }
    
    
    func loadImages(completion: @escaping () -> Void) {
        
        request?.cancel()
        images.removeAll()
        carPhotosUrl?.forEach({
            
            if let image = imageHandler.cachedImage(for: $0) {
                images.append(image)
            }
            else {
                downloadImage(from: $0, completion: completion)
            }
        })
    }
    
    func downloadImage(from imgUrl: String, completion: @escaping () -> Void) {

        request = imageHandler.retrieveImage(for: imgUrl) { [weak self] image in
            self?.images.append(image)
            if self?.images.count == self?.carPhotosUrl?.count {
                completion()
            }
        }
    }

}
