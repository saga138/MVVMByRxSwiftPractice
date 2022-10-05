//
//  ViewController.swift
//  MVVMByRxSwiftPractice
//
//  Created by Saga on 2022/10/02.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var validationLabel: UILabel!

    // ViewModelの初期化時に、IDとパスワード入力フィールドのObservableを渡す
    private lazy var viewModel = ViewModel(
        //  UITextFieldが持つrx拡張からtextプロパティを取り出した上、asObservable()によってObservableを取り出して渡す
        idTextObservable: idTextField.rx.text.asObservable(),
        passwordTextObservable: passwordTextField.rx.text.asObservable(),
        model: Model()
    )

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // データバインディング
        viewModel.validationText
            .bind(to: validationLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.loadLabelColor
            .bind(to: loadLabelColor)
            .disposed(by: disposeBag)
    }

    // UILabelのtextColorのように、rx拡張のないプロパティを更新したり、
    // Viewのメソッドを実行するためのObservableは独自に定義する必要がある
    private var loadLabelColor: Binder<UIColor> {
        return Binder(self) { me, color in
            me.validationLabel.textColor = color
        }
    }
}

