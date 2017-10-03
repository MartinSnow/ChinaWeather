//
//  WeatherViewController.swift
//  ChinaWeather
//
//  Created by Ma Ding on 17/10/3.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import Foundation
import UIKit

class weatherViewController: UIViewController {
    
    // Properties
    var name: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = name
        
        getWeatherInformation(cityName: name!)
    }
    
    func getWeatherInformation(cityName:String){
    
        WeatherClient.sharedInstance.getWeatherData(cityName: cityName){ (weatherData, error) in
            
            if error != nil {
                print("There is an error")
                return
            }
            
            if let list = weatherData!["list"] as? [[String: AnyObject]] {
                for item in list {
                }
            
            }
            
        
        }
    }
}
