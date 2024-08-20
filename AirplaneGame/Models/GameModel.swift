//
//  GameModel.swift
//  AirplaneGame
//
//  Created by Pavlo Kostenko on 07/08/2024.
//

import Foundation
import SwiftUI
import AVFoundation

class GameModel: ObservableObject {
    @Published var airplanePosition: CGPoint
    @Published var obstacles: [Obstacle]
    @Published var fuels: [Fuel]
    @Published var timeElapsed: TimeInterval
    @Published var score: Int
    @Published var isGameOver: Bool
    @Published var isAirplaneHit: Bool
    @Published var highScore: Int

    private var gameTimer: Timer?
    private var obstacleTimer: Timer?
    private var fuelTimer: Timer?
    private var speedMultiplier: Double
    private var audioPlayer: AVAudioPlayer?
    
    let screenTopPadding: CGFloat = 50
    let screenBottomPadding: CGFloat = 100 // межа для нижньої частини екрану


    init() {
        if UserDefaults.standard.object(forKey: "MusicOn") == nil {
            UserDefaults.standard.set(true, forKey: "MusicOn")
        }
        if UserDefaults.standard.object(forKey: "SoundOn") == nil {
            UserDefaults.standard.set(true, forKey: "SoundOn")
        }

        self.airplanePosition = CGPoint(x: 50, y: UIScreen.main.bounds.height / 2)
        self.obstacles = []
        self.fuels = []
        self.timeElapsed = 0
        self.score = 0
        self.isGameOver = false
        self.isAirplaneHit = false
        self.speedMultiplier = 1.0
        self.highScore = UserDefaults.standard.integer(forKey: "HighScore")
        generateInitialObstacles()
        generateInitialFuels()
        startGameTimers()
        updateBackgroundMusic(UserDefaults.standard.bool(forKey: "MusicOn"))
        updateSoundEffects(UserDefaults.standard.bool(forKey: "SoundOn"))
    }

    // Генерація початкових об'єктів перешкод
    func generateInitialObstacles() {
        let numberOfObstacles = 5
        for _ in 0..<numberOfObstacles {
            generateObstacle()
        }
    }

    // Генерація початкових об'єктів палива
    func generateInitialFuels() {
        let numberOfFuels = 3
        for _ in 0..<numberOfFuels {
            generateFuel()
        }
    }

    // Генерація перешкод з випадковою вертикальною позицією та проміжком
    func generateObstacle() {
        let randomY = CGFloat.random(in: 50...(UIScreen.main.bounds.height - 50))
        let previousObstacleX = obstacles.last?.position.x ?? UIScreen.main.bounds.width
        let randomSpacing = CGFloat.random(in: 100...200) // випадковий проміжок між об'єктами

        let obstacle = Obstacle(position: CGPoint(x: previousObstacleX + randomSpacing, y: randomY), isVisible: true)
        obstacles.append(obstacle)
    }

    // Генерація палива з випадковою вертикальною позицією та проміжком
    func generateFuel() {
        let randomY = CGFloat.random(in: 50...(UIScreen.main.bounds.height - 50))
        let previousFuelX = fuels.last?.position.x ?? UIScreen.main.bounds.width
        let randomSpacing = CGFloat.random(in: 150...300) // випадковий проміжок між об'єктами

        let fuel = Fuel(position: CGPoint(x: previousFuelX + randomSpacing, y: randomY), isVisible: true)
        fuels.append(fuel)
    }

    // Оновлення гри: рух об'єктів, перевірка колізій
    func updateGame() {
        guard !isGameOver else { return }

        // Додаємо перевірку на обмеження для літака
        enforceAirplaneBounds()

        for index in obstacles.indices {
            obstacles[index].position.x -= 5 * speedMultiplier
            
            // Якщо перешкода виходить за межі екрана - видаляємо її та генеруємо нову
            if obstacles[index].position.x < -50 {
                obstacles.remove(at: index)
                generateObstacle()
            }
        }

        for index in fuels.indices {
            fuels[index].position.x -= 5 * speedMultiplier
            
            // Якщо паливо виходить за межі екрана - видаляємо його та генеруємо нове
            if fuels[index].position.x < -50 {
                fuels.remove(at: index)
                generateFuel()
            }
        }

        checkCollisions()
    }

    func enforceAirplaneBounds() {
        let minY = screenTopPadding
        let maxY = UIScreen.main.bounds.height - screenBottomPadding
        
        if airplanePosition.y < minY {
            airplanePosition.y = minY
        } else if airplanePosition.y > maxY {
            airplanePosition.y = maxY
        }
    }


    // Старт ігрових таймерів
    private func startGameTimers() {
        stopGame()

        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeElapsed += 1
            self.speedMultiplier += 0.10
            self.score += Int(10 * self.speedMultiplier)
        }

        obstacleTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.updateGame()
        }

        fuelTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.generateFuel()
        }
    }

    // Скидання гри
    func resetGame() {
        if score > highScore {
            highScore = score
            UserDefaults.standard.set(highScore, forKey: "HighScore")
        }

        if timeElapsed > UserDefaults.standard.double(forKey: "LongestPlayTime") {
            UserDefaults.standard.set(timeElapsed, forKey: "LongestPlayTime")
        }

        self.airplanePosition = CGPoint(x: 50, y: UIScreen.main.bounds.height / 2)
        self.obstacles = []
        self.fuels = []
        self.timeElapsed = 0
        self.score = 0
        self.isGameOver = false
        self.isAirplaneHit = false
        self.speedMultiplier = 1.0
        generateInitialObstacles()
        generateInitialFuels()
        startGameTimers()
        updateBackgroundMusic(UserDefaults.standard.bool(forKey: "MusicOn"))
        updateSoundEffects(UserDefaults.standard.bool(forKey: "SoundOn"))
    }

    // Зупинка гри
    func stopGame() {
        gameTimer?.invalidate()
        obstacleTimer?.invalidate()
        fuelTimer?.invalidate()
    }

    // Завершення гри
    private func endGame() {
        stopGame()
        isGameOver = true
        stopBackgroundMusic()
    }

    // Перевірка колізій
    private func checkCollisions() {
        for index in obstacles.indices {
            if abs(obstacles[index].position.x - airplanePosition.x) < 30 &&
                abs(obstacles[index].position.y - airplanePosition.y) < 30 &&
                obstacles[index].isVisible {
                playSound("hit")
                endGame()
                return
            }
        }

        for index in fuels.indices {
            if abs(fuels[index].position.x - airplanePosition.x) < 30 &&
                abs(fuels[index].position.y - airplanePosition.y) < 30 &&
                fuels[index].isVisible {
                score += Int(50 * speedMultiplier)
                playSound("collect")
                isAirplaneHit = true
                fuels[index].isVisible = false
            }
        }
    }

    // Відтворення звуку
    func playSound(_ sound: String) {
        guard UserDefaults.standard.bool(forKey: "SoundOn"),
              let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Could not load sound file.")
        }
    }

    // Оновлення фону
    func updateBackgroundMusic(_ shouldPlay: Bool) {
        if shouldPlay {
            playBackgroundMusic()
        } else {
            stopBackgroundMusic()
        }
    }

    func updateSoundEffects(_ shouldPlay: Bool) {
    }

    private func playBackgroundMusic() {
        guard UserDefaults.standard.bool(forKey: "MusicOn"),
              let url = Bundle.main.url(forResource: "main_sound", withExtension: "mp3") else { return }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            print("Could not load background music.")
        }
    }

    private func stopBackgroundMusic() {
        audioPlayer?.stop()
    }
}

struct Obstacle {
    var position: CGPoint
    var isVisible: Bool
}

struct Fuel {
    var position: CGPoint
    var isVisible: Bool
}
