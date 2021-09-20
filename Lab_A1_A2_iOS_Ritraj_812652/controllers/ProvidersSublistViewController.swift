//
//  ProvidersSublistViewController.swift
//  Lab_A1_A2_iOS_Ritraj_812652
//
//  Created by Ritraj Singh on 19/09/21.
//

import UIKit
import CoreData

class ProvidersSublistViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var productItemsList: [Product] = []
    
    var selectedProvider: Provider! {
        didSet{
            loadData()
        }
    }
    
    override func viewDidLoad() {
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    //MARK: - load from CoreData
    func loadData(){
        self.title = selectedProvider.name
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.predicate = NSPredicate(format: "provider.name ==  %@", selectedProvider.name ?? "")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            productItemsList = try context.fetch(request)
        } catch {
            print("Error loading product \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    // table view delegate for no of rows going to be in table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productItemsList.count
    }
    
    // table view delegate for returning table view cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProvidersProductViewCell", for: indexPath) as! ProductInProviderViewCell
        let product = productItemsList[indexPath.row]
        cell.initCell(product)
        return cell
        
    }
    
}
