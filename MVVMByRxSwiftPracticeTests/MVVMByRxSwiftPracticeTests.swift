//
//  MVVMByRxSwiftPracticeTests.swift
//  MVVMByRxSwiftPracticeTests
//
//  Created by Saga on 2022/10/02.
//

import UIKit
import RxRelay
import RxSwift
import XCTest
@testable import MVVMByRxSwiftPractice

class FakeModel: ModelProtocol {
    var result: Observable<Void>?

    func validate(idText: String?, passwordText: String?) -> Observable<Void> {
        guard let result = result else {
            fatalError("ぎゃふん")
        }

        return result
    }
}

class ViewModelTests: XCTestCase {
    func test_changeTextAndColor() {
        let idTextObservable = PublishSubject<String?>()
        let passwordTextObservable = PublishSubject<String?>()
        let validationResult = PublishSubject<Void>()
        let model = FakeModel()
        model.result = validationResult

        let viewModel = ViewModel(
            idTextObservable: idTextObservable,
            passwordTextObservable: passwordTextObservable,
            model: model
        )

        let validationText = BehaviorRelay<String?>(value: nil)
        let disposable1 = viewModel.validationText
            .bind(to: validationText)
        defer {
            disposable1.dispose()
        }

        let loadLabelColor = BehaviorRelay<UIColor?>(value: nil)
        let disposable2 = viewModel.loadLabelColor
            .bind(to: loadLabelColor)
        defer {
            disposable2.dispose()
        }

        do {
            idTextObservable.onNext("id")
            passwordTextObservable.onNext("password")
            validationResult.onNext(())
            XCTAssertEqual("IDとPasswordを入力してください。", validationText.value)
            XCTAssertNil(loadLabelColor.value)
        }

        do {
            passwordTextObservable.onNext("password")
            validationResult.onNext(())
            XCTAssertEqual("OK!!!", validationText.value)
            XCTAssertEqual(UIColor.green, loadLabelColor.value)
        }
    }
}
