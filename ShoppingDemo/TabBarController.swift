//
//  TabBarController.swift
//  ShoppingDemo
//
//  Created by Qi Zhu on 8/19/23.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //ProductCollectManager()
        let vc = ProductListVC()
        vc.title = "Home"
        vc.tabBarItem.image = UIImage(systemName: "house")
        vc.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        let nc = UINavigationController(rootViewController: vc)
        
        let vc2 = ProductCollectListVC()
        vc2.title = "Favorite"
        vc2.tabBarItem.image = UIImage(systemName: "heart")
        vc2.tabBarItem.selectedImage = UIImage(systemName: "heart.fill")
        
        let nc2 = UINavigationController(rootViewController: vc2)
        
        viewControllers = [nc,nc2]
        
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
