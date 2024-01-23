//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by AlexS on 23.01.2024.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion() -> QuizQuestion?
}
