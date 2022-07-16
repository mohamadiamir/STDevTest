//
//  STDTableViewDataSource.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import UIKit

protocol STDTableViewDelegate: AnyObject {
    func tableView(willDisplay cellIndexPath: IndexPath, cell: UITableViewCell)
    func tableView(_ tableview: UITableView, didSelectItem index: IndexPath)
    func tableView(_ tableview: UITableView, didDeselectItemAt index: IndexPath)
    func tableView<T>(didSelectModelAt model: T)
    func tableview(didReachEndOf scrollView: UIScrollView)
}

extension STDTableViewDelegate {
    func tableView(willDisplay cellIndexPath: IndexPath, cell: UITableViewCell) { }
    func tableView(_ tableview: UITableView, didSelectItem index: IndexPath) { }
    func tableView(_ tableview: UITableView, didDeselectItemAt index: IndexPath) { }
    func tableView<T>(didSelectModelAt model: T) { }
    func tableview(didReachEndOf scrollView: UIScrollView){ }
}

class STDTableViewDataSource<T: STDTableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Variables
    
    /// return nil  or 0 for automaticDimension
    var cellHeight: CGFloat?
    var items: [T.CellViewModel] = []
    var selectItem: IndexPath?
    var tableView: UITableView
    weak var delegate: STDTableViewDelegate?
    private var animationType: STDCellAnimators.AnimType
    private var animatedCells = [Int]()
    private var reAnimation = false
    
    // MARK: - Initializer
    init(cellHeight: CGFloat? = nil,
         items: [T.CellViewModel],
         tableView: UITableView,
         delegate: STDTableViewDelegate,
         anim: STDCellAnimators.AnimType = .none,
         reAnimation: Bool = false) {
        self.cellHeight = cellHeight
        self.items = items
        self.tableView = tableView
        self.animationType = anim
        self.reAnimation = reAnimation
        if cellHeight == 0 || cellHeight == nil {
            self.tableView.estimatedRowHeight = UITableView.automaticDimension
            self.tableView.rowHeight = UITableView.automaticDimension
        }
        self.tableView.register(T.self, forCellReuseIdentifier: String.init(describing: T.self))
        self.delegate = delegate
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: T.self), for: indexPath) as! T
        cell.configureCellWith(items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.tableView(tableView, didSelectItem: indexPath)
        delegate?.tableView(didSelectModelAt: items[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !animatedCells.contains(indexPath.row) || reAnimation{
            STDCellAnimators.animateCell(type: animationType, cell: cell)
            animatedCells.append(indexPath.row)
        }
        delegate?.tableView(willDisplay: indexPath, cell: cell)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellheight = cellHeight, cellHeight != 0 else { return UITableView.automaticDimension }
        return cellheight
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            delegate?.tableview(didReachEndOf: scrollView)
        }
    }
    
    func appendItemsToTableView( _ newItems: [T.CellViewModel]) {
        let lastItem = self.items.count
        self.items.append(contentsOf: newItems)
        let indexPaths = newItems.enumerated().map { (index, _) in
            IndexPath(item: lastItem + index, section: 0)
        }
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: indexPaths, with: .automatic)
        self.tableView.endUpdates()
    }
    
    

    func refreshWithNewItems(_ newItems: [T.CellViewModel]) {
        self.items = newItems
        self.tableView.reloadData()
    }
}
