import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    
    // MARK: - Lifecycle
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private var alertPresenter = AlertPresenter()
    private var questionFactory: QuestionFactoryProtocol?
    private var statisticService = StatisticServiceImplementation()
    private var currentQuestion: QuizQuestion?
    
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var noButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter.delegate = self
        questionFactory?.delegate = self
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()
        showLoadingIndicator()
        questionFactory?.loadData()
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
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription) // в качестве сообщения используется описание ошибки
    }
    
    // MARK: - Private Functions
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        var alertModel = AlertModel()
        alertModel.title = "Ошибка"
        alertModel.message = message
        alertModel.buttonText = "Попробовать ещё раз"
        alertModel.completion = { [weak self] in
            guard let self = self else { return }
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.loadData()
        }
        alertPresenter.show(model: alertModel)
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let viewModel = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
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
            statisticService.gamesCount += 1
            statisticService.allCorrectAnswers += correctAnswers
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            statisticService.totalAccuracy = 100 * Double(statisticService.allCorrectAnswers) / Double(questionsAmount * statisticService.gamesCount)
            var alertModel = AlertModel()
            alertModel.message = "Ваш результат: \(correctAnswers)/10\nКоличество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(statisticService.bestGame.showRecord())\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            alertModel.completion = { [weak self] in
                self?.currentQuestionIndex = 0
                self?.correctAnswers = 0
                self?.questionFactory?.requestNextQuestion()
            }
            alertPresenter.show(model: alertModel)
        } else {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
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

