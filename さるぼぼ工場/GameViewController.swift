//
//  GameViewController.swift
//  さるぼぼ工場
//
//  Created by サマーキャンプ on 2017/08/18.
//  Copyright © 2017年 SUN. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
    let kSpawnFrequency = 15                        //さるぼぼの生成頻度
    var spawnFrequency = 0                          // 生成頻度 (Int型)
    let kTargetMaxType = UInt32(4)                  // さるぼぼの全種類 (UInt32型: 乱数で使用するため)
     var audioPlayer:AVAudioPlayer!
    

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var box_r: UIImageView!
    @IBOutlet weak var box_bla: UIImageView!
    @IBOutlet weak var box_blu: UIImageView!
    @IBOutlet weak var box_y: UIImageView!
    
    var timeCount = 0.0
    var targetImageViews: [TargetImageView] = []    // ターゲットを入れておく配列 (TargetImageView型の配列)
    var panningTargetDefaultCenter = CGPoint()   // パンしている魂のデフォルト位置 (CGPoint型)
    var spawnTimer: Timer?                        // 生成のタイマー (NSTimer型、初期値なし)
    var goukei = 0
    
    // MARK: - 初期化処理
    func addParts() {
        //オブジェクトプーリング
        for i in 0..<30 {
            var appearType = arc4random_uniform(kTargetMaxType) + 1
            var targetImageView = TargetImageView(type:appearType, tag: i + 1)
            targetImageView.isHidden = true
            
            // タッチイベントを取得するための設定
            var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(GameViewController.targetDidPan(sender:)))
            targetImageView.addGestureRecognizer(panGestureRecognizer)
            
            
            view.addSubview(targetImageView)
            targetImageViews.append(targetImageView)
        }
        

        
        
 
        
        
    }

    // MARK: - タッチイベント
    @objc func targetDidPan(sender: UIPanGestureRecognizer) {
        var targetImageView = sender.view as! TargetImageView
        
        switch sender.state {
        case .began:
            //タッチ始め
            panningTargetDefaultCenter = targetImageView.center     // タッチ中の魂の移動基準となる位置を保管しておく
        default:
            //タッチ中など
            var translationInView = sender.translation(in: view) // 指の移動量
            // タッチ始めの移動基準値に移動量を足すことで、移動すべき座標を作成する。
            targetImageView.center = CGPoint(x: panningTargetDefaultCenter.x + translationInView.x, y:panningTargetDefaultCenter.y + translationInView.y)
            
            //タッチ判定
            if !targetImageView.isHidden && box_r.frame.contains(targetImageView.center) && targetImageView.bobotype == 3 {
                targetImageView.stop()
                addScore(increase: 100)  // スコアを20追加
                suu[3]+=1
                suu[0]+=1
            } else if !targetImageView.isHidden && box_blu.frame.contains(targetImageView.center) && targetImageView.bobotype == 2{
                targetImageView.stop()
                addScore(increase: 100)  // スコアを20追加
                suu[2]+=1
                suu[0]+=1
            }else if !targetImageView.isHidden && box_bla.frame.contains(targetImageView.center) && targetImageView.bobotype == 1 {
                targetImageView.stop()
                addScore(increase: 100)  // スコアを20追加
                suu[1]+=1
                suu[0]+=1
            } else if !targetImageView.isHidden && box_y.frame.contains(targetImageView.center) && targetImageView.bobotype == 4 {
                targetImageView.stop()
                addScore(increase: 100)  // スコアを20追加
                suu[4]+=1
                suu[0]+=1
            }else if !targetImageView.isHidden && (box_bla.frame.contains(targetImageView.center) || box_r.frame.contains(targetImageView.center) || box_blu.frame.contains(targetImageView.center) || box_y.frame.contains(targetImageView.center) ){
                targetImageView.stop()
                addScore(increase: -100) //スコア減点
            }
            
        }
     
    }
    // MARK: - さるぼぼ生成
    func spawn(sender: Timer) {
        //タイムリミット管理
        timeCount -= 0.1
        timeLabel.text = String(format:"%.1f", timeCount)
        
        if timeCount > 0 {
            //　生成
            spawnFrequency -= 1
            if spawnFrequency < 0 {
                spawnFrequency = 0
            }
            if arc4random_uniform(UInt32(spawnFrequency)) == 0 {
                var appearTargetIndex = Int(arc4random_uniform(UInt32(targetImageViews.count)))
                var speedRandom = arc4random_uniform(5) + 1
                var speed = CGFloat(speedRandom) / 2.0
                var targetImageView = targetImageViews[appearTargetIndex]
                if targetImageView.isHidden {
                    print(targetImageView.bobotype)
                    spawnFrequency = kSpawnFrequency
                    targetImageView.start(speed: speed)
                }
            }
        } else {
            stop()
            self.performSegue(withIdentifier: "goResult", sender: self)
                
            
        }
    }
    func stop() {
        for targetImageView in targetImageViews {
            targetImageView.stop()
        }
        audioPlayer.stop()
    goukei = Int(scoreLabel.text!)!
        
        //スタートボタンを表示
        timeLabel.text = "60.0"
        scoreLabel.text = "0"
        stopTimer()
    }
    
    // MARK: - タイマーの開始と停止
    func startTimer() {
        spawnTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
            self.spawn(sender: timer)
        })
 
    }
    func stopTimer() {
        spawnTimer?.invalidate()
    }
    
    // MARK: - スコア追加
    func addScore(increase: Int) {
        var currentScore = Int(scoreLabel.text!)!
        currentScore += increase
        scoreLabel.text = "\(currentScore)"
    }
    var suu: [Int] = [0, 0, 0, 0, 0]
    // MARK: - ゲームの開始と停止
    @objc func start() {
        timeCount = 60.0
        spawnFrequency = kSpawnFrequency
        
        startTimer()
        
        // ゲーム終了後は0.5秒後に結果画面に遷移する
    
    }
        override func viewDidLoad() {
            super.viewDidLoad()
            // 再生する audio ファイルのパスを取得
            let audioPath = Bundle.main.path(forResource: "bgm_maoudamashii_8bit29", ofType:"mp3")!
            let audioUrl = URL(fileURLWithPath: audioPath)
            
            
            // auido を再生するプレイヤーを作成する
            var audioError:NSError?
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            } catch let error as NSError {
                audioError = error
                audioPlayer = nil
            }
            
            // エラーが起きたとき
            if let error = audioError {
                print("Error \(error.localizedDescription)")
            }
            
           audioPlayer.numberOfLoops = -1
            audioPlayer.prepareToPlay()
            
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        addParts()
        start()
        audioPlayer.play()
    }
    
   
        // Do any additional setup after loading the view.

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   

    

    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goResult" {
            var Resultvc = segue.destination as! ResultViewController
            print(suu)
            Resultvc.suu = suu
            suu = [0, 0, 0, 0, 0]
            Resultvc.goukei = goukei
        }
    }
    

}
