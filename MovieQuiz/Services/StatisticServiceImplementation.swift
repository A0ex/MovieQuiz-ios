//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by AlexS on 01.02.2024.
//

import UIKit

final class StatisticServiceImplementation: StatisticService {

    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var allCorrectAnswers: Int {
        get {
            let data = userDefaults.integer(forKey: "allCorrectAnswers")
            return data
        }
        set {
            userDefaults.set(newValue, forKey: "allCorrectAnswers")
        }
    }
    
    var totalAccuracy: Double {
        get {
            let data = userDefaults.double(forKey: "totalAccuracy")
            return data
        }
        set {
            userDefaults.set(newValue, forKey: "totalAccuracy")
        }
    }
    var gamesCount: Int {
        get {
            let data = userDefaults.integer(forKey: "gamesCount")
            return data
        }
        set {
            userDefaults.set(newValue, forKey: "gamesCount")
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)

        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let newRecord = GameRecord(correct: count, total: amount, date: NSDate() as Date)
        if newRecord.isBetterThan(bestGame) {
            bestGame = newRecord
        }
    }
    
    
}
