//
//  AVPlayer.swift
//  WatchMe
//
//  Created by Marat Nazirov on 04.09.2020.
//

import UIKit
import AVKit

protocol VideoPlayer {
    func createLocalUrl(for filename: String) -> URL?
    func creatPlayer(with url: URL) -> AVPlayerViewController
}

final class VideoPlayerManager: VideoPlayer {
    func createLocalUrl(for filename: String) -> URL? {
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDirectory.appendingPathComponent("\(filename).mp4")
        
        guard fileManager.fileExists(atPath: url.path) else {
            guard let video = NSDataAsset(name: filename)  else { return nil }
            fileManager.createFile(atPath: url.path, contents: video.data, attributes: nil)
            return url
        }
        
        return url
    }
    
    func creatPlayer(with url: URL) -> AVPlayerViewController {
        let player = AVPlayer(url: url)
        let viewController = AVPlayerViewController()
        viewController.player = player
        return viewController
    }
}
