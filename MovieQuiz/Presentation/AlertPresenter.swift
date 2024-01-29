//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by AlexS on 29.01.2024.
//

import UIKit

class AlertPresenter {
    weak var delegate: AlertPresenterDelegate?
    
    func show(model: AlertModel) {
        let alert = UIAlertController(title: model.title, // заголовок всплывающего окна
                                      message: model.message, // текст во всплывающем окне
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default, handler: { _ in
            model.completion?()
        })
        alert.addAction(action)
        
        // показываем всплывающее окно
        delegate?.showAlert(alert)
    }
}
