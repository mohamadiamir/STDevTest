//
//  STDTableViewCell.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import UIKit

protocol STDTableViewCell: UITableViewCell {
    associatedtype CellViewModel
    func configureCellWith(_ item: CellViewModel)
}

