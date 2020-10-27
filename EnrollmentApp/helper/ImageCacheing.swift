//
//  ImageCacheing.swift
//  EnrollmentApp
//
//  Created by Arpit Singh on 27/10/20.
//

import UIKit
// MARK: - Image downloading
let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func loadImagesIntoCaches(url: String) {
        self.image = UIImage(named: "placeholder")
        if let cacheImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = cacheImage
            return
        }
        guard let url = URL(string: url) else {
            return
        }
        let data = URLSession.shared.dataTask(with: url) { data, _, error in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                    if let downloadData = UIImage(data: data!) {
                    imageCache.setObject(downloadData, forKey: url as AnyObject)
                    self.image = downloadData
                }
            }
        }
        data.resume()
    }
}
