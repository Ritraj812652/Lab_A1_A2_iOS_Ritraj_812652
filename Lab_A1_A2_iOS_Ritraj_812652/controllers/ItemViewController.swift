//
//  ItemViewController.swift
//  Lab_A1_A2_iOS_Ritraj_812652
//
//  Created by Ritraj Singh on 19/09/21.
//

import UIKit
import CoreData

class ItemViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    weak var delegate: MainViewController?
    
    
    
    var product: Product!
    
    var editingMode: Bool = false

    @IBOutlet weak var productId: UITextField!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var productProvider: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var buttonToSave: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        productId.text = String(format:"%d",product.id)
        productName.text = product.name
        productDescription.text = product.desc
        
        if editingMode {
            productPrice.text = String(format:"%.2f",product.price)
        } else {
            productPrice.text = String(format:"US %.2f",product.price)
        }
        
        
        productProvider.text = product.provider?.name ?? ""
        productDescription.layer.borderWidth = 1.2;
        productDescription.layer.cornerRadius = 6.0;
        
        
        if editingMode {
            editingEnabled()
        } else {
            editingDisabled()
        }
        
        if editingMode && product.name?.isEmpty != false {
            title = "New Product"
        }
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - TextField functions
    
    func editingEnabled(){
        
        productId.borderStyle = .roundedRect
        productName.borderStyle = .roundedRect
        productProvider.borderStyle = .roundedRect
        productPrice.borderStyle = .roundedRect
        productDescription.layer.borderColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0).cgColor
        
        
        productId.isEnabled = true
        productName.isEnabled = true
        productDescription.isEditable = true
        productProvider.isEnabled = true
        productPrice.isEnabled = true
        buttonToSave.isHidden = false
    }
    
    
    func editingDisabled(){
        
        productId.borderStyle = .none
        productName.borderStyle = .none
        productProvider.borderStyle = .none
        productPrice.borderStyle = .none
        productDescription.layer.borderColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.0).cgColor
        
        productId.isEnabled = false
        productName.isEnabled = false
        productDescription.isEditable = false
        productProvider.isEnabled = false
        productPrice.isEnabled = false
        buttonToSave.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if editingMode && product.name?.isEmpty != false {
            
            context.delete(product)
        }
    }
    
    //MARK: - Saving Data
    @IBAction func saveButtonPressed(_ sender: Any) {
        product.id = Int16(productId.text ?? "0") ?? 0
        product.name = productName.text
        product.price = Float(productPrice.text ?? "") ?? 0
        product.desc = productDescription.text
        product.provider = createRetrieveProvider(provider: productProvider.text ?? "")
        delegate?.updateItems()
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: -  Create/Retrive Provider
    func createRetrieveProvider(provider: String) -> Provider{
        let request: NSFetchRequest<Provider> = Provider.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", provider)
        do {
            let providerItemList = try context.fetch(request)
            
            if providerItemList.count > 0{
            
                return providerItemList[0]
            }
        } catch {
            
            print("Error loading provider \(error.localizedDescription)")
        }
        let createProvider = Provider(context: context)
        createProvider.name = provider
        return createProvider
    }
    
    
}
