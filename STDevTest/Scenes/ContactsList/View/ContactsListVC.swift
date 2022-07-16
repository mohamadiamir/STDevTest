//
//  ViewController.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import UIKit

class ContactsListVC: UIViewController {
    // MARK: - Coordinator
    weak var coordinator: AppCoordinator?
    
    // MARK: - TableView
    private lazy var tableView: UITableView = {
        let tbl = UITableView()
        tbl.translatesAutoresizingMaskIntoConstraints = false
        tbl.backgroundColor = .clear
        tbl.showsVerticalScrollIndicator = false
        tbl.contentInset = UIEdgeInsets(top: 0,
                                        left: 0,
                                        bottom: view.safeAreaInsets.bottom+5,
                                        right: 0)
        return tbl
    }()
    
    // MARK: - Properties
    private var dataSource: STDTableViewDataSource<ContactTVCell>!
    // MARK: - ViewModel
    private let ContactsListVM: ContactListViewModel = ContactListViewModel(contactListServiceProtocol: ContactListService.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // adding views
        setupViews()
        // getting listeners ready
        setupBinding()
        // calling service
        callService()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupViews(){
        title = "Contacts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadBtnPressed))
        view.backgroundColor = .stdBackground
        view.addSubview(tableView)
        dataSource = STDTableViewDataSource(cellHeight: 80, items: [],
                                           tableView: tableView,
                                           delegate: self,
                                           anim: .expand(0.3))
        
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
    }
    
    private func setupBinding(){
        ContactsListVM.loading = { [weak self] isLoading in
            guard let self = self else { return }
            self.navigationItem.leftBarButtonItem?.isEnabled = !isLoading
            self.view.isUserInteractionEnabled = !isLoading
            self.tableView.isHidden = isLoading
            isLoading ? self.view.animateActivityIndicator() : self.view.removeActivityIndicator()
        }
        
        ContactsListVM.errorHandler = {[weak self] error in
            self?.showMessage(message: error)
        }
        
        ContactsListVM.contactsArray = {[weak self] contacts in
            self?.dataSource.refreshWithNewItems(contacts)
        }
    }
    
    private func callService(){
        ContactsListVM.getContacts()
    }
    
    private func showMessage(title: String = "Error", message: String, buttonTitle: String = "Ok") {
        let ac = UIAlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
    
    @objc private func reloadBtnPressed(){
        dataSource.refreshWithNewItems([])
        callService()
    }
    
    @objc private func addBtnPressed(){
        coordinator?.goTo(destination: .Contact(id: nil, delegate: self))
    }
}



extension ContactsListVC: STDTableViewDelegate {
    func tableView<T>(didSelectModelAt model: T) {
        guard let contact = model as? ContactModel else {return}
        coordinator?.goTo(destination: .Contact(id: contact.id, delegate: self))
    }
}


extension ContactsListVC: ContactVCDelegate{
    func shouldReload() {
        callService()
    }
}
