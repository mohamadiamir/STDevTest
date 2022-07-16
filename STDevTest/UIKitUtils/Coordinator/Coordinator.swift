//
//  Coordinator.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController {get set}
    var parentCoordinator: Coordinator? {get set}
    var childCoordinators: [Coordinator] {get set}
    func start(animated: Bool)
    func finish()
}


extension Coordinator {
    func start(){
        start(animated: true)
    }
    
    func childDidFinish(_ child: Coordinator){
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child{
            childCoordinators.remove(at: index)
            break
        }
    }
    
    func finish(){}
}

