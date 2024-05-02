//
//  HomeViewController.swift
//  Live Streaming App
//
//  Created by Sudayn on 19/4/2024.
//

import UIKit
import AVFoundation
import AVKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var medias: [Media] = []
    let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialiseData()
    }
    
    func initialiseData() {
        AppModel.shared.fetchAllVideos(completion: {data in
            self.medias = data
            self.collectionView.reloadData()
        }, errorHandler: {err in
            print(err)
        })
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medias.count
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let v = Storyboards.instantiateViewController(from: "Main", withIdentifier: "VideoViewController") as? VideoViewController {
//            v.url = self.medias[indexPath.item].url
//            self.navigationController?.present(v, animated: true)
//        }
        
   
            
            let videoURL = URL(string: self.medias[indexPath.item].url)!
            
            let player = AVPlayer(url: videoURL)
            let playerController = AVPlayerViewController()
            playerController.player = player
            
            present(playerController, animated: true) {
                player.play()
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell {
            if let url = URL(string: medias[indexPath.item].url) {
                cell.imageView.image = UIImage(named: "Profile")
//                ImageHelper.thumbnailImage(for: url)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    
}
