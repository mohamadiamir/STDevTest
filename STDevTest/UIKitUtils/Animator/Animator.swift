//
//  Animator.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import UIKit

class STDCellAnimators {
    public enum AnimType {
        case none
        case expand(TimeInterval)
    }
    
    static func animateCell(type: AnimType, cell: UIView) {
        switch type {
        case .none:
            break
        case .expand(let timeInterval):
            cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
            UIView.animate(withDuration: timeInterval){
                cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
            }
        }
    }
}
