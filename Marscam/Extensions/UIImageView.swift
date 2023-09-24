//
//  UIImageView.swift
//  Marscam
//
//  Created by Dmytro Lyshtva on 21.09.2023.
//

import UIKit

extension UIImageView {
    func loadImage(from url: URL, completion: ((UIImage?) -> Void)? = nil) {
            if let cachedImage = ImageCache.shared.getImage(for: url as NSURL) {
                self.image = cachedImage
                completion?(cachedImage)
                return
            }
            
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
                
                ImageCache.shared.setImage(image, for: url as NSURL)
                
                DispatchQueue.main.async {
                    self.image = image
                    completion?(image)
                }
            }.resume()
        }
}

class ImageCache {
    private var cache: NSCache<NSURL, UIImage> = NSCache()
    
    static let shared = ImageCache()
    
    private init() {}
    
    func getImage(for url: NSURL) -> UIImage? {
        return cache.object(forKey: url)
    }
    
    func setImage(_ image: UIImage, for url: NSURL) {
        cache.setObject(image, forKey: url)
    }
}
