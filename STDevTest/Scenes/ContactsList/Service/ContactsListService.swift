//
//  ContactsListService.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import Foundation

typealias ContactListCompletionHandler = (Result<[ContactModel]?, RequestError>) -> Void

protocol ContactsListServiceProtocol {
    func getContacts(completionHandler: @escaping ContactListCompletionHandler)
}


class ContactListService: ContactsListServiceProtocol {
    
    private let requestManager: RequestManagerProtocol
    
    public static let shared: ContactsListServiceProtocol = ContactListService(requestManager: RequestManager.shared)
    
    // We can also inject requestManager for testing purposes.
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func getContacts(completionHandler: @escaping ContactListCompletionHandler) {
        self.requestManager.performRequestWith(params: [:], url: "", httpMethod: .get) {
            (result: Result<[ContactModel]?, RequestError>) in
            DispatchQueue.main.async {
                completionHandler(result)
            }
        }
    }
    
}
