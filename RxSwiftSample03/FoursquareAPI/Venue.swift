//
//  Venue.swift
//  RxSwiftSample03
//
//  Created by 伊藤静那(Ito Shizuna) on 2018/01/15.
//  Copyright © 2018年 ShizunaIto. All rights reserved.
//

import UIKit
import SwiftyJSON

let categoryIconSize = 88

struct Venue: CustomStringConvertible {
    let venueId: String
    let name: String
    let address: String?
    let latitude: Double?
    let longitude: Double?
    let state: String?
    let city: String?
    let categoryIconURL: URL?

    let undefinedDescription = "Undefined"
    let undefinedDouble = 0.0
    let undefinedURL = URL(fileURLWithPath: "")

    var description: String {
        return "<venueId=\(venueId)"
            + ", name=\(name)"
            + ", address=\(address ?? undefinedDescription)"
            + ", latitude=\(latitude ?? undefinedDouble), longitude=\(longitude ?? undefinedDouble)"
            + ", state=\(state ?? undefinedDescription)"
            + ", city=\(city ?? undefinedDescription)"
            + ", categoryIconURL=\(categoryIconURL ?? undefinedURL)>"
    }

    init(json: JSON) {
        self.venueId = json["id"].string ?? ""
        self.name = json["name"].string ?? ""
        self.address = json["location"]["address"].string
        self.latitude = json["location"]["lat"].double
        self.longitude = json["location"]["lng"].double
        self.state = json["location"]["state"].string ?? ""
        self.city = json["location"]["city"].string ?? ""

        if let categories = json["categories"].array, categories.count > 0 {
            let iconPrefix = json["categories"][0]["icon"]["prefix"].string ?? ""
            let iconSuffix = json["categories"][0]["icon"]["suffix"].string ?? ""
            let iconUrlString = String(format: "%@%d%@", iconPrefix, categoryIconSize, iconSuffix)
            self.categoryIconURL = URL(string: iconUrlString)
        } else {
            self.categoryIconURL = nil
        }
    }
}
