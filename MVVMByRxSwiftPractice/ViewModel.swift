//
//  ViewModel.swift
//  MVVMByRxSwiftPractice
//
//  Created by Saga on 2022/10/02.
//

import UIKit
import RxSwift

final class ViewModel {
    let validationText: Observable<String>
    let loadLabelColor: Observable<UIColor>

    init(idTextObservable: Observable<String?>,
         passwordTextObservable: Observable<String?>,
         model: ModelProtocol) {
        let event = Observable
        // IDかPasswordのいずれかでイベント（変更）が生じれば共通の処理を呼び出すため、2つの入力（Observable）を合成している
        // combine = 合成
            .combineLatest(idTextObservable, passwordTextObservable)
            .skip(1)
            .flatMap { idText, passwordText -> Observable<Event<Void>> in
                return model
                    .validate(idText: idText, passwordText: passwordText)
                // onNext、onError(、onComplete)のイベントをObservable<Event<Void>>として変換、
                // それぞれ別々のストリームとして扱えるようにしている
                    .materialize()
            }
        // HotObservableに変換し、ひとつの入力に対してこれ以降のObservableがそれぞれ独立したストリームとしてデータ更新を行えるようにしている
            .share()

        self.validationText = event
            .flatMap { event -> Observable<String> in
                switch event {
                case .next:
                    return .just("OK!!!")
                case let .error(error as ModelError):
                    return .just(error.errorText)
                case .error, .completed:
                    return .empty()
                }
            }
            .startWith("IDとPasswordを入力してください。")

        self.loadLabelColor = event
            .flatMap { event -> Observable<UIColor> in
                switch event {
                case .next:
                    return .just(.green)
                case .error:
                    return .just(.red)
                case .completed:
                    return .empty()
                }
            }
    }
}

extension ModelError {
    fileprivate var errorText: String {
        switch self {
        case .invalidIdAndPassword:
            return "IDとPasswordが未入力です。"
        case .invalidId:
            return "IDが未入力です。"
        case .invalidPassword:
            return "Passwordが未入力です。"
        }
    }
}
