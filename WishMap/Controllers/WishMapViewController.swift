//
//  ViewController.swift
//  WishMap
//
//  Created by  Юлия Григорьева on 04.07.2022.
//

import UIKit

class WishMapViewController: UIViewController {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "WISH MAP"
        label.textColor = UIColor(named: "Color1")
        label.font = .boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = self.titleLabel
        view.backgroundColor = UIColor(named: "Color2")
    }


}

