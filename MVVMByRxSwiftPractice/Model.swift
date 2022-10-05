//
//  Model.swift
//  MVVMByRxSwiftPractice
//
//  Created by Saga on 2022/10/02.
//

import RxSwift

// エラーの種類を定義した列挙型
enum ModelError: Error {
    // IDが無効な場合
    case invalidId
    // パスワードが無効な場合
    case invalidPassword
    // IDとパスワードともに無効な場合
    case invalidIdAndPassword
}

// プロトコル
protocol ModelProtocol {
    // IDとパスワードをそれぞれ引数に取り、判定結果をObservable<Void>型として返す
    func validate(idText: String?, passwordText: String?) -> Observable<Void>
}

// プロトコルに準拠させるモデル
final class Model: ModelProtocol {
    func validate(idText: String?, passwordText: String?) -> RxSwift.Observable<Void> {
        // タプル
        switch (idText, passwordText) {
        case (.none, .none):
            return Observable.error(ModelError.invalidIdAndPassword)
        case (.none, .some):
            return Observable.error(ModelError.invalidId)
        case (.some, .none):
            return Observable.error(ModelError.invalidPassword)
        case (let idText?, let passwordText?):
            switch (idText.isEmpty, passwordText.isEmpty) {
            case (true, true):
                return Observable.error(ModelError.invalidIdAndPassword)
            case (false, false):
                return Observable.just(())
            case (true, false):
                return Observable.error(ModelError.invalidId)
            case (false, true):
                return Observable.error(ModelError.invalidPassword)
            }
        }
    }
}
