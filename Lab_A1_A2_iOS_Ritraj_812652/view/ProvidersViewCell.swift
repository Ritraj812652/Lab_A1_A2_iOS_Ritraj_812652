//
//  ProvidersViewCell.swift
//  Lab_A1_A2_iOS_Ritraj_812652
//
//  Created by Ritraj Singh on 19/09/21.
//

import UIKit

class ProvidersViewCell: UITableViewCell{
    
    @IBOutlet weak var providerName: UITextField!
    @IBOutlet weak var productCount: UITextField!
   
   func initCell(_ provider: Provider){
       providerName.text = provider.name
    productCount.text = String(format: "%d", provider.products?.count ?? 0)
   }
}

