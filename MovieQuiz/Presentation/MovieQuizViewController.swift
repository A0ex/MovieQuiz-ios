import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate {
    
    // MARK: - Lifecycle
    
    private var alertPresenter = AlertPresenter()
    
    private var presenter: MovieQuizPresenter!
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var noButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter.delegate = self
        showLoadingIndicator()
    }
    
    
    // MARK: - AlertPresenterDelegate
    
    func showAlert(_ alertModel: UIAlertController) {
        self.present(alertModel, animated: true, completion: nil)
    }
    
    // MARK: - Private Functions
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        var alertModel = AlertModel()
        alertModel.title = "Ошибка"
        alertModel.message = message
        alertModel.buttonText = "Попробовать ещё раз"
        alertModel.completion = { [weak self] in
            guard let self else { return }
            self.presenter.restartGame()
        }
        alertPresenter.show(model: alertModel)
    }

    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        // Установка рамки
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        
        let alert = UIAlertController(
            title: result.title,
            message: message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
}

