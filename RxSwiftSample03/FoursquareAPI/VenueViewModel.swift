//
//  VenueViewModel.swift
//  RxSwiftSample03
//
//  Created by 伊藤静那(Ito Shizuna) on 2018/01/15.
//  Copyright © 2018年 ShizunaIto. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyJSON
import FoursquareAPIClient

class VenueViewModel {
    fileprivate(set) var venues = Variable<[Venue]>([])

    let client = VenueAPIClient()
    let disposeBag = DisposeBag()

    init() {}

    public func fetch(query: String = "") {
        client.search(query: query)
            .subscribe { [weak self] result in
                switch result {
                case .next(let value):
                    self?.venues.value = value
                case .error(let error):
                    print(error)
                case .completed:
                    ()
                }
            }
            .disposed(by: disposeBag)
    }
}
