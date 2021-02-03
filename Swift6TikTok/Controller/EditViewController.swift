//
//  EditViewController.swift
//  Swift6TikTok
//
//  Created by 祥平 on 2021/01/25.
//

import UIKit
import AVKit

class EditViewController: UIViewController {
    
    var url:URL?
    var playerController:AVPlayerViewController?
    var player:AVPlayer?
    var captionString = String()
    var passedURL = String()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUPVideoPlayer(url: url!)
    }
    
    func setUPVideoPlayer(url:URL){
        
        playerController?.removeFromParent()
        player = nil
        player = AVPlayer(url: url)
        self.player?.volume = 1
        view.backgroundColor = .black
        playerController = AVPlayerViewController()
        playerController?.videoGravity = .resizeAspectFill
        playerController?.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 100)
        playerController?.showsPlaybackControls = false
        playerController?.player = player!
        self.addChild(playerController!)
        self.view.addSubview((playerController?.view)!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 30.0, height: 30.0))
        cancelButton.setImage(UIImage(named: "cancel"), for: UIControl.State())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        player?.play()

    }
    
    @objc func cancel(){
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func playerItemDidReachEnd(_ notification:Notification){
        
        if self.player != nil{
            
            self.player?.seek(to: CMTime.zero)
            self.player?.volume = 1
            self.player?.play()
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "selectVC"{
            
            let selectVC = segue.destination as! SelectViewController
            selectVC.passedURL = url
            DispatchQueue.global().async {
                
                selectVC.resultHandler = {
                    
                    url, text1, text2 in
                    self.setUPVideoPlayer(url: URL(string: url)!)
                    self.captionString = text1 + "\n" + text2
                    self.passedURL = url
                    
                }
            }
        }
        
        if segue.identifier == "shareVC"{
            
            let shareVC = segue.destination as! ShareViewController
            shareVC.captionString = self.captionString
            shareVC.passedURL = self.passedURL
            
        }
        
    }
    
    @IBAction func showSelectVC(_ sender: Any) {
        
        performSegue(withIdentifier: "selectVC", sender: nil)
        
    }
    
    @IBAction func next(_ sender: Any) {
        
        if captionString.isEmpty != true{
            player?.pause()
            performSegue(withIdentifier: "shareVC", sender: nil)
        }else{
            print("楽曲を選択して下さい。")
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
