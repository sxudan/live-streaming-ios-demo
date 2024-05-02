//
//  VideoViewController.swift
//  Live Streaming App
//
//  Created by Sudayn on 29/4/2024.
//

import UIKit
import MobileVLCKit


class VideoViewController: UIViewController {
    
    @IBOutlet weak var movieView: UIView!
    var mediaPlayer = VLCMediaPlayer()
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let u = url {
            setupMediaPlayer(u: u)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func setupMediaPlayer(u: String) {
        mediaPlayer.delegate = self
        mediaPlayer.drawable = movieView
        mediaPlayer.media = VLCMedia(url: URL(string: u)!)
        mediaPlayer.play()
    }
}
extension VideoViewController: VLCMediaPlayerDelegate {

    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        if mediaPlayer.state == .stopped {
//            self.dismiss(animated: true, completion: nil)
        }
    }
}
