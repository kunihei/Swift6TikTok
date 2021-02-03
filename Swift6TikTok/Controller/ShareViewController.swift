//
//  ShareViewController.swift
//  Swift6TikTok
//
//  Created by 祥平 on 2021/01/28.
//

import UIKit
import AVKit
import Photos

class ShareViewController: UIViewController {
    
    var captionString = String()
    var passedURL = String()
    var player:AVPlayer?
    var playerController:AVPlayerViewController?
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        notification.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUPVideoPlayer(url: URL(string: passedURL)!)
        
    }
    
    @objc func playerItemDidReachEnd(_ notification:Notification){
        
        if self.player != nil{
            
            self.player?.seek(to: CMTime.zero)
            self.player?.volume = 1
            self.player?.play()
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: Notification?) {
        let rect = (notification?.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
        }
    }
    
    func setUPVideoPlayer(url:URL){
           
           
           self.view.backgroundColor = UIColor.black
           playerController?.removeFromParent()
           player = AVPlayer(url: url)
           self.player?.volume = 1
          
           playerController = AVPlayerViewController()
           playerController!.view.frame = CGRect(x: 29, y: 88, width: 320, height: 445)
           playerController?.videoGravity = .resizeAspectFill
           playerController!.showsPlaybackControls = false
           playerController!.player = player!
           self.addChild(playerController!)
           self.view.addSubview(playerController!.view)
           

           NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)

           
           player?.play()

       }
       
    
    
    @objc func keyboardWillHide(notification: Notification?) {
        let duration: TimeInterval? = notification?.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double
        UIView.animate(withDuration: duration!) {
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func savePhotoLibrary(_ sender: Any) {
        
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(string: self.passedURL)!)
        } completionHandler: { (result, error) in
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            if result{
                print("動画を保存しました！")
            }
        }
    }
    
    @IBAction func share(_ sender: Any) {
        
        let activityItems = [URL(string: passedURL) as Any, "\(textView.text!)\n\(captionString)\n#UdemyTikTokios14"] as [Any]
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view
        activityController.popoverPresentationController?.sourceRect = self.view.frame
        self.present(activityController, animated: true, completion: nil)

    }
    
    @IBAction func back(_ sender: Any) {
        
        player?.pause()
        player = nil
        self.navigationController?.popToRootViewController(animated: true)
        
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
