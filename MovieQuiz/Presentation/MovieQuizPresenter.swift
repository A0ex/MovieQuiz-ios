//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Alex on 20.02.2024.
//

import UIKit

final class MovieQuizPresenter {
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    let questionsAmount: Int = 10
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let viewModel = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return viewModel
    }
    
    func yesButtonClicked() {
        feedbackGenerator.impactOccurred()
        guard let currentQuestion = currentQuestion else { return }
        viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }
    
    func noButtonClicked() {
        feedbackGenerator.impactOccurred()
        guard let currentQuestion = currentQuestion else { return }
        viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }
}
