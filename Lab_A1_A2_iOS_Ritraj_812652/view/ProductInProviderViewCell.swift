//
//  ProductInProviderViewCell.swift
//  Lab_A1_A2_iOS_Ritraj_812652
//
//  Created by Ritraj Singh on 19/09/21.
//
import UIKit

class ProductInProviderViewCell: UITableViewCell {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    
    func initCell(_ product: Product){
        txtName.text = product.name
        txtPrice.text = String(format: "US$ %.2f", product.price)
    }
}
