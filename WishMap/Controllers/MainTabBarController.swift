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
        configurateTabBar()
        setTabBarShape()

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

    private func configurateTabBar() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        self.tabBar.standardAppearance = tabBarAppearance
        self.tabBar.scrollEdgeAppearance = tabBarAppearance

    }


    private func setTabBarShape() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 10

        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnX * 2

        let roundLayer = CAShapeLayer()

        let bezierPath = UIBezierPath(
            roundedRect: CGRect(
                x: positionOnX,
                y: tabBar.bounds.minY - positionOnY,
                width: width,
                height: height
            ),
            cornerRadius: height / 1.7
        )

        roundLayer.path = bezierPath.cgPath
        tabBar.isMultipleTouchEnabled = true
        tabBar.layer.insertSublayer(roundLayer, at: 0)

        roundLayer.fillColor = UIColor.tabBarBackgroundColor?.cgColor

        tabBar.itemWidth = width / 1

        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.7
        tabBar.layer.shadowOffset = .zero
        tabBar.layer.shadowRadius = 20

        tabBar.itemPositioning = .automatic
        self.tabBar.tintColor = .tabBarRegularItemColor
        self.tabBar.unselectedItemTintColor = .tabBarAccentItemColor
    }
}
