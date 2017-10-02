//
//  ChinaAddressSearchViewController.swift
//  ChinaWeather
//
//  Created by Ma Ding on 17/10/2.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import Foundation
import UIKit

class chinaAddressSearchViewController: UITableViewController {
    
    // properties
    var data: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("1111")
        data = NSDictionary(contentsOf: Bundle.main.url(forResource: "address", withExtension: "plist")!)
        
    }
    
    // UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let addressArray:AnyObject = data?.object(forKey: "address") as! NSArray
        print("cell number is \(addressArray.count)")
        return addressArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
        let addressArray:AnyObject = data?.object(forKey: "address") as! NSArray
        let addressCell:AnyObject = addressArray[indexPath.row] as! NSDictionary
        cell.textLabel?.text = addressCell.object(forKey: "name") as? String
        return cell
        
    }

}
