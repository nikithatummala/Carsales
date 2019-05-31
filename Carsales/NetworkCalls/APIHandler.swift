//
//  APIHandler.swift
//  Carsales
//
//  Created by Nikitha Paruchuri on 31/5/19.
//  Copyright © 2019 Nikitha T. All rights reserved.
//

import Foundation


class APIHandler {
        
    public func fetchApiData<T: Decodable>(urlString: String, completion: @escaping (T?, ErrorModel?) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            if let err = err {
                print("Failed to get data:", err)
                return
            }
            if let error = self.checkResponse(response: response, data: data) {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            if let responseData:T = self.handleSuccess(data: data) {
                DispatchQueue.main.async {
                    completion(responseData, nil)
                }
            }
            }.resume()
    }
    
    func handleSuccess<T: Decodable>(data: Data?) -> T? {
        
        guard let data = data else { return nil }
        do {
            let responseModel = try JSONDecoder().decode(T.self, from: data)
            return responseModel
        } catch let jsonError {
            print("Failed to serialize json:", jsonError)
        }
        
        return nil
    }
    
    func checkResponse(response: URLResponse?, data: Data?) -> ErrorModel? {
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode != 200 {
                let error = self.errorHandle(httpResponse: httpResponse, data: data)
                return error
            }
        }
        return nil
    }
    
    func errorHandle(httpResponse: HTTPURLResponse, data: Data?) -> ErrorModel? {
        
        print("Status code: \(httpResponse.statusCode)")
        
        var error: ErrorModel?
        guard let data = data else { return nil }
        do {
            error = try JSONDecoder().decode(ErrorModel.self, from: data)
        }
        catch let jsonError {
            print("Failed to serialize error in json:", jsonError)
        }
        print("Error code : \(error?.Code ?? "")")
        print("Message : \(error?.Message ?? "")")
        
        return error
    }
    
}
