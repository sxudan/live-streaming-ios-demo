//
//  UserProfileController.swift
//  Live Streaming App
//
//  Created by Sudayn on 10/5/2024.
//

import UIKit

class UserProfileController: UIViewController {
    
    var id: String?

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var followingLbl: UILabel!
    @IBOutlet weak var followerLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var fButton: UIButton!
    var followers: [Connection] = []
    var following: [Connection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let id = id {
            loadUser(id: id)
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.profileImgView.image = UIImage(data: data)
            }
        }
    }
    
    func loadUser(id: String) {
        self.indicator.isHidden = false
        AppModel.shared.getProfile(id: id, completion: {user in
            self.indicator.isHidden = true
            self.nameLbl.text = "\(user.firstname) \(user.lastname)"
            self.followers = user.followers ?? []
            self.following = user.following ?? []
            self.followerLbl.text = "\(user.followers?.count ?? 0)"
            self.followingLbl.text = "\(user.following?.count ?? 0)"
            if let img = user.profileImg, let url = URL(string: img) {
                self.downloadImage(from: url)
            }
            if let me = AppModel.shared.currentUser?.uid {
                let isFollowed = self.followers.first(where: {c in
                    return c.followedBy == me
                }) != nil
                if isFollowed {
                    self.fButton.setTitle("Unfollow", for: .normal)
                } else {
                    self.fButton.setTitle("Follow", for: .normal)
                }
            }
        })
    }
    
    @IBAction func follow(_ sender: Any) {
        self.indicator.isHidden = false
        if let me = AppModel.shared.currentUser?.uid, let id = id {
            let isFollowed = followers.first(where: {c in
                return c.followedBy == me
            }) != nil
            if !isFollowed {
                AppModel.shared.followProfile(uid: me, to: id, completion: {
                    self.loadUser(id: id)
                })
            } else {
                AppModel.shared.unfollowProfile(uid: me, to: id, completion: {
                    self.loadUser(id: id)
                })
            }
        } else {
            print("Nil")
        }
    }
    

}
