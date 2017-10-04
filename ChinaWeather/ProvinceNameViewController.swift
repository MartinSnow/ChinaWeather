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
    
    var originalArray: [String] = []
    var searchingDataArray: [String] = []
    var search = false //This for search is on or not that identifier
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = NSDictionary(contentsOf: Bundle.main.url(forResource: "address", withExtension: "plist")!)
        chinaAddress = ChinaAddress(dictionary: data as! [String : AnyObject])
        
        for item in (chinaAddress?.address)! {
            let province = item["name"] as! String
            originalArray.append(province)
        }
        //self.hideKeyboard()
    }
    
    // UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if search == true {
            return searchingDataArray.count
        } else {
            return originalArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "provinceCell", for: indexPath)
        if search == true {
            cell.textLabel?.text = searchingDataArray[indexPath.row]
        } else {
            cell.textLabel?.text = originalArray[indexPath.row]
        }
        return cell
    }
    
    // UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellName = tableView.cellForRow(at: indexPath)?.textLabel?.text
        for item in (chinaAddress?.address)! {
            let itemName = item["name"] as! String
            if itemName == cellName {
                let province = Province(dictionary: item)
                let cityNameViewController = self.storyboard!.instantiateViewController(withIdentifier: "cityNameViewController") as! cityNameViewController
                cityNameViewController.province = province
                
                self.navigationController?.pushViewController(cityNameViewController, animated: true)
                break
            }
        }
    }
}

extension provinceNameViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchingDataArray = originalArray.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if searchingDataArray.count == 0 {
            search = false
        } else {
            search = true
        }
        self.tableView.reloadData()
    }

}

extension provinceNameViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(provinceNameViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
