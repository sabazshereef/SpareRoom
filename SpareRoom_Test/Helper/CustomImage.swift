//
//  CustomImage.swift
//  SpareRoom_Test
//
//  Created by sabaz shereef on 04/04/21.
//

import Foundation
import UIKit

let imageCache = NSCache <AnyObject, AnyObject>()


//class customImage: UIImageView {
//   
//    var imageurlString: String?
//    
//    func setImageFromUrlS(ImageURL :String) {
//       
//        imageurlString = ImageURL
//        
//        image = nil
//        
//        if let imageFromCache = imageCache.object(forKey: imageurlString) as? UIImage {
//            
//        }
//        
//        URLSession.shared.dataTask( with: NSURL(string:ImageURL)! as URL, completionHandler: {
//        
//            (data, response, error) -> Void in
//            
//            DispatchQueue.main.async {
//                if let data = data {
//                    
//                    let imageToCache = UIImage(data: data)
//                    imageCache.setObject(imageToCache, forKey: image)
//                    self.image = UIImage(data: data)
//                }
//            }
//        }).resume()
//    }
//    
//}
