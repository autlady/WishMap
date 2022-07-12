//
//  WishMapCell.swift
//  WishMap
//
//  Created by  Юлия Григорьева on 11.07.2022.
//

import UIKit

class WishMapCell: UICollectionViewCell {

    static let reuseId = "WishMapCell"

    lazy var photoView: UIImageView = {
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.contentMode = .scaleAspectFill
        photo.backgroundColor = .white
        photo.clipsToBounds = true
        photo.layer.cornerRadius = 15
        return photo
    }()

    var unsplashPhoto: UnsplashPhoto! {
        didSet {
            let photoUrl = unsplashPhoto.urls["regular"] // спорный момент, лично для меня
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            photoView.sd_setImage(with: url, completed: nil)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.photoView)

        let topConstraint = self.photoView.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        let leadingConstraint = self.photoView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor)
        let trailingConstraint = self.photoView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        let bottomConstraint = self.photoView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)

        NSLayoutConstraint.activate([topConstraint, leadingConstraint, trailingConstraint, bottomConstraint])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.photoView.image = nil
    }

    func set(photo: UnsplashPhoto) {
        let photoUrl = photo.urls["full"]
        guard let photoURL = photoUrl, let url = URL(string: photoURL) else { return }
        photoView.sd_setImage(with: url, completed: nil)
    }

    
}


