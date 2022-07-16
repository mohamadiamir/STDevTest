//
//  Dictionary+Extension.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import Foundation

extension Dictionary {
    func toData() -> Data? {
        if !self.isEmpty, let jsonData = try? JSONSerialization.data(
            withJSONObject: self,
            options: []) {
            return jsonData
        }
        return nil
    }
}

