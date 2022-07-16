//
//  ContactTVCell.swift
//  STDevTest
//
//  Created by Amir Mohamadi on 7/15/22.
//

import UIKit

class ContactTVCell: UITableViewCell {
    
    private lazy var avatarView: AvatarView = {
       let imgv = AvatarView()
        imgv.translatesAutoresizingMaskIntoConstraints = false
        return imgv
    }()
    
    private lazy var nameLbl: UILabel = {
       let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .stdTextColor
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 15)
        return lbl
    }()
    
    private lazy var phoneLbl: UILabel = {
       let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .stdTextColor.withAlphaComponent(0.7)
        lbl.textAlignment = .left
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 13)
        return lbl
    }()
    
    private lazy var labelStack: UIStackView = {
       let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    private lazy var selectedView: UIView = {
       let v = UIView()
        v.backgroundColor = .stdMainColor
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.clean()
        nameLbl.text = nil
        phoneLbl.text = nil
    }
    
    private func setupViews(){
        labelStack.addArrangedSubview(nameLbl)
        labelStack.addArrangedSubview(phoneLbl)
        contentView.addSubview(labelStack)
        contentView.addSubview(avatarView)
        
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 60),
            avatarView.heightAnchor.constraint(equalToConstant: 60),
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            avatarView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            labelStack.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 10),
            labelStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            labelStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func load(_ item: ContactModel){
        nameLbl.text = "\(item.firstName ?? "") \(item.lastName ?? "")"
        phoneLbl.text = item.phone
        
        avatarView.loadView(AvatarModel(id: item.id, imageName: item.images?.first ?? ""))
    }
}

// MARK: - GQCollectionViewCell
extension ContactTVCell: STDTableViewCell {
    func configureCellWith(_ item: ContactModel) {
        load(item)
    }
}
