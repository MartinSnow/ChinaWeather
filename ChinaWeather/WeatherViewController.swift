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
    @IBOutlet weak var cityName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityName.text = name
        getWeatherInformation(cityName: name!)
    }
    
    func getWeatherInformation(cityName:String){
    
        WeatherClient.sharedInstance.getWeatherData(cityName: cityName){ (weatherData, error) in
            print(weatherData)
            
        
        }
    }
}
