//
//  VenueDelegate.swift
//  RxSwiftSample03
//
//  Created by 伊藤静那(Ito Shizuna) on 2018/01/17.
//  Copyright © 2018年 ShizunaIto. All rights reserved.
//

import UIKit

class VenueDelegate: NSObject, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
}
