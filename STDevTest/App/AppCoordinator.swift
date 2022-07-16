//
//  AppCoordinator.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import UIKit

class AppCoordinator: NSObject, Coordinator {

    enum Destination {
        case ContactsList
        case Contact(id: String?, delegate: ContactVCDelegate?)
    }
    
    let window: UIWindow?
    
    // app main navigation controller
    var navigationController: UINavigationController
    
    /// AppCoordinator doesn't have any parent because it's the root coordinator
    var parentCoordinator: Coordinator?
    
    /// any nested coordinators will be appending to this array
    /// because we only had two view controller child coordinators array is not gonna work for us
    var childCoordinators: [Coordinator] = []
    
    private var galleryManager = ImagePickerManager()
    
    init(navigationController: UINavigationController, window: UIWindow?) {
        self.navigationController = navigationController
        self.window = window
        super.init()
    }
    
    
    // start of application
    func start(animated: Bool) {
        guard let window = window else { return }
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        goTo(destination: .ContactsList)
    }
    
    
    func openGallery(vc: UIViewController & ImagePickerDelegate){
        galleryManager.delegate = vc
        galleryManager.pickImage(vc)
    }
    
    func goTo(destination: Destination){
        switch destination {
        case .ContactsList:
            let contactListVC = ContactsListVC()
            contactListVC.coordinator = self
            navigationController.pushViewController(contactListVC, animated: true)
            
        case .Contact(let contactID, let delegate):
            let contactVC = ContactVC()
            contactVC.coordinator = self
            contactVC.contactID = contactID
            contactVC.delegate = delegate
            navigationController.pushViewController(contactVC, animated: true)
        }
    }
}
