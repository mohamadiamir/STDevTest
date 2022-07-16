//
//  Color+Extension.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import UIKit

extension UIColor {
    
    enum CustomColor: String{
        case Background = "Background"
        case MainColor = "MainColor"
        case TextColor = "TextColor"
        
        var color: UIColor {
            guard let color = UIColor(named: rawValue) else {
                assertionFailure("color not found")
                return .red
            }
            return color
        }
    }
    
    static var stdMainColor: UIColor = {
        CustomColor.MainColor.color
    }()
    
    static var stdBackground: UIColor = {
        CustomColor.Background.color
    }()
    
    static var stdTextColor: UIColor = {
        CustomColor.TextColor.color
    }()
}
