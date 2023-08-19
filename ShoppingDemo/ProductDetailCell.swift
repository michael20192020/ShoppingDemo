//
//  ProductDetailCell.swift
//  ShoppingDemo
//
//  Created by Qi Zhu on 8/13/23.
//

import UIKit



class ProductDetailCell: UITableViewCell {
   
    
    private var avatarView: UIImageView!
    private var nameLabel: UILabel!
    private var ratingView: RatingView!
    private var contentLabel: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
        
        let hStack = UIStackView()
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.spacing = 8
        contentView.addSubview(hStack)
        
        avatarView = UIImageView()
        avatarView.contentMode = .scaleAspectFit
        hStack.addArrangedSubview(avatarView)
        
        NSLayoutConstraint.activate([
            hStack.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 15),
            hStack.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -15),
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            avatarView.widthAnchor.constraint(equalToConstant: 100),
            avatarView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 6
        hStack.addArrangedSubview(vStack)
        
        nameLabel = UILabel()
        nameLabel.font = .boldSystemFont(ofSize: 18)
        nameLabel.textColor = .black
        vStack.addArrangedSubview(nameLabel)

        ratingView = RatingView()
        vStack.addArrangedSubview(ratingView)
        
        contentLabel = UILabel()
        contentLabel.font = .systemFont(ofSize: 16)
        contentLabel.textColor = .black
        contentLabel.numberOfLines = 0
        vStack.addArrangedSubview(contentLabel)
        
    }
    
    func setAvatar(_ avatar: String) {
        avatarView.image = UIImage(systemName: avatar)
    }
    
    func setName(_ name: String) {
        nameLabel.text = name
    }
    
    func setRating(_ rating: Int) {
        ratingView.rating = rating
    }
    
    func setContent(_ content: String) {
        contentLabel.text = content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
