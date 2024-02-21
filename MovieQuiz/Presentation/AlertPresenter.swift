//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by AlexS on 29.01.2024.
//

import UIKit

final class AlertPresenter {
    weak var delegate: AlertPresenterDelegate?
    
    func show(model: AlertModel) {
        let alert = UIAlertController(title: model.title, // заголовок всплывающего окна
                                      message: model.message, // текст во всплывающем окне
                                      preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Game results"
        let action = UIAlertAction(title: model.buttonText, style: .default, handler: { _ in
            model.completion?()
        })
        alert.addAction(action)
        
        // показываем всплывающее окно
        delegate?.showAlert(alert)
    }
}

//final class AlertPresenter {
//    func show(in vc: UIViewController, model: AlertModel) {
//        let alert = UIAlertController(
//            title: model.title,
//            message: model.message,
//            preferredStyle: .alert)
//
//        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
//            model.completion()
//        }
//
//        alert.addAction(action)
//
//        vc.present(alert, animated: true, completion: nil)
//    }
//}
