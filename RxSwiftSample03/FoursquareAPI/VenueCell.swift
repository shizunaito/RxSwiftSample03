//
//  VenueCell.swift
//  RxSwiftSample03
//
//  Created by 伊藤静那(Ito Shizuna) on 2018/01/17.
//  Copyright © 2018年 ShizunaIto. All rights reserved.
//

import UIKit

class VenueCell: UITableViewCell {

    @IBOutlet weak var venueName: UILabel!
    @IBOutlet weak var venueAddress: UILabel!
    @IBOutlet weak var venueState: UILabel!
    @IBOutlet weak var venueCity: UILabel!
    @IBOutlet weak var venueIconImage: UIImageView!
    @IBOutlet weak var venueDescription: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
