//
//  CityNameViewController.swift
//  ChinaWeather
//
//  Created by Ma Ding on 17/10/3.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import Foundation
import UIKit

class cityNameViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var province: Province?
    var weatherList: [[String:AnyObject]]?
    var cityName: String?
    var coordinator: [Float]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("cell number is \((province?.cities.count)!)")
        return (province?.cities.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let cityCell = province?.cities[indexPath.row]
        cell.textLabel?.text = cityCell?["name"] as? String
        return cell
    }
    
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.cityName = cell?.textLabel?.text
        
        getCoordinator(provinceName: (province?.name)!, cityName: cityName!)
        //getWeatherInformation(cityName: name!)
        
    }
}

// Get coordinator of the city
extension cityNameViewController {
    
    func getCoordinator(provinceName: String, cityName: String){
        
        //if provinceName != "北京"
        let path = Bundle.main.path(forResource: provinceName, ofType: "json")
        let pathURL = URL(fileURLWithPath: path!)
        let data = NSData(contentsOf: pathURL)
        
        WeatherClient.sharedInstance.convertDataWithCompletionHandler(data as! Data){(parsedResult, error) in
        
            if error != nil {
                print("Fail to get parsedResult")
                return
            }
            
            DispatchQueue.main.async{
                if let features = parsedResult?["features"] as? [[String: AnyObject]] {
                    for feature in features {
                        if let properties = feature["properties"] as? [String: AnyObject] {
                            if let name = properties["name"] as? String {
                                if name == cityName {
                                    self.coordinator = properties["cp"] as? [Float]
                                    print("\(cityName), \(self.coordinator)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}

extension cityNameViewController {

    func getWeatherInformation(cityName:String){
        
        WeatherClient.sharedInstance.getWeatherData(cityName: cityName){ (weatherData, error) in
            
            if error != nil {
                print("There is an error")
                return
            }
            DispatchQueue.main.async{
            
                if let list = weatherData!["list"] as? [[String: AnyObject]] {
                    self.weatherList = list
                }
                
                let weatherViewController = self.storyboard?.instantiateViewController(withIdentifier: "weatherViewController") as! weatherViewController
                weatherViewController.cityName = self.cityName
                weatherViewController.weatherList = self.weatherList
                self.navigationController?.pushViewController(weatherViewController, animated: true)
            }
            
        }
    }
}
