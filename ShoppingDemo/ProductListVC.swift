//
//  ProductListVC.swift
//  ShoppingDemo
//
//  Created by Qi Zhu on 8/12/23.
//

import UIKit
import MJRefresh
import Alamofire
import PKHUD

class ProductListVC: UIViewController {

    private var tableView: UITableView!
    private var productList: [Product] = []
    private var subscribeKey: String = ""
    
    deinit {
        ProductCollectManager.shared.unsubscribe(subscribeKey)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       // fetchData()
         showData()
        
    }
    
    
    private func showData() {
        view.backgroundColor = .white
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ProductListCell.self, forCellReuseIdentifier: ProductListCell.description())
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        /*
        let header = MJRefreshNormalHeader { [weak self] in
            print("refresh")
            guard let self = self else { return }
            self.refreshData()
          //  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
           //     self.tableView.mj_header?.endRefreshing()
           // }
        }
        header.stateLabel?.isHidden = true
        header.lastUpdatedTimeLabel?.isHidden = true
         
        
        tableView.mj_header = header
         
         */
        
        setupRefreshHeader()
        tableView.mj_header?.beginRefreshing()
        subscribeKey = ProductCollectManager.shared.subscribe {
            [weak self] product in guard let self = self else {return}
            if let row = self.productList.firstIndex(where: {$0.id == product.id}) {
                self.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
            }
        }
    }

    func setupRefreshHeader() {
        let header = MJRefreshNormalHeader { [weak self] in
            guard let self = self else { return }
            self.refreshData()
        }
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = true
        self.tableView.mj_header = header
    }
    
    func fetchData() {
            Task.init {
                do {
                     try await downloadJsonFile()
                    print("finish")
                } catch {
                    // .. handle error
                }
                
                
            }
        
            
        }
    
    
    func refreshData() {
        NetworkAPI.homeProductList {
            [weak self] result in guard let self = self else {return}
            self.tableView.mj_header?.endRefreshing()
            self.tableView.mj_header?.alpha = 0
            
            switch result {
            case let .success(list):
                self.productList = list
                self.tableView.reloadData()
            case let .failure(error):
                HUD.flash(.label(error.localizedDescription), delay: 2)
            }
        }
    }
    
    
    private func downloadJsonFile() async throws -> String
    {
        var aaa = "aaa"
        let url = URL(string: "https://www.hansoft.com.au/iPhone.json")!
        AF.request(url).responseData(completionHandler: { response in
            print("Is main thread: \(Thread.isMainThread)")
            switch response.result {
            case let .success(data):
                print("Get data count:\(data.count)\n")
                if let list = try? JSONDecoder().decode([Product].self, from: data) {
                    print("Get data count:\(data.count)\n")
                    self.productList = list
                    print("name = ",list[0].name)
                    
                }
                else {
                    print("No list")
                }
                
            case let .failure(error):
                print(error.localizedDescription)
                
            }
            
             print("vvv")
              aaa = "vvv"
            
            self.showData()
              
        })
        
        print("aaa = ",aaa)
        return aaa
        
    }
            
    

}

extension ProductListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductListCell.description(), for: indexPath) as! ProductListCell
        print("aaa")
        cell.delegate = self
        let cover = productList[indexPath.item].cover
        cell.setCover(cover)
        let name = productList[indexPath.item].name
        cell.setName(name)
        let price = productList[indexPath.item].price
        cell.setPrice(price)
        let isCollect = ProductCollectManager.shared.checkCollect(productList[indexPath.item])
        cell.setCollect(isCollect)
        let rating = productList[indexPath.item].rating
        cell.setRating(rating)
        //cell.textLabel?.text = indexPath.description
        return cell
    }
    
}

extension ProductListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        let product = productList[indexPath.row]
        let productDetailVC = ProductDetailVC(product: product)
            self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

extension ProductListVC: ProductListCellDelegate {
    func productListCellDidClickCollect(_ cell: ProductListCell) {
        print(#function)
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let product = productList[indexPath.row]
        ProductCollectManager.shared.collectProduct(product)
        
    }
}
