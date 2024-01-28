//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by AlexS on 26.01.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
