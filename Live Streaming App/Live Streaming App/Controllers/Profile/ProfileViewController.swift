//
//  ProfileViewController.swift
//  Live Streaming App
//
//  Created by Sudayn on 5/4/2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var followingLbl: UILabel!
    @IBOutlet weak var followerLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialise()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = AppModel.shared.currentUser {
            AppModel.shared.getProfile(id: user.uid, completion: {u in
                self.followerLbl.text = "\(u.followers?.count ?? 0)"
                self.followingLbl.text = "\(u.following?.count ?? 0)"
            })
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

    
    func initialise() {
        if let user = AppModel.shared.currentUser {
            usernameLabel.text = user.username
            if let img = user.profileImg, let url = URL(string: img) {
                downloadImage(from: url)
            }
        } else {
            AppModel.shared.logout()
        }
        
    }
    
    @IBAction func onLogout(_ sender: Any) {
        AppModel.shared.logout()
    }
    
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("Size for item ")
        let paddingSpace = sectionInset.left * (3 + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / 3
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as? ProfileCollectionViewCell {
            cell.imgView.image = UIImage(named: "Profile")
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    
}
