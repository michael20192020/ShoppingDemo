//
//  ProductDetailView.swift
//  ShoppingDemo
//
//  Created by Qi Zhu on 8/16/23.
//

import UIKit
protocol ProductDetailViewDelegate: AnyObject {
    func productDetailViewDidClickCollect(_ detailView: ProductDetailView)
}

class ProductDetailView: UIView {
    weak var delegate: ProductDetailViewDelegate?
    private var cycleView: CycleView!
    private var vStack: UIStackView!
    private var nameLabel: UILabel!
    private var ratingView: RatingView!
    private var priceLabel: UILabel!
    private var collectButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cycleView = CycleView()
        addSubview(cycleView)
        NSLayoutConstraint.activate([
            cycleView.leftAnchor.constraint(equalTo: leftAnchor),
            cycleView.rightAnchor.constraint(equalTo: rightAnchor),
            cycleView.topAnchor.constraint(equalTo: topAnchor),
            cycleView.heightAnchor.constraint(equalTo: cycleView.widthAnchor)
        ])
        
        vStack = UIStackView()
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.alignment = .leading
        vStack.axis = .vertical
        vStack.spacing = 6
        addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            vStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            vStack.topAnchor.constraint(equalTo: cycleView.bottomAnchor, constant: 10)
        ])
        
        nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 20)
        nameLabel.textColor = .black
        nameLabel.numberOfLines = 0
        vStack.addArrangedSubview(nameLabel)
        
        ratingView = RatingView()
        vStack.addArrangedSubview(ratingView)
        
        let hStack = UIStackView()
        vStack.addArrangedSubview(hStack)
        priceLabel = UILabel()
        priceLabel.font = .boldSystemFont(ofSize: 24)
        priceLabel.textColor = .systemOrange
        hStack.addArrangedSubview(priceLabel)
        
        collectButton = UIButton()
        collectButton.tintColor = .systemRed
        collectButton.setImage(UIImage(systemName: "heart"), for: .normal)
        collectButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        collectButton.addTarget(self, action: #selector(clickCollect), for: .touchUpInside)
        hStack.addArrangedSubview(collectButton)
        collectButton.setContentHuggingPriority(.required, for: .horizontal)
        collectButton.rightAnchor.constraint(equalTo: vStack.rightAnchor, constant: -8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frame.size.height = vStack.frame.maxY + 10
    }

    func setImages(_ images: [String]) {
        cycleView.setImages(images)
    }
    
    func setName(_ name: String) {
        nameLabel.text = name
    }
    
    func setRating(_ rating: Int) {
        ratingView.rating = rating
    }
    
    func setPrice(_ price: Double) {
        priceLabel.text = String(format: "$%.2f", price)
    }
    
    func setCollect(_ collect: Bool) {
        collectButton.isSelected = collect
    }
    
    @objc private func clickCollect() {
        delegate?.productDetailViewDidClickCollect(self)
    }
}
