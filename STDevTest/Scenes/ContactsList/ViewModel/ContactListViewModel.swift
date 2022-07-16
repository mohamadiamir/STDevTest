//
//  ContactListViewModel.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import Foundation

final class ContactListViewModel {
    
    var contactListServiceProtocol: ContactsListServiceProtocol
    init(contactListServiceProtocol: ContactsListServiceProtocol) {
        self.contactListServiceProtocol = contactListServiceProtocol
    }
    
    var loading: DataCompletion<Bool>?
    var contactsArray: DataCompletion<[ContactModel]>?
    var errorHandler: DataCompletion<String>?
    
    func getContacts() {
        self.loading?(true)
        DispatchQueue.global(qos: .userInteractive).async {[weak self] in
            self?.contactListServiceProtocol.getContacts { result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.loading?(false)
                    switch result {
                    case .success(let contacts):
                        guard let contactsData = contacts else {
                            assertionFailure("No Data")
                            return
                        }
                        self.contactsArray?(contactsData)
                    case .failure(let error):
                        self.errorHandler?(error.localizedDescription)
                    }
                }
            }
        }
    }
    
}
