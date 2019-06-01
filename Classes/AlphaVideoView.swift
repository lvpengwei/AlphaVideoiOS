//
//  AlphaVideoView.swift
//  AlphaVideoiOSDemo
//
//  Created by lvpengwei on 2019/5/26.
//  Copyright © 2019 lvpengwei. All rights reserved.
//

import UIKit
import AVFoundation

public class AlphaVideoView: UIView {
    deinit {
        self.playerItem = nil
    }
    override public class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    var playerLayer: AVPlayerLayer { return layer as! AVPlayerLayer }
    private var player: AVPlayer? {
        get { return playerLayer.player }
    }
    var name: String = "" {
        didSet {
            loadVideo()
        }
    }
    public init(with name: String) {
        super.init(frame: .zero)
        commonInit()
        self.name = name
        loadVideo()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    public func play() {
        player?.play()
    }
    public func pause() {
        player?.pause()
    }
    private func commonInit() {
        playerLayer.pixelBufferAttributes = [ (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA]
        playerLayer.player = AVPlayer()
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
    @objc private func tapAction() {
        guard let player = player else { return }
        guard player.rate == 0 else { return }
        player.play()
    }
    private var asset: AVAsset?
    private func loadVideo() {
        guard !name.isEmpty else {
            return
        }
        guard let videoURL = Bundle.main.url(forResource: name, withExtension: "mp4") else { return }
        self.asset = AVURLAsset(url: videoURL)
        self.asset?.loadValuesAsynchronously(forKeys: ["duration", "tracks"]) { [weak self] in
            guard let self = self, let asset = self.asset else { return }
            DispatchQueue.main.async {
                self.playerItem = AVPlayerItem(asset: asset)
            }
        }
    }
    private var playerItem: AVPlayerItem? = nil {
        willSet {
            player?.pause()
        }
        didSet {
            player?.seek(to: CMTime.zero)
            setupPlayerItem()
            setupLooping()
            player?.replaceCurrentItem(with: playerItem)
        }
    }
    private var didPlayToEndTimeObsever: NSObjectProtocol? = nil {
        willSet(newObserver) {
            if let observer = didPlayToEndTimeObsever, didPlayToEndTimeObsever !== newObserver {
                NotificationCenter.default.removeObserver(observer)
            }
        }
    }
    private func setupLooping() {
        guard let playerItem = self.playerItem, let player = self.player else {
            return
        }
        
        didPlayToEndTimeObsever = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: nil, using: { _ in
            player.seek(to: CMTime.zero) { _ in
                player.play()
            }
        })
    }
    private func setupPlayerItem() {
        guard let playerItem = playerItem else { return }
        let tracks = playerItem.asset.tracks
        guard tracks.count > 0 else {
            print("no tracks")
            return
        }
        let videoSize = CGSize(width: tracks[0].naturalSize.width, height: tracks[0].naturalSize.height * 0.5)
        guard videoSize.width > 0 && videoSize.height > 0 else {
            print("video size is zero")
            return
        }
        let composition = AVMutableVideoComposition(asset: playerItem.asset, applyingCIFiltersWithHandler: { request in
            let sourceRect = CGRect(origin: .zero, size: videoSize)
            let alphaRect = sourceRect.offsetBy(dx: 0, dy: sourceRect.height)
            let filter = AlphaFrameFilter()
            filter.inputImage = request.sourceImage.cropped(to: alphaRect)
                .transformed(by: CGAffineTransform(translationX: 0, y: -sourceRect.height))
            filter.maskImage = request.sourceImage.cropped(to: sourceRect)
            return request.finish(with: filter.outputImage!, context: nil)
        })
        
        composition.renderSize = videoSize
        playerItem.videoComposition = composition
        playerItem.seekingWaitsForVideoCompositionRendering = true
    }
}
