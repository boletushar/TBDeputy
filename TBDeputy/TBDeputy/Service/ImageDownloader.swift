//
//  ImageDownloader.swift
//  TBDeputy
//
//  Created by Tushar on 16/9/18.
//  Copyright © 2018 bole.tushar. All rights reserved.
//

import Foundation
import UIKit

class ImageService {
    
    static func downloadImage(withURL url:URL, andTag tag:Int, completion: @escaping (_ image:UIImage?, _ tag:Int)->()) {
        
        let dataTask = URLSession.shared.dataTask(with: url) { data, responseURL, error in
            
            var downloadedImage:UIImage?
            
            guard let response = responseURL as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                completion(nil, tag)
                return
            }
            
            if error != nil {
                completion(nil, tag)
                return
            }
            
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            
            DispatchQueue.main.async {
                completion(downloadedImage, tag)
            }
        }
        
        dataTask.resume()
    }
}
