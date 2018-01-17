//
//  VenueSearchViewController.swift
//  RxSwiftSample03
//
//  Created by 伊藤静那(Ito Shizuna) on 2018/01/15.
//  Copyright © 2018年 ShizunaIto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class VenueSearchViewController: UIViewController {

    @IBOutlet weak var venueSearchBar: UISearchBar!
    @IBOutlet weak var venueSearchTableView: UITableView!

    var venueViewModel = VenueViewModel()
    var venueDataSource = VenueDataSource()
    var venueDelegate = VenueDelegate()

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRx()
    }
    
    private func setupRx() {
        venueSearchTableView.delegate = venueDelegate
        
        let venueCellNib = UINib(nibName: "VenueCell", bundle: nil)
        venueSearchTableView.register(venueCellNib, forCellReuseIdentifier: "venueCell")
        
        venueSearchBar.rx.text.asDriver()
            .throttle(0.5)
            .drive(onNext: { query in
                self.venueViewModel.fetch(query: query!)
            })
            .disposed(by: disposeBag)
        
        venueViewModel.venues
            .asDriver()
            .drive {
                self.venueSearchTableView.rx.items(dataSource: self.venueDataSource)
            }
            .disposed(by: disposeBag)
        
        venueSearchTableView.rx.itemSelected
            .bind { [weak self] indexPath in
                if let venue = self?.venueViewModel.venues.value[indexPath.row] {
                    let urlString = "https://foursquare.com/v/" + venue.venueId
                    if let url = URL(string: urlString) {
                        let safariViewController = SFSafariViewController(url: url)
                        self?.present(safariViewController, animated: true, completion: nil)
                    }

                    //DEBUG
                    print("-----------")
                    print(venue.venueId)
                    print(venue.name)
                    print(venue.city ?? "")
                    print(venue.state ?? "")
                    print(venue.address ?? "")
                    print(venue.latitude ?? "")
                    print(venue.longitude ?? "")
                    print(venue.categoryIconURL ?? "")
                    print("-----------")
                    print("")
                }
        }
        .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
