//
//  StoreViewController.swift
//  ancientStore
//
//  Created by 黃士軒 on 2019/11/25.
//  Copyright © 2019 Lacie. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController {
    
    let items = AllItemsClass.shared
    let tokens = SavedToken.shared
    var itemData = ItemData.Food
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getAllItems()
    }
    
    @IBAction func showFoodData(_ sender: UIButton) {
        itemData = .Food
        tableView.reloadData()
    }
    @IBAction func showWeaponData(_ sender: UIButton) {
        itemData = .Weapon
        tableView.reloadData()
    }
    @IBAction func showSpecialData(_ sender: UIButton) {
        itemData = .Special
        tableView.reloadData()
    }
    
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let addVC = storyboard?.instantiateViewController(withIdentifier: "addVC") as! AddItemViewController
        addVC.mode = .Add
    }
}

extension StoreViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows: Int
        
        switch itemData {
        case .Food:
            numberOfRows = items.sort1.count
        case .Weapon:
            numberOfRows = items.sort2.count
        case .Special:
            numberOfRows = items.sort3.count
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath) as! ItemTableViewCell
        
        switch itemData {
        case .Food:
            cell.itemNameLabel.text = "名稱：\(items.sort1[indexPath.item].item_name)"
            cell.itemPriceLabel.text = "售價：\(items.sort1[indexPath.item].price)"
        case .Weapon:
            cell.itemNameLabel.text = "名稱：\(items.sort2[indexPath.item].item_name)"
            cell.itemPriceLabel.text = "售價：\(items.sort2[indexPath.item].price)"
        case .Special:
            cell.itemNameLabel.text = "名稱：\(items.sort3[indexPath.item].item_name)"
            cell.itemPriceLabel.text = "售價：\(items.sort3[indexPath.item].price)"
        }
        
        cell.itemImageView.image = UIImage(named: "background1")
        return cell
    }
}

extension StoreViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let editVC = storyboard?.instantiateViewController(withIdentifier: "addVC") as! AddItemViewController
        editVC.mode = .Edit
        navigationController?.pushViewController(editVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除", handler: { (action, view, success) in
                    
            switch self.itemData {
            case .Food:
                let url = URL(string: "http://5c390001.ngrok.io/api/wolf/items/\(self.items.sort1[indexPath.item].id)")!
                var request = URLRequest(url: url)
                request.httpMethod = "DELETE"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.setValue("Bearer \(self.tokens.savedToken!.api_token!)", forHTTPHeaderField: "Authorization")
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print ("error: \(error)")
                        return
                    }
                    if let response = response as? HTTPURLResponse {
                        print("status code: \(response.statusCode)")
                    }
                }
                task.resume()
            case .Weapon:
                let url = URL(string: "http://5c390001.ngrok.io/api/wolf/items/\(self.items.sort2[indexPath.item].id)")!
                var request = URLRequest(url: url)
                request.httpMethod = "DELETE"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.setValue("Bearer \(self.tokens.savedToken!.api_token!)", forHTTPHeaderField: "Authorization")
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print ("error: \(error)")
                        return
                    }
                    if let response = response as? HTTPURLResponse {
                        print("status code: \(response.statusCode)")
                    }
                }
                task.resume()
            case .Special:
                let url = URL(string: "http://5c390001.ngrok.io/api/wolf/items/\(self.items.sort3[indexPath.item].id)")!
                var request = URLRequest(url: url)
                request.httpMethod = "DELETE"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.setValue("Bearer \(self.tokens.savedToken!.api_token!)", forHTTPHeaderField: "Authorization")
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print ("error: \(error)")
                        return
                    }
                    if let response = response as? HTTPURLResponse {
                        print("status code: \(response.statusCode)")
                    }
                }
                task.resume()
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        })
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension StoreViewController {
    
    func getAllItems() {
        
        if let url = URL(string: "http://5c390001.ngrok.io/api/items") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                }
                
                if let response = response as? HTTPURLResponse {
                    print("status code: \(response.statusCode)")
                }
                
                guard let data = data else { return }
                do {
                    let tryCatchData = try JSONDecoder().decode(AllItemsStruct.self, from: data)
                        self.items.allItems = tryCatchData.items
                    
                    DispatchQueue.main.async {
                        self.activityIndicatorView.removeFromSuperview()
                    }
                } catch {
                    print(error.localizedDescription)
                    let string = String(data: data, encoding: .utf8)
                    print(string!)
                }
            }.resume()
        }
    }
}
