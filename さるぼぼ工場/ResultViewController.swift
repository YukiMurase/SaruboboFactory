//
//  ResultViewController.swift
//  さるぼぼ工場
//
//  Created by サマーキャンプ on 2017/08/18.
//  Copyright © 2017年 遠藤　大彰. All rights reserved.
//

import UIKit
import Social

class ResultViewController: UIViewController {
      var suu:[Int] = [0,0,0,0,0]
    var goukei = 0
    @IBOutlet weak var redsuu: UILabel!
    
    
    @IBOutlet weak var goukeilabel: UILabel!
    @IBOutlet weak var ysuu: UILabel!
    @IBOutlet weak var bluesuu: UILabel!
    @IBOutlet weak var blacksuu: UILabel!
    @IBAction func tweet(_ sender: Any) {
        // ツイート処理が可能かチェック
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            // make controller to share on twitter
            let slc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            slc?.setInitialText("あなたの点数は\(goukei)です！\n＃さるぼぼ工場\n")
            slc?.add(getScreenShot())
            // ツイート入力画面表示
            present(slc!, animated: true, completion: {
            })
            
            // 事後処理
            slc?.completionHandler = {
                (result:SLComposeViewControllerResult) -> () in
                switch (result) {
                    
                // 投稿した
                case SLComposeViewControllerResult.done:
                    print("tweeted")
                    
                // キャンセルした
                case SLComposeViewControllerResult.cancelled:
                    print("tweet cancel")
                    
                }
            }
        } else {
            print("can not tweet")
        }
    }
    @IBAction func Retey(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)    }
   
    @IBAction func Top(_ sender: UIButton) {
         navigationController?.popToRootViewController(animated: true)    }
    private func getScreenShot() -> UIImage {
        let rect = self.view.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.view.layer.render(in: context)
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return capturedImage
    };    override func viewDidLoad() {
        super.viewDidLoad()
        print(suu[1])
        print(suu[2])
        print(suu[3])
        print(suu[4])
        redsuu.text = String( suu[3])
        bluesuu.text = String(suu[2])
        blacksuu.text = String(suu[1])
        ysuu.text = String(suu[4])
        goukeilabel.text = String(goukei)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

