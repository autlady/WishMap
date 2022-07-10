//
//  MainTabBarController.swift
//  WishMap
//
//  Created by  Юлия Григорьева on 04.07.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapBarView()

        let photosVC = PhotosCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())

        viewControllers = [
            generateNavigationController(rootViewController: photosVC, title: "Photos", image: #imageLiteral(resourceName: "eog")),
            generateNavigationController(rootViewController: WishMapViewController(), title: "WishMap", image: #imageLiteral(resourceName: "moon"))]
    }

    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }

    private func setupTapBarView() {
        self.tabBar.backgroundColor = UIColor(named: "Color4")
        self.tabBar.barTintColor = UIColor(named: "Color4")
        self.tabBar.unselectedItemTintColor = .gray
        self.tabBar.layer.cornerRadius = 40
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.tabBar.layer.masksToBounds = true

}
}
