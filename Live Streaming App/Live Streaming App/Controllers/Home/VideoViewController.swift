//
//  VideoViewController.swift
//  Live Streaming App
//
//  Created by Sudayn on 29/4/2024.
//

import UIKit
//import MobileVLCKit
import HaishinKit
import WebKit


class VideoViewController: UIViewController {
    
    @IBOutlet weak var commentTblView: UITableView!
    @IBOutlet weak var wkView: WKWebView!
    @IBOutlet weak var movieView: UIView!
    var timer: Timer?
    
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var textField: UITextField!
    var comments: [Comment] = []
//    var mediaPlayer = VLCMediaPlayer()
    var url: String?
    var id: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wkView.configuration.allowsInlineMediaPlayback = true
        if let u = url {
            loadHLSStream(url: u)
        }
        if let id = id {
            AppModel.shared.increaseViewCount(streamId: id, completion: {
                
            })
            setupTable()
            startTimer()
        }
    }
    
    deinit {
        if let id = id {
            AppModel.shared.decreaseViewCount(streamId: id, completion: {
                
            })
        }
    }
    
    @IBAction func onSend(_ sender: Any) {
        if let id = id, let user = AppModel.shared.currentUser {
            AppModel.shared.postComment(streamId: id, body: CommentInput(uid: user.uid, comment: textField.text ?? ""), completion: {
                self.textField.text = ""
            })
        }
    }
    
    func loadHLSStream(url: String) {
            print(url)
            guard let url = URL(string: url) else {
                print("Invalid URL")
                return
            }
//        wkView.uiDelegate = self
            let request = URLRequest(url: url)
            wkView.load(request)
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func setupTable() {
        commentTblView.delegate = self
        commentTblView.dataSource = self
        commentTblView.backgroundColor = .black.withAlphaComponent(0.5)
        commentTblView.backgroundView = nil
        commentTblView.transform = CGAffineTransformMakeScale (1,-1);
    }
    
    func startTimer() {
        // Invalidate previous timer to prevent multiple timers running simultaneously
        timer?.invalidate()
        
        // Schedule a new timer to fire every 1 second
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            // Call your fetch function here
            self?.fetchComments()
        }
    }
    
    func stopTimer() {
        // Stop the timer when needed
        timer?.invalidate()
        timer = nil
    }
    
    func fetchComments() {
        AppModel.shared.getComments(streamId: id!, completion: {comments, viewCount in
            print(comments)
            self.comments = comments
            self.countLbl.text = "\(viewCount)"
            self.commentTblView.reloadData()
        })
    }
    

}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCell {
            let comment = self.comments[indexPath.row]
            cell.lbl1.text = "\(comment.postedBy.firstname) \(comment.postedBy.lastname)"
            cell.lbl2.text = comment.comment
            cell.contentView.transform = CGAffineTransformMakeScale (1,-1);
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
//extension VideoViewController: WKUIDelegate {
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//            // Check if the navigation action is to open a new window
//            if navigationAction.targetFrame == nil {
//                // Prevent opening in a new window (e.g., full-screen)
//                decisionHandler(.cancel)
//                return
//            }
//
//            // Allow other navigation actions
//            decisionHandler(.allow)
//        }
//}
