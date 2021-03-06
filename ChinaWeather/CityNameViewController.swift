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
    //var coordinator: [Float]?
    let specialCitites = ["北京","天津","上海","重庆","香港特别行政区","澳门特别行政区","台湾"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("cell number is \((province?.cities.count)!)")
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
        
        getCoordinator(provinceName: (province?.name)!, cityName: cityName!) {(lat, lon, error) in
            if error != nil {
                print("There is no lat and lon")
            }
            self.getWeatherInformation(lat: lat!, lon: lon!)
        }
        
        
    }
}

// Get coordinator of the city
extension cityNameViewController {
    
    func getCoordinator(provinceName: String, cityName: String, completionHandlerForCoordinator: @escaping (_ lat: Double?, _ lon: Double?, _ error: NSError?) -> Void){
        
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
                                        let coordinator = properties["cp"] as? [Double]
                                        //print("\(cityName), \(coordinator)")
    completionHandlerForCoordinator(coordinator?[1], coordinator?[0], nil)
    
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
                let coordinator = [117.0923,40.5121]
                completionHandlerForCoordinator(coordinator[1], coordinator[0], nil)
                //print("\(provinceName), \(coordinator)")
            case "天津":
                let coordinator = [117.4672,40.004]
                completionHandlerForCoordinator(coordinator[1], coordinator[0], nil)
                //print("\(provinceName), \(coordinator)")
            case "上海":
                let coordinator = [121.4333,31.1607]
                completionHandlerForCoordinator(coordinator[1], coordinator[0], nil)
                //print("\(provinceName), \(coordinator)")
            case "重庆":
                let coordinator = [108.8196,28.8666]
                completionHandlerForCoordinator(coordinator[1], coordinator[0], nil)
                print("\(provinceName), \(coordinator)")
            case "香港特别行政区":
                let coordinator = [114.1657, 22.2793]
                completionHandlerForCoordinator(coordinator[1], coordinator[0], nil)
                //print("\(provinceName), \(coordinator)")
            case "澳门特别行政区":
                let coordinator = [113.5586, 22.1630]
                completionHandlerForCoordinator(coordinator[1], coordinator[0], nil)
                //print("\(provinceName), \(coordinator)")
            case "台湾":
                let coordinator = [121.0193, 23.4366]
                completionHandlerForCoordinator(coordinator[1], coordinator[0], nil)
                //print("\(provinceName), \(coordinator)")
            default:
                return
            }
        }
        
    }

}

extension cityNameViewController {

    func getWeatherInformation(lat: Double, lon: Double){
        
        WeatherClient.sharedInstance.getWeatherData(lat: lat, lon: lon){ (weatherData, error) in
            
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
