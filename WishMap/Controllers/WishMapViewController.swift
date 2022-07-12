//
//  ViewController.swift
//  WishMap
//
//  Created by  Юлия Григорьева on 04.07.2022.
//

import UIKit

class WishMapViewController: UIViewController {

    var photos = [UnsplashPhoto]()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "WISH MAP"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var photosCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(named: "Color2")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WishMapCell.self, forCellWithReuseIdentifier: WishMapCell.reuseId)
        return collectionView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = self.titleLabel
        view.backgroundColor = UIColor(named: "Color2")
        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist")
    }
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "Color2")
        navBar.standardAppearance = appearance;
        navBar.scrollEdgeAppearance = appearance
    }
    
    private func layout() {
        view.addSubview(photosCollection)
        NSLayoutConstraint.activate([
            photosCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photosCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            photosCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            photosCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
    // MARK: UICollectionViewDataSource

    extension WishMapViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishMapCell.reuseId, for: indexPath) as! WishMapCell
        cell.backgroundColor = UIColor(named: "Color2")
        let unsplashPhoto = photos[indexPath.item]
        cell.unsplashPhoto = unsplashPhoto

        return cell
    }
}

    //MARK: - UICollectionViewDelegateFlowLayout

    extension WishMapViewController: UICollectionViewDelegateFlowLayout {

        private var sideInset: CGFloat { return 8 }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = (collectionView.bounds.width - sideInset * 4) / 3
            return CGSize(width: width, height: width)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            UIEdgeInsets(top: sideInset, left: sideInset, bottom: sideInset, right: sideInset)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            sideInset
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            sideInset
        }

}

