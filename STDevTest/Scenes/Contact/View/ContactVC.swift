//
//  ContactVC.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import UIKit

protocol ContactVCDelegate: AnyObject {
    func shouldReload()
}

class ContactVC: UIViewController {
    
    // MARK: - Coordinator
    weak var coordinator: AppCoordinator?
    
    // MARK: - ViewController Delegate
    weak var delegate: ContactVCDelegate?
    
    // MARK: - contactToFetch
    var contactID: String?
    
    // MARK: - ViewModel
    private let contactVM: ContactViewModel = ContactViewModel(contactServiceProtocol: ContactService.shared)
    
    
    private lazy var avatarView: AvatarView = {
       let imgv = AvatarView()
        imgv.translatesAutoresizingMaskIntoConstraints = false
        return imgv
    }()
    
    private lazy var firstNameTF: UITextField = {
       let tf = UITextField()
        tf.keyboardType = .namePhonePad
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "First Name"
        return tf
    }()
    
    private lazy var LastNameTF: UITextField = {
       let tf = UITextField()
        tf.keyboardType = .namePhonePad
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Last Name"
        return tf
    }()
    
    private lazy var nameStack: UIStackView = {
       let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    
    private lazy var phoneTF: UITextField = {
       let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = .phonePad
        tf.placeholder = "Phone Number"
        return tf
    }()
    
    private lazy var EmailTF: UITextField = {
       let tf = UITextField()
        tf.keyboardType = .emailAddress
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Email"
        return tf
    }()
    
    private lazy var detailStack: UIStackView = {
       let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    
    private lazy var deleteButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Delete", for: .normal)
        btn.setTitleColor(.systemRed, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(self, action: #selector(deleteBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    private lazy var contentView:UIView = {
       let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBinding()
        callService()
    }
    
    deinit {
        print("relased from memory", Self.description())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            avatarView.widthAnchor.constraint(equalToConstant: 80),
            avatarView.heightAnchor.constraint(equalToConstant: 80),
            
            nameStack.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            nameStack.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10),
            nameStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            detailStack.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 15),
            detailStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            deleteButton.topAnchor.constraint(equalTo: detailStack.bottomAnchor, constant: 30),
            deleteButton.widthAnchor.constraint(equalToConstant: 100),
            deleteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    private func setupViews(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnPressed))
        view.backgroundColor = .stdBackground
        view.addSubview(contentView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        contentView.addGestureRecognizer(tap)
        contentView.addSubview(avatarView)
        contentView.addSubview(nameStack)
        contentView.addSubview(detailStack)
        contentView.addSubview(deleteButton)
        nameStack.addArrangedSubview(firstNameTF)
        nameStack.addArrangedSubview(LastNameTF)
        detailStack.addArrangedSubview(phoneTF)
        detailStack.addArrangedSubview(EmailTF)
        
        avatarView.delegate = self
    }
    
    private func setupBinding(){
        contactVM.loading = { [weak self] isLoading in
            guard let self = self else { return }
            self.navigationItem.rightBarButtonItem?.isEnabled = !isLoading
            self.view.isUserInteractionEnabled = !isLoading
            self.contentView.isHidden = isLoading
            isLoading ? self.view.animateActivityIndicator() : self.view.removeActivityIndicator()
        }
        
        contactVM.errorHandler = {[weak self] error in
            self?.showMessage(message: error)
        }
        
        contactVM.currentContact = {[weak self] contact in
            self?.loadContact(contact)
        }
        
        contactVM.deletedContact = {[weak self] deletedContact in
            self?.delegate?.shouldReload()
            self?.coordinator?.navigationController.popViewController(animated: true)
        }
        
        contactVM.newContact = {[weak self] newContact in
            self?.delegate?.shouldReload()
            self?.coordinator?.navigationController.popViewController(animated: true)
        }
        
        contactVM.updatedContact = {[weak self] updatedContact in
            self?.delegate?.shouldReload()
            self?.coordinator?.navigationController.popViewController(animated: true)
        }
    }
    
    private func callService(){
        if let contactID = contactID {
            contactVM.getContact(id: contactID)
            deleteButton.isHidden = false
        }else{
            deleteButton.isHidden = true
        }
    }
    
    private func loadContact(_ item: ContactModel){
        self.avatarView.loadView(AvatarModel(id: item.id , imageName: item.images?.first ?? ""))
        firstNameTF.text = item.firstName
        LastNameTF.text = item.lastName
        phoneTF.text = item.phone
        EmailTF.text = item.email
    }
    
    private func showMessage(title: String = "Error", message: String, buttonTitle: String = "Ok") {
        let ac = UIAlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
    
    private func createContactModel()->ContactModel{
        return ContactModel(id: contactID,
                            firstName: firstNameTF.text,
                            lastName: LastNameTF.text,
                            phone: phoneTF.text,
                            email: EmailTF.text,
                            images: [avatarView.getModel()?.imageName])
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func doneBtnPressed(){
        // shoud update contact
        let contact = createContactModel()
        if let contactID = contactID {
            contactVM.updateContact(id:contactID, contact: contact)
        }else{
            // should add new contact
            contactVM.addContact(newContact: contact)
        }
    }
    
    @objc private func deleteBtnPressed(){
        if let contactID = contactID {
            contactVM.deleteContact(id: contactID)
        }
    }
}


extension ContactVC: AvatarDelegate {
    func avatarPressed(model: AvatarModel?) {
        coordinator?.openGallery(vc: self)
    }
}


extension ContactVC: ImagePickerDelegate {
    func didReceiveImage(image: UIImage) {
        avatarView.clean()
        avatarView.animateActivityIndicator()
        image.toString { imageString in
            DispatchQueue.main.async {[weak self] in
                self?.avatarView.removeActivityIndicator()
                self?.avatarView.loadView(AvatarModel(id: nil, imageName: imageString))
            }
        }
    }
}
