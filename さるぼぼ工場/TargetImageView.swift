//
//  TargetImageView.swift
//  TouchAnimation
//
//  Created by macbook111 on 2017/08/08.
//  Copyright © 2017年 masaki sato. All rights reserved.
//

import UIKit

class TargetImageView: UIImageView {
    var moveTimer: Timer?    // Timer型(初期値なし、Optional: nilを許容する。)
    var moveSpeed = CGFloat(0.0)    // CGfloat型
    var bobotype = 0 // さるぼぼの色
    // MARK: - イニシャライザ
    init(type: UInt32, tag: Int) {
        super.init(image: UIImage(named:"bobo\(type).png"))
        isUserInteractionEnabled = true
        self.tag = tag
        bobotype = Int(type)
    }
    
    // required指定されているので、実装しないとエラーになる
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        stopTimer()
    }
    // MARK: - タイマーの開始と停止
    func stopTimer() {
        moveTimer?.invalidate()
    }
    func startTimer() {
        stopTimer()
        //0.03秒ごとに動く
        moveTimer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: { (timer) in
            self.move(timer:timer)
        })
    }
    
    // MARK: - タイマー処理
    func move(timer:Timer) {
        var currentPosition = center
        currentPosition.y -= moveSpeed
        
        if currentPosition.y < 0 {
            stop()
        } else {
            center = currentPosition
        }
    }
    
    // MARK: - 開始と停止
    func start(speed: CGFloat) {
        isHidden = false
        
        //画面幅を超えないように位置を決める
        var minWidth = bounds.width
        var maxWidth = UInt32(320 - (bounds.width * 2))
        var positionX = 105 + CGFloat(arc4random_uniform(maxWidth / 2))
        var positionY = 568 - bounds.height
        center = CGPoint(x: positionX, y: positionY)
        
        //速度
        moveSpeed = speed
        
        //タイマーon
        startTimer()
    }
    func stop() {
        stopTimer()
        isHidden = true
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
