//
//  ViewController.swift
//  RxSwiftSample03
//
//  Created by 伊藤静那(Ito Shizuna) on 2018/01/14.
//  Copyright © 2018年 ShizunaIto. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper
import RxAlamofire

class ViewController: UIViewController {
    @IBOutlet weak var nameSearchBar: UISearchBar!
    @IBOutlet weak var repositoryListTableView: UITableView!

    let disposeBag = DisposeBag()

    var repositoryViewModel: RepositoryViewModel!

    var rx_serchBarText: Observable<String> {
        return nameSearchBar.rx.text
            .filter { $0 != nil }
            .map { $0! }
            .filter { $0.count > 0 }
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRx()
    }

    func setupRx() {
        repositoryViewModel = RepositoryViewModel(withNameObservable: rx_serchBarText)

        // tableViewへのデータ渡し
        repositoryViewModel
            .rx_repositories
            .drive(repositoryListTableView.rx.items) { (tableView, i, repository) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: IndexPath(row: i, section: 0))
                cell.textLabel?.text = repository.name
                cell.detailTextLabel?.text = repository.url

                return cell
            }
            .disposed(by: disposeBag)

        // データ取得件数0の時のエラー処理
        repositoryViewModel
            .rx_repositories
            .drive(onNext: { repositories in
                if repositories.count == 0 {
                    let alert = UIAlertController(title: ":(", message: "No results.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                    if self.navigationController?.visibleViewController is UIAlertController != true {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

