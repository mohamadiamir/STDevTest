//
//  UIView+Extension.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import UIKit

protocol LoadingViewable: AnyObject {
    func animateActivityIndicator()
    func removeActivityIndicator()
}

extension UIView: LoadingViewable {
    
    func animateActivityIndicator() {
        let indicatorView = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            indicatorView.style = .large
        }
        addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        indicatorView.restorationIdentifier = "loadingView"
        indicatorView.startAnimating()
    }
    
    func removeActivityIndicator() {
        self.subviews.first(where: {$0.restorationIdentifier == "loadingView"})?.removeFromSuperview()
    }
}
