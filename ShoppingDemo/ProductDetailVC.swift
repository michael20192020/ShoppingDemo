//
//  ProductDetailVC.swift
//  ShoppingDemo
//
//  Created by Qi Zhu on 8/13/23.
//

import UIKit

class ProductDetailVC: UIViewController {
    
    
    
    private let product: Product
    private var tableView: UITableView!
    private var detailView: ProductDetailView!
    private var nameArray: [String] = ["Tom","Jack","Michael","Steven","Sean","Marry","Jane","Mike","Jenny","wendy","Cathy","Smith"]
    
    private var ratingArray: [Int] = [3,4,5,5,3,2,3,4,5,5,4,3]
    private var contentArray: [String] = ["Good","very good","Well","I like it","Ok","Fantastic","Very well","Ok","Good","Good","Ok","Well"]
    
    private var subscribeKey: String = ""
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
       // tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), style: .grouped)
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(ProductDetailCell.self, forCellReuseIdentifier: ProductDetailCell.description())
        
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        detailView = ProductDetailView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 0))
        detailView.delegate = self
        detailView.setImages(product.images)
        detailView.setName(product.name)
        detailView.setRating(product.rating)
        detailView.setPrice(product.price)
        let isCollect = ProductCollectManager.shared.checkCollect(product)
        detailView.setCollect(isCollect)
        detailView.layoutIfNeeded()
        tableView.tableHeaderView = detailView
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        subscribeKey = ProductCollectManager.shared.subscribe {
            [weak self] product in guard let self = self else {return}
            
            self.detailView.layoutIfNeeded()
            
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ProductDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductDetailCell.description(), for: indexPath) as! ProductDetailCell
       // cell.delegate = self
        cell.setAvatar("person.circle.fill")
        cell.setName(nameArray[indexPath.item])
        cell.setRating(ratingArray[indexPath.item])
        cell.setContent(contentArray[indexPath.item])
        //cell.textLabel?.text = indexPath.description
        return cell
    }
    
    
    
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
    
        
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 300))
        headerView.backgroundColor = .systemGray6
        
        /*
        let coverView = UIImageView()
        coverView.contentMode = .scaleAspectFit
        coverView.image = UIImage(named: product.cover)
        vStack.addArrangedSubview(coverView)
         */
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.spacing = 8
        
        headerView.addSubview(vStack)
        
        let cycleView = CycleView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        cycleView.setImages(product.images)
        vStack.addArrangedSubview(cycleView)
        
        
        
        
        let nameLabel = UILabel()
        nameLabel.text = product.name
        nameLabel.numberOfLines = 0
        nameLabel.textColor = .black
        vStack.addArrangedSubview(nameLabel)
        
        let ratingView = RatingView()
        ratingView.rating = product.rating
        vStack.addArrangedSubview(ratingView)
        
        NSLayoutConstraint.activate([
            ratingView.widthAnchor.constraint(equalToConstant: 100),
            ratingView.heightAnchor.constraint(equalToConstant: 20)])
        
           // coverView.widthAnchor.constraint(equalToConstant: 100),
           // coverView.heightAnchor.constraint(equalToConstant: 150)])
        
        
        
        let priceHStack = UIStackView()
        vStack.addArrangedSubview(priceHStack)
        
        let priceLabel = UILabel()
        priceLabel.font = .boldSystemFont(ofSize: 24)
        priceLabel.textColor = .systemOrange
        priceLabel.text =  String(format: "$%.2f", product.price)
        priceHStack.addArrangedSubview(priceLabel)
        
        let collectButton = UIButton()
        collectButton.tintColor = .systemRed
        collectButton.setImage(UIImage(systemName: "heart"), for: .normal)
        collectButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        collectButton.addTarget(self, action: #selector(clickCollect), for: .touchUpInside)
        priceHStack.addArrangedSubview(collectButton)
        
        
        
        NSLayoutConstraint.activate([nameLabel.heightAnchor.constraint(equalToConstant: 50)])
        
         
        NSLayoutConstraint.activate([
            vStack.leftAnchor.constraint(equalTo: headerView.leftAnchor,constant: 15),
            vStack.rightAnchor.constraint(equalTo: headerView.rightAnchor,constant: -15),
            vStack.topAnchor.constraint(equalTo: headerView.topAnchor,constant: 5),
            vStack.bottomAnchor.constraint(equalTo: headerView.bottomAnchor,constant: -5)
            
            
        ])
        
        
        return headerView
    }
     */
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    @objc private func clickCollect() {
       // delegate?.ProductDetailCellDidClickCollect(self)
    }
    
}

extension ProductDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
}

extension ProductDetailVC: ProductDetailViewDelegate {
    
    func productDetailViewDidClickCollect(_ detailView: ProductDetailView) {
        print(#function)
        ProductCollectManager.shared.collectProduct(product)
        let isCollect = ProductCollectManager.shared.checkCollect(product)
        detailView.setCollect(isCollect)
        detailView.layoutIfNeeded()
    }
    
    
}


