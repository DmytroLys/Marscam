//
//  MarsPhotosModel.swift
//  Marscam
//
//  Created by Dmytro Lyshtva on 21.09.2023.
//

import Foundation

struct MarsPhotosModel: Codable {
    let photos: [Photo]
}

struct Photo: Codable {
    let camera: Camera
    let img_src: URL
    let earth_date: String
    let rover: Rover
}

struct Camera: Codable {
    let name: String
    let full_name: String
}

struct Rover: Codable {
    let name: String
}
