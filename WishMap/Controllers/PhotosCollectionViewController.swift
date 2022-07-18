//
//  PhotosCollectionViewController.swift
//  WishMap
//
//  Created by  Юлия Григорьева on 04.07.2022.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {

    var networkDataFetcher = NetworkDataFetcher()
    var networkServiceRandom = NetworkServiceRandom()

    private var timer: Timer?

    private var photos = [UnsplashPhoto]()

    private var selectedImages = [UIImage]()

    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()

    private lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
    }()

    private var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Color1")
        updateNavButtonsState()
        collectionView.backgroundColor = UIColor(named: "Color1")
        setupNavigationBar()
        setupCollectionView()
        setupSearchBar()
        randomFoto()
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist")
    }
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "Color1")
        navBar.standardAppearance = appearance;
        navBar.scrollEdgeAppearance = appearance
    }


    private func updateNavButtonsState(){
        addBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
        actionBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    }

    func refresh() {
        self.selectedImages.removeAll()
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        updateNavButtonsState()
    }


    //MARK: - NavigationItems action

    @objc private func addBarButtonTapped() {
        let selectedPhotos = collectionView.indexPathsForSelectedItems?.reduce([], { (photosss, indexPath) -> [UnsplashPhoto] in
            var mutablePhotos = photosss
            let photo = photos[indexPath.item]
            mutablePhotos.append(photo)
            return mutablePhotos
        })

        let alertController = UIAlertController(title: "", message: "\(selectedPhotos!.count) фото будут добавлены в Карту желаний", preferredStyle: .alert)
        let add = UIAlertAction(title: "Добавить", style: .default) { (action) in
            let tabbar = self.tabBarController as! MainTabBarController
            let navVC = tabbar.viewControllers?[1] as! UINavigationController
            let likesVC = navVC.topViewController as! WishMapViewController

            likesVC.photos.append(contentsOf: selectedPhotos ?? [])
            likesVC.photosCollection.reloadData()

            self.refresh()
        }
        let cancel = UIAlertAction(title: "Отменить", style: .cancel) { (action) in
        }
        alertController.addAction(add)
        alertController.addAction(cancel)
        present(alertController, animated: true)

    }

    @objc private func actionBarButtonTapped(sender: UIBarButtonItem) {
        let shareController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)

        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                self.refresh()
            }
        }

        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)

        }
    //MARK: - Setup UI Elements

    private func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseId)

        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
    }

    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "PHOTOS"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = UIColor(named: "Color3")
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        navigationItem.rightBarButtonItems = [actionBarButtonItem, addBarButtonItem]
    }

    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.backgroundColor = UIColor(named: "Color3")
        navigationItem.hidesSearchBarWhenScrolling = false

    }
    private func randomFoto() {
        self.networkServiceRandom.fetchRandomImages { searchRandom in
            guard let fetchedPhotos = searchRandom else { return }
            self.photos = fetchedPhotos
            self.collectionView.reloadData()
        }
    }


    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseId, for: indexPath) as! PhotosCell

        cell.unsplashPhoto = photos[indexPath.item]
//
//        self.networkDataFetcher.fetchRandomImages() { [weak self] (searchResults) in
//            guard let fetchedPhotos = searchResults else { return }
//            self?.photos = fetchedPhotos.results
//            self?.collectionView.reloadData()
//        }

        return cell

    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateNavButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        guard let image = cell.photoImageView.image else { return }
            selectedImages.append(image)

    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNavButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        guard let image = cell.photoImageView.image else { return }
        if let index = selectedImages.firstIndex(of: image) {
            selectedImages.remove(at: index)
        }
    }
}

    //MARK: - UISearchBarDelegate

extension PhotosCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self] (searchResults) in
                guard let fetchedPhotos = searchResults else { return }
                self?.photos = fetchedPhotos.results
                self?.collectionView.reloadData()
                self?.refresh()
                }

        })
    }
}


//MARK: - UICollectionViewDelegateFlowLayout

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        return CGSize(width: widthPerItem, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}
