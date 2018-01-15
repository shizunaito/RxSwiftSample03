//
//  Repository.swift
//  RxSwiftSample03
//
//  Created by 伊藤静那(Ito Shizuna) on 2018/01/14.
//  Copyright © 2018年 ShizunaIto. All rights reserved.
//

import ObjectMapper

class Repository: Mappable {
    var identifier = 0
    var url = ""
    var name = ""

    required init?(map: Map) { }

    func mapping(map: Map) {
        identifier <- map["id"]
        url <- map["html_url"]
        name <- map["name"]
    }
}
