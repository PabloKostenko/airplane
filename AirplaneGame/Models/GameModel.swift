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
        startGameTimers()
        updateBackgroundMusic(UserDefaults.standard.bool(forKey: "MusicOn"))
        updateSoundEffects(UserDefaults.standard.bool(forKey: "SoundOn"))
    }

    func generateObstacle() {
        let randomY = CGFloat.random(in: 50...(UIScreen.main.bounds.height - 50))
        let obstacle = Obstacle(position: CGPoint(x: UIScreen.main.bounds.width, y: randomY), isVisible: true)
        obstacles.append(obstacle)
    }

    func generateFuel() {
        let randomY = CGFloat.random(in: 50...(UIScreen.main.bounds.height - 50))
        let fuel = Fuel(position: CGPoint(x: UIScreen.main.bounds.width, y: randomY), isVisible: true)
        fuels.append(fuel)
    }

    func updateGame() {
        guard !isGameOver else { return }

        for index in obstacles.indices {
            obstacles[index].position.x -= 5 * speedMultiplier
        }
        for index in fuels.indices {
            fuels[index].position.x -= 5 * speedMultiplier
        }

        obstacles.removeAll { $0.position.x < -50 }
        fuels.removeAll { $0.position.x < -50 }

        if obstacles.count < 5 {
            generateObstacle()
        }
        if fuels.count < 3 {
            generateFuel()
        }

        checkCollisions()
    }

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
        startGameTimers()
        updateBackgroundMusic(UserDefaults.standard.bool(forKey: "MusicOn"))
        updateSoundEffects(UserDefaults.standard.bool(forKey: "SoundOn"))
    }

    func stopGame() {
        gameTimer?.invalidate()
        obstacleTimer?.invalidate()
        fuelTimer?.invalidate()
    }

    private func endGame() {
        stopGame()
        isGameOver = true
        stopBackgroundMusic()
    }

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
