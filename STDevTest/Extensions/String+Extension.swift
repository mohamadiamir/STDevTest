//
//  String+Extension.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import UIKit

extension String {
    func toImage(completion: @escaping DataCompletion<UIImage?>) {
        DispatchQueue.global(qos: .default).async {
            if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters), let image = UIImage(data: data){
                completion(image)
            }else{
                completion(nil)
            }
        }
    }
    
    var isNumeric : Bool {
        return Double(self) != nil
    }
    
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
          return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
      }
}
