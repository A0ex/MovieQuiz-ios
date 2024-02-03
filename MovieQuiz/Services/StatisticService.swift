//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by AlexS on 01.02.2024.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
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
}

