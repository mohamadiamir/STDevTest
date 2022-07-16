//
//  ContactViewModel.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import Foundation

final class ContactViewModel {
    
    var contactServiceProtocol: ContactServiceProtocol
    init(contactServiceProtocol: ContactServiceProtocol) {
        self.contactServiceProtocol = contactServiceProtocol
    }
    
    var loading: DataCompletion<Bool>?
    var currentContact: DataCompletion<ContactModel>?
    var newContact: DataCompletion<ContactModel>?
    var updatedContact: DataCompletion<ContactModel>?
    var deletedContact: DataCompletion<ContactDeleteModel>?
    var errorHandler: DataCompletion<String>?
    
    func getContact(id: String) {
        self.loading?(true)
        DispatchQueue.global(qos: .userInteractive).async {[weak self] in
            self?.contactServiceProtocol.getContact(id: id) { result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.loading?(false)
                    switch result {
                    case .success(let contacts):
                        guard let contactsData = contacts else {
                            assertionFailure("No Data")
                            return
                        }
                        self.currentContact?(contactsData)
                    case .failure(let error):
                        self.errorHandler?(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    func deleteContact(id: String) {
        self.loading?(true)
        DispatchQueue.global(qos: .userInteractive).async {[weak self] in
            self?.contactServiceProtocol.deleteContact(id: id) { result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.loading?(false)
                    switch result {
                    case .success(let contacts):
                        guard let contactsData = contacts else {
                            assertionFailure("No Data")
                            return
                        }
                        self.deletedContact?(contactsData)
                    case .failure(let error):
                        self.errorHandler?(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    func addContact(newContact: ContactModel) {
        if let errorString = validateContactToSend(contact: newContact){
            errorHandler?(errorString)
        }else{
            self.loading?(true)
            DispatchQueue.global(qos: .userInteractive).async {[weak self] in
                self?.contactServiceProtocol.addContact(contact: newContact) { result in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        self.loading?(false)
                        switch result {
                        case .success(let contacts):
                            guard let contactsData = contacts else {
                                assertionFailure("No Data")
                                return
                            }
                            self.newContact?(contactsData)
                        case .failure(let error):
                            self.errorHandler?(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func updateContact(id:String, contact: ContactModel) {
        if let errorString = validateContactToSend(contact: contact){
            errorHandler?(errorString)
        }else{
            self.loading?(true)
            DispatchQueue.global(qos: .userInteractive).async {[weak self] in
                self?.contactServiceProtocol.updateContact(id: id, contact: contact) { result in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        self.loading?(false)
                        switch result {
                        case .success(let contacts):
                            guard let contactsData = contacts else {
                                assertionFailure("No Data")
                                return
                            }
                            self.updatedContact?(contactsData)
                        case .failure(let error):
                            self.errorHandler?(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    

    private func validateContactToSend(contact c: ContactModel)->String?{
        if c.firstName?.isEmpty ?? true {
            return "First Name is not Valid"
        }else if c.lastName?.isEmpty ?? true {
            return "Last Name is not Valid"
        }else if let phone = c.phone, phone.isEmpty || !phone.isNumeric{
            return "Phone is not Valid"
        }else if let email = c.email, email.isEmpty || !email.isValidEmail() {
            return "Email is not Valid"
        }else{
            return nil
        }
    }
    
}
