//
//  ProductsViewCell.swift
//  Lab_A1_A2_iOS_Ritraj_812652
//
//  Created by Ritraj Singh on 19/09/21.
//

import UIKit

class ProductsViewCell: UITableViewCell{
    
    @IBOutlet weak var txtProductName: UITextField!
    @IBOutlet weak var txtProductProvider: UITextField!
    
    func initCell(_ product: Product){
        
        txtProductName.text = product.name

        txtProductProvider.text = product.provider?.name ?? ""
    }
}
