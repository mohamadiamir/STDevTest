//
//  STDNavigationController.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import UIKit

class STDNavigationController: UINavigationController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    
    private func setupViews(){
        navigationBar.barTintColor = .stdMainColor
        if #available(iOS 13, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .stdBackground
            appearance.titleTextAttributes = [.foregroundColor: UIColor.stdMainColor]
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .clear
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            
            self.navigationBar.standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.stdMainColor]
            UINavigationBar.appearance().tintColor = .stdMainColor
        }
    }
}
