//
//  SquareButton.swift
//  New GoldyQuotes
//
//  Created by Amir Mohamadi on 6/23/22.
//

import UIKit

class AvatarView: UIView {
    
    private lazy var imageView: UIImageView = {
        let imgv = UIImageView()
        imgv.translatesAutoresizingMaskIntoConstraints = false
        imgv.clipsToBounds = true
        imgv.image = UIImage(named: "contact")
        return imgv
    }()
    
    weak var delegate: AvatarDelegate?
    private var avatarModel: AvatarModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews(){
        addSubview(imageView)
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewPressed)))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.stdMainColor.cgColor
        layer.cornerRadius = self.Width / 2
        imageView.layer.cornerRadius = imageView.Width/2
        
        /// add shadow for superView
        setupMainShadow()
    }
    
    @objc func viewPressed(){
        delegate?.avatarPressed(model: avatarModel)
    }
    
    private func setupMainShadow(){
        layer.shadowColor = UIColor.stdBackground.cgColor
        let rect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: frame.width/2).cgPath
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 1.0
    }
    
    func clean(){
        imageView.image = nil
    }
    
    func loadView(_ item: AvatarModel?){
        self.avatarModel = item
        
        if let imageName = item?.imageName{
            imageName.toImage {[weak self] image in
                DispatchQueue.main.async {
                    if let image = image {
                        self?.imageView.image = image
                    }else{
                        self?.imageView.image = UIImage(named: "contact")
                    }
                }
            }
        }else{
            imageView.image = UIImage(named: "contact")
        }
        FadeAnimation()
    }
    
    func getModel()->AvatarModel?{
        return self.avatarModel
    }
}
