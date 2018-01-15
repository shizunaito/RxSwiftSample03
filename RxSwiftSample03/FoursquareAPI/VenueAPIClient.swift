//
//  VenueAPIClient.swift
//  RxSwiftSample03
//
//  Created by 伊藤静那(Ito Shizuna) on 2018/01/15.
//  Copyright © 2018年 ShizunaIto. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON
import FoursquareAPIClient

class VenueAPIClient {
    let ShinOtsukaLi = "35.7260747,139.72983"

    func search(query: String = "") -> Observable<[Venue]> {
        return Observable.create{ observer in
            guard let foresquareClientid = ProcessInfo.processInfo.environment["foresquare_clientid"],
                let foresquareClientsecret = ProcessInfo.processInfo.environment["foresquare_clientsecret"] else {
                    return Disposables.create {}
            }
            let client = FoursquareAPIClient(clientId: foresquareClientid, clientSecret: foresquareClientsecret)

            let parameter: [String : String] = [
                "li" : self.ShinOtsukaLi,
                "query" : query
            ]

            client.request(path: "venues/search", parameter: parameter) { result in
                switch result {
                case let .success(data):
                    let json = try! JSON(data: data)
                    let venues = self.parse(json: json["response"]["venues"])

                    //パースしてきたjsonの値を通知対象にする
                    observer.on(.next(venues))
                    observer.on(.completed)

                case let .failure(error):
                    switch error {
                    case let .connectionError(connectionError):
                        print(connectionError)
                    case let .responseParseError(responseParseError):
                        print(responseParseError)
                    case let .apiError(apiError):
                        print(apiError.errorType)
                        print(apiError.errorDetail)
                    }
                }
            }
            //この取得処理を監視対象からはずすための処理
            return Disposables.create {}
        }
    }

    private func parse(json: JSON) -> [Venue] {
        var venues = [Venue]()
        for (key: _, jsonVenue: jsonVenue) in json {
            venues.append(Venue(json: jsonVenue))
        }
        return venues
    }
}
