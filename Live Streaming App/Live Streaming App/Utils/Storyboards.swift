//
//  Storyboards.swift
//  Live Streaming App
//
//  Created by Sudayn on 5/4/2024.
//

import UIKit

class Storyboards {
    static func instantiateViewController<T: UIViewController>(from storyboardName: String, withIdentifier identifier: String) -> T? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as? T
    }
}
