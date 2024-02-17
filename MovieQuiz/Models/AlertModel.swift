//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by AlexS on 29.01.2024.
//

import Foundation

struct AlertModel {
    var title = "Этот раунд окончен!"
    var message = "Ваш результат:"
    var buttonText = "Сыграть ещё раз"
    var completion: (() -> Void)?
}
