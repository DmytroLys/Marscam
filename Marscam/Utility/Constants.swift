//
//  Constants.swift
//  Marscam
//
//  Created by Dmytro Lyshtva on 21.09.2023.
//

import Foundation


struct Constants {
    
    struct API {
        static let preloadApiCall = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=2023-9-18&api_key=HbftGrKDGExTT9H35vaTocZgZ1s5902cKBUIrZ0w"
        static let apiURL  = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?"
        static let earthDate = "earth_date="
        static let apiKey = "&api_key=HbftGrKDGExTT9H35vaTocZgZ1s5902cKBUIrZ0w"
    }
    
    struct PickerData {
        static let roverData = ["All","Curiosity", "Opportunity", "Spirit"]
        static let cameraData = ["All","Front Hazard Avoidance Camera", "Rear Hazard Avoidance Camera", "Mast Camera", "Chemistry and Camera Complex", "Mars Hand Lens Imager", "Mars Descent Imager", "Navigation Camera", "Panoramic Camera","Miniature Thermal Emission Spectrometer (Mini-TES)"]
    }
    
    struct Segues {
        static let goToViewController = "goToMain"
        static let goToHistoryController = "goToHistory"
    }
    
    struct FilterTableViewCell {
        static let name = "FilterTableViewCell"
        static let cellReuseIdentifier = "HistoryCell"
    }
    
    struct ImageCell {
        static let name = "ImageCell"
        static let cellReuseIdentifier = "ReusableCell"
    }
    
    struct NotificationCenter {
        static let name = "useFilterFromHistory"
        static let photos = "photos"
        static let filter = "filter"
    }
    
}
