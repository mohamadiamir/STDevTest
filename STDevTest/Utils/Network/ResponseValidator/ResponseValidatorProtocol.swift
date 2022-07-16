//
//  ResponseValidatorPortocol.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import Foundation

protocol ResponseValidatorProtocol {
    func validation<T: Codable>(response: HTTPURLResponse?, data: Data?) -> Result<T, RequestError>
}
