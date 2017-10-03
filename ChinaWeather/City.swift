//
//  City.swift
//  ChinaWeather
//
//  Created by Ma Ding on 17/10/3.
//  Copyright © 2017年 Ma Ding. All rights reserved.
//

import Foundation

struct City {
    
    var name: String
    var counties: [String]
    var zipcode: String
    
    init(dictionary: [String:AnyObject]) {
        name = dictionary["name"] as! String
        counties = [dictionary["sub"] as! String]
        zipcode = dictionary["zipcode"] as! String
    }
}
