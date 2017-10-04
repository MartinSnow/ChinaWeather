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
    let specialCitites = ["北京","天津","上海","重庆","香港特别行政区","澳门特别行政区","台湾"]
    
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
        
        if !specialCitites.contains(provinceName) {
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
        } else {
            switch provinceName {
            case "北京":
                self.coordinator = [117.0923,40.5121]
                print("\(provinceName), \(self.coordinator)")
            case "天津":
                self.coordinator = [117.4672,40.004]
                print("\(provinceName), \(self.coordinator)")
            case "上海":
                self.coordinator = [121.4333,31.1607]
                print("\(provinceName), \(self.coordinator)")
            case "重庆":
                self.coordinator = [108.8196,28.8666]
                print("\(provinceName), \(self.coordinator)")
            case "香港特别行政区":
                self.coordinator = [114.1657, 22.2793]
                print("\(provinceName), \(self.coordinator)")
            case "澳门特别行政区":
                self.coordinator = [113.5586, 22.1630]
                print("\(provinceName), \(self.coordinator)")
            case "台湾":
                self.coordinator = [121.0193, 23.4366]
                print("\(provinceName), \(self.coordinator)")
            default:
                return
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
