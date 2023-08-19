//
//  ProductCollectManager.swift
//  ShoppingDemo
//
//  Created by Qi Zhu on 8/19/23.
//

import Foundation

private struct SubscribeItem {
    let key: String
    let action: (Product) -> Void
}

class ProductCollectManager {
    static let shared = ProductCollectManager()
    
    private(set) var list: [Product] = []
    
    private var idSet: Set<Int> = Set()
    
    private let lock = DispatchSemaphore(value: 1)
    
    private var subscribeList: [SubscribeItem] = []
    
    private var dataUrl: URL {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        url.appendPathComponent("FavoriteProducts.json")
        return url
    }
    
    func subscribe(_ action: @escaping (Product) -> Void) -> String {
        let item = SubscribeItem(key: UUID().uuidString, action: action)
        subscribeList.append(item)
        return item.key
    }
    
    func unsubscribe(_ key: String) {
        subscribeList = subscribeList.filter { $0.key != key}
    }
    
    func loadDataIfNeeded() {
        if !list.isEmpty
        {
            return
        }
        
        DispatchQueue.global().async {
            var newSet = Set<Int>()
            var newList = [Product]()
            let list = self.loadDataSync()
            
            for product in list {
                if newSet.contains(product.id) {
                    continue
                }
                newSet.insert(product.id)
                newList.append(product)
            }
            
            DispatchQueue.main.async {
                self.idSet = newSet
                self.list = newList
            }
            
        }
    }
    
    func checkCollect(_ product: Product) -> Bool {
        idSet.contains(product.id)
    }
    
    func collectProduct(_ product: Product) {
        if idSet.contains(product.id) {
            idSet.remove(product.id)
            if let index = list.firstIndex(where: {$0.id == product.id}) {
                list.remove(at: index)
            }
        }
        else
        {
            idSet.insert(product.id)
            list.append(product)
            //list.insert(product, at: 0)
        }
        
        let list = self.list
        DispatchQueue.global().async {
            self.saveDataSync(list)
        }
        
        for item in subscribeList {
            item.action(product)
        }
    }
    
    private func loadDataSync() -> [Product] {
        lock.wait()
        let data = try? Data(contentsOf: dataUrl)
        lock.signal()
        if let data2 = data,let list = try? JSONDecoder().decode([Product].self, from: data2) {
            return list
        }
        return []
    }
    
    private func saveDataSync(_ list: [Product]) {
        if let data = try? JSONEncoder().encode(list) {
            lock.wait()
            try? data.write(to: dataUrl)
            lock.signal()
        }
    }
    
    
}


