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
    
    @IBOutlet weak var tableView: UITableView!
    
    var medias: [Media] = []
    let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialiseData()
    }
    
    func initialiseData() {
        AppModel.shared.fetchAllVideos(completion: {data in
            self.medias = data
            self.tableView.reloadData()
        }, errorHandler: {err in
            print(err)
        })
    }
    
    func formatDateFromTimestamp(timestamp: Int) -> String {
        // Convert timestamp to Date
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        
        // Create a date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Adjust the date format as needed
        
        // Format the date
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medias.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let videoURL = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
//        
        if let v = Storyboards.instantiateViewController(from: "Main", withIdentifier: "VideoViewController") as? VideoViewController {
            let item = self.medias[indexPath.item]
            v.url = self.medias[indexPath.item].url
            if item.status == .Publishing {
//                print("rtsp://192.168.1.100:8554/\(item.streamId)")
                v.url = "http://192.168.1.100:8889/\(item.streamId)"
            } else {
                v.url = item.url
            }
            v.id = item.streamId
            self.navigationController?.present(v, animated: true)
        }
//        if item.status == .Publishing {
//            let videoURL = URL(string: "http://192.168.1.100:8889/\(item.streamId)")
//            let player = AVPlayer(url: videoURL!)
//            let playerController = AVPlayerViewController()
//            playerController.player = player
//            
//            present(playerController, animated: true) {
//                player.play()
//            }
//        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "livevideolistcell", for: indexPath) as? HomeCollectionViewCell {
            cell.imgView.image = UIImage(named: "live")
            let media = self.medias[indexPath.row]
            cell.titleLbl.text = media.postedBy.username
            cell.subtitleLbl.text = formatDateFromTimestamp(timestamp: media.createdAt)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

//extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return medias.count
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        print("Size for item ")
//        let paddingSpace = sectionInset.left * (3 + 1)
//        let availableWidth = collectionView.frame.width - paddingSpace
//        let widthPerItem = availableWidth / 3
//        return CGSize(width: 100, height: 100)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInset
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let v = Storyboards.instantiateViewController(from: "Main", withIdentifier: "VideoViewController") as? VideoViewController {
//            v.url = self.medias[indexPath.item].url
//            self.navigationController?.present(v, animated: true)
//        }
//
//
//
//            let videoURL = URL(string: self.medias[indexPath.item].url)!
//
//            let player = AVPlayer(url: videoURL)
//            let playerController = AVPlayerViewController()
//            playerController.player = player
//
//            present(playerController, animated: true) {
//                player.play()
//            }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell {
//            if let url = URL(string: medias[indexPath.item].url) {
//                cell.imageView.image = UIImage(named: "Profile")
////                ImageHelper.thumbnailImage(for: url)
//            }
//            return cell
//        } else {
//            return UICollectionViewCell()
//        }
//    }
//
//
//}
