//
//  VenueDataSource.swift
//  RxSwiftSample03
//
//  Created by 伊藤静那(Ito Shizuna) on 2018/01/17.
//  Copyright © 2018年 ShizunaIto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage

class VenueDataSource: NSObject, RxTableViewDataSourceType, UITableViewDataSource {

    public typealias Element = [Venue]
    fileprivate var venues = [Venue]()

    public func tableView(_ tableView: UITableView, observedEvent: Event<[Venue]>) {
        switch observedEvent {
        case .next(let value):
            self.venues = value
            tableView.reloadData()
        case .error(let error):
            print(error)
        case .completed:
            ()
        }
    }

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.venues.count
    }

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VenueCell", for: indexPath) as! VenueCell

        cell.venueName.text = venues[indexPath.row].name
        cell.venueAddress.text = venues[indexPath.row].address
        cell.venueCity.text = venues[indexPath.row].city
        cell.venueState.text = venues[indexPath.row].state

        if let categoryIconURL = venues[indexPath.row].categoryIconURL {
            cell.venueIconImage.sd_setImage(with: categoryIconURL)
        }

        cell.venueDescription.text = venues[indexPath.row].description

        cell.accessoryType = .none
        cell.selectionStyle = .none

        return cell
    }
}
