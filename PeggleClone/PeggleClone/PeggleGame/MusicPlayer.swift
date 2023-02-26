//
//  MusicPlayer.swift
//  PeggleClone
//
//  Created by Taufiq Abdul Rahman on 24/2/23.
//

import Foundation
import AVFoundation

class MusicPlayer {
    var backgroundAudioPlayer: AVAudioPlayer?
    var gameAudioPlayer: AVAudioPlayer?
    var cannonAudioPlayer: AVAudioPlayer?
    var explosionAudioPlayer: AVAudioPlayer?
    var popAudioPlayer: AVAudioPlayer?
    var deathAudioPlayer: AVAudioPlayer?
    var enterBucketAudioPlayer: AVAudioPlayer?

    init() {
        backgroundAudioPlayer = MusicPlayer.createAudioPlayer(resource: "backgroundMusic", type: "mp3", numLoops: -1)
        gameAudioPlayer = MusicPlayer.createAudioPlayer(resource: "game", type: "mp3", numLoops: -1)
        cannonAudioPlayer = MusicPlayer.createAudioPlayer(resource: "cannon", type: "mp3", numLoops: 0)
        explosionAudioPlayer = MusicPlayer.createAudioPlayer(resource: "explosion", type: "wav", numLoops: 0)
        popAudioPlayer = MusicPlayer.createAudioPlayer(resource: "pop", type: "mp3", numLoops: 0)
        deathAudioPlayer = MusicPlayer.createAudioPlayer(resource: "death", type: "mp3", numLoops: 0)
        enterBucketAudioPlayer = MusicPlayer.createAudioPlayer(resource: "enter-bucket", type: "mp3", numLoops: 0)
    }

    static func createAudioPlayer(resource: String, type: String, numLoops: Int) -> AVAudioPlayer? {
        if let bundle = Bundle.main.path(forResource: resource, ofType: type) {
            let sound = NSURL(fileURLWithPath: bundle)
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: sound as URL)
                audioPlayer.numberOfLoops = numLoops
                audioPlayer.prepareToPlay()
                return audioPlayer
            } catch {
                print(error)
            }
        }
        return nil
    }

    func startBackgroundMusic() {
        backgroundAudioPlayer?.play()
    }

    func stopBackgroundMusic() {
        backgroundAudioPlayer?.stop()
    }

    func startGameMusic() {
        gameAudioPlayer?.play()
    }

    func stopGameMusic() {
        gameAudioPlayer?.stop()
    }

    func playCannonSound() {
        cannonAudioPlayer?.play()
    }

    func playExplosionSound() {
        explosionAudioPlayer?.play()
    }

    func playPopSound() {
        popAudioPlayer?.play()
    }

    func playDeathSound() {
        deathAudioPlayer?.play()
    }
    
    func playEnterBucket() {
        enterBucketAudioPlayer?.play()
    }
}
