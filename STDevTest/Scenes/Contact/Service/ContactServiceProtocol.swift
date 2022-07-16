//
//  ContactServiceProtocol.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import Foundation

typealias ContactCompletionHandler = (Result<ContactModel?, RequestError>) -> Void
typealias DeleteContactCompletionHandler = (Result<ContactDeleteModel?, RequestError>) -> Void

protocol ContactServiceProtocol {
    func getContact(id:String, completionHandler: @escaping ContactCompletionHandler)
    func addContact(contact: ContactModel, completionHandler: @escaping ContactCompletionHandler)
    func updateContact(id:String, contact: ContactModel, completionHandler: @escaping ContactCompletionHandler)
    func deleteContact(id:String, completionHandler: @escaping DeleteContactCompletionHandler)
}


private enum ContactEndpoint {
    case find(String)
    
    var path: String {
        switch self {
        case .find(let id):
            return "/\(id)"
        }
    }
}

class ContactService: ContactServiceProtocol {
    
    private let requestManager: RequestManagerProtocol
    
    public static let shared: ContactServiceProtocol = ContactService(requestManager: RequestManager.shared)
    
    // We can also inject requestManager for testing purposes.
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func getContact(id:String, completionHandler: @escaping ContactCompletionHandler) {
        self.requestManager.performRequestWith(params: [:], url: ContactEndpoint.find(id).path, httpMethod: .get) {
            (result: Result<ContactModel?, RequestError>) in
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
    }
    
    func deleteContact(id: String, completionHandler: @escaping DeleteContactCompletionHandler){
        self.requestManager.performRequestWith(params: [:], url: ContactEndpoint.find(id).path, httpMethod: .delete) {
            (result: Result<ContactDeleteModel?, RequestError>) in
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
    }
    
    func addContact(contact: ContactModel, completionHandler: @escaping ContactCompletionHandler) {
        var contactDic = contact.toDictionary()
        contactDic["_id"] = nil
        self.requestManager.performRequestWith(params: contactDic, url: "", httpMethod: .post) {
            (result: Result<ContactModel?, RequestError>) in
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
    }
    
    func updateContact(id:String, contact: ContactModel, completionHandler: @escaping ContactCompletionHandler) {
        self.requestManager.performRequestWith(params: contact.toDictionary(), url: ContactEndpoint.find(id).path, httpMethod: .put) {
            (result: Result<ContactModel?, RequestError>) in
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
    }
}
