//
//  ImageViewController.swift
//  Flicker
//
//  Created by Jisu Jang on 2022/11/11.
//
import UIKit

import SnapKit
import Then

final class ImageViewController: UIViewController {

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    var image: UIImage? = UIImage(named: "port1")

    private let cancelImageView = UIImageView().then {
        $0.isUserInteractionEnabled = true
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(systemName: "x.circle.fill")
    }

    var completion: ()->Void = {}

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(imageView, cancelImageView)
        view.backgroundColor = .white
        imageView.image = image
        cancelImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCancelButton(_:))))
        render()
    }

    private func render() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        cancelImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.width.height.equalTo(24)
            $0.trailing.equalToSuperview().inset(20)
        }
    }

    @objc private func didTapCancelButton(_ sender: Any) {
        dismiss(animated: false) { self.completion() }
    }
}
