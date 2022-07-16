//
//  ContactListModel.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import Foundation

// MARK: - SearchModel
struct ContactModel: Codable {
    let id: String?
    let firstName, lastName, phone, email: String?
    let images: [String?]?
    
    enum CodingKeys: String, CodingKey {
        case firstName, lastName, phone, email, images
        case id = "_id"
    }
    
    
    
    func toDictionary()->[String:Any]{
        var dic: [String:Any] = [:]
        dic["_id"] = id
        dic["firstName"] = firstName
        dic["lastName"] = lastName
        dic["phone"] = phone
        dic["email"] = email
        dic["images"] = images
        return dic
    }
}
