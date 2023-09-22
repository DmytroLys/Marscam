//
//  FilterHistoryList.swift
//  Marscam
//
//  Created by Dmytro Lyshtva on 22.09.2023.
//

import Foundation
import UIKit
import RealmSwift

class FilterHistory: Object {
    
    @Persisted var roverName: String = ""
    @Persisted var cameraName: String = ""
    @Persisted var date: String = ""
    
}
