//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by AlexS on 01.02.2024.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get } // средняя точность
    var allCorrectAnswers: Int { get }
    var gamesCount: Int { get } // количество завершенных игр
    var bestGame: GameRecord { get } // информация о лучшей попытке
    func store(correct count: Int, total amount: Int)
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date

    // метод сравнения по количеству верных ответов
    func isBetterThan(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
    
    func showRecord() -> String {
        return "\(correct)/\(total) (\(date.dateTimeString))"
    }
}

