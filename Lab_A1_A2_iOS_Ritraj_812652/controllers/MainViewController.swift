//
//  MainViewController.swift
//  Lab_A1_A2_iOS_Ritraj_812652
//
//  Created by Ritraj Singh on 19/09/21.
//

import UIKit
import CoreData


class MainViewController: UITableViewController {
    
    @IBOutlet weak var productSearching: UISearchBar!
    
    var productItems: [Product] = []
    var providerItems: [Provider] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    var isItProvider = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        if productItems.count == 0 {
            firstLoad()
        }
        productSearching.delegate = self
        
        navigationItem.rightBarButtonItem = editButtonItem
        title = "Products"
        
        //MARK: - refresh screen functionality
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadData(_:)), for: .valueChanged)
       
    }
    
    //MARK: - Products/Providers IBAction
    @IBAction func itemsToggle(_ sender: UIBarButtonItem) {
        isItProvider = !isItProvider
        if isItProvider {
            sender.title = "Show Products"
        
            title = "Providers"
        } else {
            sender.title = "Show Providers"
            title = "Products"
        }
        setEditing(false, animated: true)
        loadData()
    }
    
    
    
    // MARK: -   Loading Data Method
    @objc func loadData(_ sender: Any? = nil){
        if isItProvider {
            providerInfo()
            
        } else {
            productInfo()
            
        }
        // refresh the view
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    // Filter FetchRequest Methods for search
    func fetchFilterData(searchText: String){
        if isItProvider {
            providerItemsFetch(searchText: searchText)
            
        } else {
            productItemsFetch(searchText: searchText)
            
        }
        tableView.reloadData()
    }
    
    // Update the products
    func updateItems(){
        do {
            try context.save()
            loadData()
        } catch {
            print("Error loading prodcuts \(error.localizedDescription)")
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing{
        let alert = UIAlertController(title: "Editing mode", message: " You can Edit/Delete the Items by clicking on them", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
        
        self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    //MARK: - Delegate Methods for tableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isItProvider{
            if tableView.isEditing {
                editProviderInfoAlert(provider: providerItems[indexPath.row])
                
            } else {
                performSegue(withIdentifier: "productsInProvider", sender: self)
            }
        } else {
            if tableView.isEditing {
                performSegue(withIdentifier: "modifyProductInfo", sender: self)
                
            } else {
                performSegue(withIdentifier: "productDetailedInfo", sender: self)
            }
        }
    }
    
    // editSTyle change
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isItProvider {
                removeProvider(providerItems[indexPath.row])
            } else {
                deleteProduct(productItems[indexPath.row])
            }
        }
    }
    
    
    // MARK: - Navigation segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productsInProvider" {
            let destination = segue.destination as! ProvidersSublistViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destination.selectedProvider = providerItems[indexPath.row]
            }
        } else {
            let destination = segue.destination as! ItemViewController
            destination.delegate = self
            if segue.identifier == "productDetailedInfo" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    destination.product = productItems[indexPath.row]
                    destination.isEdit = false
                }
            } else if segue.identifier == "modifyProductInfo" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    destination.product = productItems[indexPath.row]
                    destination.isEdit = true
                }
            } else if segue.identifier == "addProductInfo" {
                destination.product = Product(context: context)
                destination.isEdit = true
            }
        }
    }
    
    //MARK: - DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isItProvider{
            return providerItems.count
        } else {
            return productItems.count
        }
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isItProvider {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsViewCell", for: indexPath) as! ProductsViewCell
            let product = productItems[indexPath.row]
            cell.initCell(product)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProvidersViewCell", for: indexPath) as! ProvidersViewCell
            let provider = providerItems[indexPath.row]
            cell.initCell(provider)
            return cell
        }
    }
    
    // MARK: - First Load Data
    func firstLoad(){
        
        removeProvider()
        
        productItems.forEach { product in
            context.delete(product)
        }
        productItems.removeAll()
        
        let provider1 = Provider(context: context)
        provider1.name = "Apple"
        
        let provider2 = Provider(context: context)
        provider2.name = "Samsung"
        
        let provider3 = Provider(context: context)
        provider3.name = "OnePlus"
        
        var product = Product(context: context)
        product.id = 1
        product.name = "Iphone 13 Pro"
        product.desc = "This is the all new Iphone 13, where magic happens! Oh.So.Pro!"
        product.price = 999.0
        product.provider = provider1
        productItems.append(product)
        
        
        product = Product(context: context)
        product.id = 2
        product.name = "Iphone 12"
        product.desc = "Iphone 12 - Blast past fast"
        product.price = 699.0
        product.provider = provider1
        productItems.append(product)
        
        
        product = Product(context: context)
        product.id = 3
        product.name = "Iphone 11"
        product.desc = "Just the right amount of everything"
        product.price = 599.0
        product.provider = provider1
        productItems.append(product)
        
        
        product = Product(context: context)
        product.id = 4
        product.name = "Iphone X"
        product.desc = "Say Hello to the future"
        product.price = 499.0
        product.provider = provider1
        productItems.append(product)
        
        
        product = Product(context: context)
        product.id = 5
        product.name = "Samsung Galaxy S21"
        product.desc = "Everyday Epic"
        product.price = 799.99
        product.provider = provider2
        productItems.append(product)
        
        
        product = Product(context: context)
        product.id = 6
        product.name = "iPad"
        product.desc = "Easy does it all"
        product.price = 329.0
        product.provider = provider1
        productItems.append(product)
        
        
        product = Product(context: context)
        product.id = 7
        product.name = "Galaxy Buds 2"
        product.desc = "Bluetooth Wireless Earbuds"
        product.price = 109.9
        product.provider = provider2
        productItems.append(product)
        
        
        product = Product(context: context)
        product.id = 8
        product.name = "OnePlus 9"
        product.desc = "Never Settle"
        product.price = 699.0
        product.provider = provider3
        productItems.append(product)
        
        
        product = Product(context: context)
        product.id = 9
        product.name = "Airpods Pro"
        product.desc = "Magic like you've never heard"
        product.price = 249.0
        product.provider = provider1
        productItems.append(product)
        
        
        product = Product(context: context)
        product.id = 10
        product.name = "Galaxy Z Fold3 5G"
        product.desc = "is 'good' good enough"
        product.price = 31.15
        product.provider = provider2
        productItems.append(product)
        
        do {
            try context.save()
            
            tableView.reloadData()
        } catch {
            print("Error saving products \(error.localizedDescription)")
        }
    }
    
    // delete the providers
    func removeProvider(){
        print("no of providers :")
        let request: NSFetchRequest<Provider> = Provider.fetchRequest()
        
        do {
            let providerList = try context.fetch(request)
            providerList.forEach { (provider) in
                context.delete(provider)
            }
        } catch {
            print("Error loading providers \(error.localizedDescription)")
        }
    }
}

//MARK: -  Product methods
extension MainViewController {
    //MARK: - load using CoreData
    func productInfo(){
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            productItems = try context.fetch(request)
        } catch {
            print("Error loading products \(error.localizedDescription)")
        }
    }
    
    //MARK: - Delete from Coredata
    func deleteProduct(_ product: Product){
        context.delete(product)
        updateItems()
    }
    
    //MARK: - Fetch Filtered data from CoreData
    func productItemsFetch(searchText: String){
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        let titlePredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        let descriptionPredicate = NSPredicate(format: "desc CONTAINS[cd] %@", searchText)
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, descriptionPredicate])
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        do {
            self.productItems = try self.context.fetch(request)
        } catch {
            print("Error loading prodcuts \(error.localizedDescription)")
        }
    }
}

//MARK: - Provider methods
extension MainViewController {
    //MARK: - providers load using CoreData
    func providerInfo(){
        let request: NSFetchRequest<Provider> = Provider.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            providerItems = try context.fetch(request)
        } catch {
            print("Error loading provider \(error.localizedDescription)")
        }
    }
    
    //MARK: - Provider remove data
    func removeProvider(_ provider: Provider){
        let name = provider.name ?? "Provider"
        let alert = UIAlertController(title: "Delete \(name)", message: "Warning!, If you delete the provider then all its associated products will be deleted. Are you sure you want to proceed with deletion?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            self.context.delete(provider)
            self.updateItems()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in }))
        
        self.present(alert, animated: true, completion: nil)
    }
    

    func editProviderInfoAlert(provider: Provider) {
        let alert = UIAlertController(title: "Edit Provider Name", message: "Enter the name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = provider.name
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            provider.name = textField?.text ?? ""
            self.updateItems()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - load filtered providers from CoreData
    func providerItemsFetch(searchText: String){
        let request: NSFetchRequest<Provider> = Provider.fetchRequest()
        let titlePredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        request.predicate = titlePredicate
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            providerItems = try context.fetch(request)
        } catch {
            print("Error loading provider \(error.localizedDescription)")
        }
    }
}
extension MainViewController: UISearchBarDelegate {
    
    //MARK: - searchbar on click event
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchFilterData(searchText: searchBar.text!)
    }
    
    // detect searchText changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
