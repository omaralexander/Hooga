//
//  Extension.swift
//  Hooga
//
//  Created by Omar Abbas on 12/17/16.
//  Copyright © 2016 Omar Abbas. All rights reserved.
//

import UIKit
func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
    
    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}
let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCachWithUrlString(urlString: String) {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as UIImage?{
            self.image = cachedImage
           
            return
        }
        
        
        let url = URL(string: urlString)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data,response,error) in
                if error != nil{
                    print(error as Any)
                    return
                }
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data!){
                        imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                        self.image = downloadedImage
                    }
                }
            }).resume()
        }
    }

