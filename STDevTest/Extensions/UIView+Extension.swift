//
//  UIView+Extension.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import UIKit

extension UIView {
    var Width: CGFloat {
        frame.size.width
    }
    
    var Height: CGFloat{
        frame.size.height
    }
    
    var PositionX: CGFloat{
        frame.origin.x
    }
    
    var PositionY: CGFloat{
        frame.origin.y
    }
    
    func FadeAnimation(){
        self.alpha = 0
        UIView.animate(withDuration: 0.7) {[weak self] in
            self?.alpha = 1
        }
    }
}

