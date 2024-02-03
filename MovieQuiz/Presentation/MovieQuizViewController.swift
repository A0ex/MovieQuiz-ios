import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    // MARK: - Lifecycle
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var alertPresenter = AlertPresenter()
    private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var noButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter.delegate = self
        questionFactory.delegate = self
        questionFactory.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        // проверка, что вопрос не nil
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - AlertPresenterDelegate
    
    func showAlert(_ alertModel: UIAlertController) {
        self.present(alertModel, animated: true, completion: nil)
    }
    
    // MARK: - Private Functions
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let viewModel = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return viewModel
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        // Установка рамки
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        correctAnswers += isCorrect ? 1 : 0
        
        
        // Убирание рамки через секунду
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // Переход к следующему вопросу или результатам
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            var alertModel = AlertModel()
//            let res = QuizResultsViewModel(title: "Этот раунд окончен!", text: "Ваш результат \(correctAnswers)/10", buttonText: "Сыграть ещё раз")
            alertModel.message += " \(correctAnswers)/10"
            alertModel.completion = {
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.questionFactory.requestNextQuestion()
            }
//            show(quiz: res)
            alertPresenter.show(model: alertModel)
        } else {
            currentQuestionIndex += 1
            questionFactory.requestNextQuestion()
        }
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    private func show(quiz step: QuizStepViewModel) {
        let newImage = step.image
        // Анимация смены изображения с плавным переходом
        UIView.transition(with: imageView,
                          duration: 0.5, // Длительность анимации в секундах
                          options: .transitionCrossDissolve, // Тип анимации (плавное появление/исчезновение)
                          animations: { [weak self] in
            guard let self = self else { return }
            self.imageView.image = newImage
            self.imageView.layer.borderWidth = 0
        },
                          completion: nil)
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        feedbackGenerator.impactOccurred()
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        feedbackGenerator.impactOccurred()
        guard let currentQuestion = currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }
    
}


/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
