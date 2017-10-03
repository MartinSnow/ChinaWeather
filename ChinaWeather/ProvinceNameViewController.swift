//
//  ProvinceNameViewController.swift
//  ChinaWeather
//
//  Created by Ma Ding on 17/10/2.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import Foundation
import UIKit

class provinceNameViewController: UITableViewController {
    
    // properties
    var data: NSDictionary?
    var chinaAddress: ChinaAddress?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = NSDictionary(contentsOf: Bundle.main.url(forResource: "address", withExtension: "plist")!)
        chinaAddress = ChinaAddress(dictionary: data as! [String : AnyObject])
    }
    
    // UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("cell number is \((chinaAddress?.address.count)!)")
        return (chinaAddress?.address.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "provinceCell", for: indexPath)
        let addressCell = chinaAddress?.address[indexPath.row]
        cell.textLabel?.text = addressCell?["name"] as? String
        return cell
        
    }
    
    // UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let province = Province(dictionary: (chinaAddress?.address[indexPath.row])!)
        let cityNameViewController = self.storyboard!.instantiateViewController(withIdentifier: "cityNameViewController") as! cityNameViewController
        cityNameViewController.province = province
        
        self.navigationController?.pushViewController(cityNameViewController, animated: true)
        
    }

}
