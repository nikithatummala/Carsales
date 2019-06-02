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
    
    //MARK: -
    /**
    Number of rows returned as carDetails count, font size returned based on iPhone and iPad
    **/
    var numberOfRows: Int {
        return carDetails.count
    }
    
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
    
    init(withApiHandler apiHandler: APIHandler = APIHandler(), imageHandler: ImageHandler = ImageHandler()) {
        
        self.apiHandler = apiHandler
        self.imageHandler = imageHandler
    }
    
    //MARK: - Fetch data from API
    /**
     Fetches data from the server url passed as parameter, saves the cardetails received in response and calls the completion handler.
     **/
    func loadData(_ url: String, completion: @escaping () -> Void) {
        
        apiHandler.fetchApiData(urlString: url) { [weak self] (data:DetailsResult?, error: ErrorModel?) in
            
            if let error = error {
                print(error)
            }
            guard let data = data else {
                print("Error in getting data")
                return
            }
            
            guard let result = data.Result, result.count > 0 else {
                print("Error, result not having data")
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
    
    //MARK: - Image handling
    /**
     Checks if images in the 'carPhotosUrl' exist in cache and loads from it, otherwise requests for dowloading the image
     **/
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
    
    /**
     Downloads the image from the url and calls the completion handler if all the images in the url are downloaded
     **/
    func downloadImage(from imgUrl: String, completion: @escaping () -> Void) {

        request = imageHandler.retrieveImage(for: imgUrl) { [weak self] image in
            self?.images.append(image)
            if self?.images.count == self?.carPhotosUrl?.count {
                completion()
            }
        }
    }

}
