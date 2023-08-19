//
//  ProductListCell.swift
//  ShoppingDemo
//
//  Created by Qi Zhu on 8/12/23.
//

import UIKit

protocol ProductListCellDelegate: AnyObject {
    func productListCellDidClickCollect(_ cell:ProductListCell) 
}

class ProductListCell: UITableViewCell {
    
    weak var delegate: ProductListCellDelegate?
    
    private var coverView: UIImageView!
    private var nameLabel: UILabel!
    private var ratingView: RatingView!
    private var priceLabel: UILabel!
    private var collectButton: UIButton!
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let hStack = UIStackView()
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.spacing = 8
        contentView.addSubview(hStack)
        
        coverView = UIImageView()
        coverView.contentMode = .scaleAspectFit
        hStack.addArrangedSubview(coverView)
        
        NSLayoutConstraint.activate([
            hStack.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 15),
            hStack.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -15),
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            coverView.widthAnchor.constraint(equalToConstant: 100),
            coverView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 6
        hStack.addArrangedSubview(vStack)
        
        nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.font = .systemFont(ofSize: 20)
        nameLabel.textColor = .black        
        vStack.addArrangedSubview(nameLabel)
        
        ratingView = RatingView()
        vStack.addArrangedSubview(ratingView)
        
        NSLayoutConstraint.activate([
            ratingView.widthAnchor.constraint(equalToConstant: 100),
            ratingView.heightAnchor.constraint(equalToConstant: 20)])
        
        let priceHStack = UIStackView()
        vStack.addArrangedSubview(priceHStack)
        
        priceLabel = UILabel()
        priceLabel.font = .boldSystemFont(ofSize: 24)
        priceLabel.textColor = .systemOrange
        priceHStack.addArrangedSubview(priceLabel)
        
        collectButton = UIButton()
        collectButton.tintColor = .systemRed
        collectButton.setImage(UIImage(systemName: "heart"), for: .normal)
        collectButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        collectButton.addTarget(self, action: #selector(clickCollect), for: .touchUpInside)
        priceHStack.addArrangedSubview(collectButton)
        
        NSLayoutConstraint.activate([nameLabel.heightAnchor.constraint(equalToConstant: 80)])
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCover(_ cover: String) {
        //coverView.image = UIImage(systemName: "heart.fill")
        coverView.image = UIImage(named: cover)
        
    }
    
    func setName(_ name: String) {
        nameLabel.text = name
    }
    
    func setPrice(_ price: Double) {
        priceLabel.text = String(format: "$%.2f", price)
    }
    
    func setCollect(_ collect: Bool) {
        collectButton.isSelected = collect
    }
    
    func setRating(_ rating: Int) {
        ratingView.rating = rating
    }
    
    @objc private func clickCollect() {
        delegate?.productListCellDidClickCollect(self)
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
