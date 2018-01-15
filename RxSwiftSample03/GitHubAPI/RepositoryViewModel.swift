//
//  RepositoryViewModel.swift
//  RxSwiftSample03
//
//  Created by 伊藤静那(Ito Shizuna) on 2018/01/14.
//  Copyright © 2018年 ShizunaIto. All rights reserved.
//

import RxSwift
import RxCocoa
import RxAlamofire
import ObjectMapper

struct RepositoryViewModel {
    /**
        オブジェクトの初期化に合わせてプロパティの初期値を決定したいのでlazy varにする
        参考：http://hajihaji-lemon.com/smartphone/swift/lazy/
    **/
    lazy var rx_repositories: Driver<[Repository]> = self.fetchRepositories()

    fileprivate var repositoryName: Observable<String>

    init(withNameObservable nameObservable: Observable<String>) {
        self.repositoryName = nameObservable
    }

    fileprivate func fetchRepositories() -> Driver<[Repository]> {
        let baseUrl = "https://api.github.com/users/"

        return repositoryName
            // 1. Indicator を表示
            .subscribeOn(MainScheduler.instance)
            .do(onNext: { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            })
            // 2. APIへアクセス
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background)) // バックグラウンド実行
            .flatMapLatest { text in
                return RxAlamofire
                    .requestJSON(.get, baseUrl + text + "/repos")
                    .debug()
                    .catchError{ error in
                        return Observable.never()
                }
            }
            // 3. modelとmapperで定義したように整形
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { (response, json) -> [Repository] in
                if let repos = Mapper<Repository>().mapArray(JSONObject: json) {
                    return repos
                } else {
                    return []
                }
            }
            // 4. データが受け取れた時indicatorを非表示にし、Driverに変換
            .observeOn(MainScheduler.instance)
            .do(onNext: { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
            .asDriver(onErrorJustReturn: [])
    }
}
