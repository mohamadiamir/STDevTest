//
//  UIImage+Extension.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/16/22.
//

import UIKit

extension UIImage {
    func toString (completion: @escaping (String?)->Void) {
        compress(maxByte: 100000) { image in
            DispatchQueue.global(qos: .default).async {
                guard let image = image, let imageData = image.pngData() else {
                    completion(nil)
                    return
                }
                completion(imageData.base64EncodedString())
            }
        }
    }
    
    
    func compress(maxByte: Int, completion: @escaping (UIImage?)->Void){
        ImageCompressor.compress(image: self, maxByte: maxByte) { image in
            completion(image)
        }
    }
}
