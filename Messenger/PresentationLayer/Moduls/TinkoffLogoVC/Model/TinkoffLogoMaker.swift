//
//  TinkoffLogoMaker.swift
//  Messenger
//
//  Created by Иван Базаров on 03.12.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import Foundation
import UIKit

protocol TinkoffLogoProtocol {
    func setupEmmitterLayer(view: UIView)
}

class LogoView: TinkoffLogoProtocol {
    private let rootLayer = CALayer()
    private let logoEmitterLayer = CAEmitterLayer()
    private let logoEmitterCell = CAEmitterCell()
    private weak var view: UIView?
    lazy private var tapGestureRecogniser: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(self.userTappedScreen(sender:)))
    }()
    deinit {
        view?.removeGestureRecognizer(tapGestureRecogniser)
    }
    // MARK: - Setup Layers
    @objc func userTappedScreen(sender: UIPanGestureRecognizer) {
        if let view = view {
           switch sender.state {
                case .began:
                    startEmitting(position: sender.location(ofTouch: 0, in: view))
                case .changed:
                    startEmitting(position: sender.location(ofTouch: 0, in: view))
                case .ended, .cancelled:
                logoEmitterLayer.opacity = 0
                default:
                return
            }
        }
    }
    private func startEmitting(position: CGPoint) {
        logoEmitterLayer.opacity = 1
        logoEmitterLayer.emitterPosition = position
    }
    func setupEmmitterLayer(view: UIView) {
        logoEmitterLayer.emitterShape = .circle
        logoEmitterLayer.emitterPosition = view.center
        logoEmitterLayer.isOpaque = false
        logoEmitterLayer.opacity = 0
        logoEmitterLayer.renderMode = CAEmitterLayerRenderMode.additive
        setupEmitterCell()
        logoEmitterLayer.emitterCells = [logoEmitterCell]
        view.addGestureRecognizer(tapGestureRecogniser)
        view.layer.addSublayer(logoEmitterLayer)
        self.view = view
    }
    private func setupEmitterCell() {
        logoEmitterCell.contents = UIImage(named: "tinkofflogo")?.cgImage
        logoEmitterCell.lifetime = 5.0
        logoEmitterCell.birthRate = 20
        logoEmitterCell.alphaSpeed = -0.4
        logoEmitterCell.velocity = 50
        logoEmitterCell.velocityRange = 50
        logoEmitterCell.emissionRange = CGFloat.pi * 2
        logoEmitterCell.emissionLongitude = CGFloat.pi * 2
    }
}
