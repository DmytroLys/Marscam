//
//  UIImageView.swift
//  Marscam
//
//  Created by Dmytro Lyshtva on 21.09.2023.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL, completion: ((UIImage?) -> Void)? = nil) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                error == nil,
                let image = UIImage(data: data)
            else {
                DispatchQueue.main.async {
                    completion?(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.image = image
                completion?(image)
            }
        }.resume()
    }
}
