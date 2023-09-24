//
//  APIManager.swift
//  Marscam
//
//  Created by Dmytro Lyshtva on 21.09.2023.
//

import Foundation

protocol APIManagerDelegate {
    func didUpdatePhotos(_ apiManager: APIManager, photos: [Photo])
    func didFailWithError(error:Error)
}

struct APIManager {
    var delegate: APIManagerDelegate?
    
    
    func fetchPhotos () {
        let urlString = Constants.API.preloadApiCall
        performRequest(with: urlString)
        
    }
    func fetchPhotos (date: String) {
        let apiData = Constants.API.earthDate + "\(date)"
        let urlString = Constants.API.apiURL + apiData + Constants.API.apiKey
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString : String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                } else {
                    if let safeData = data {
                        if let photos = parseJson(safeData) {
                            delegate?.didUpdatePhotos(self, photos: photos)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(_ photosData : Data) -> [Photo]? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(MarsPhotosModel.self, from: photosData)
            
            let photos = decodedData.photos
            return photos
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}
