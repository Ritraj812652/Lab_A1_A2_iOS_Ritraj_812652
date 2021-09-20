//
//  ProductsViewCell.swift
//  Lab_A1_A2_iOS_Ritraj_812652
//
//  Created by Ritraj Singh on 19/09/21.
//

import UIKit

class ProductsViewCell: UITableViewCell{
    
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var productPrice: UITextField!
    @IBOutlet weak var productProvider: UITextField!
    
    func initCell(_ product: Product){
        productName.text = product.name
        productPrice.text = String(format: "$ %.2f", product.price)
        productProvider.text = product.provider?.name ?? ""
    }
}
