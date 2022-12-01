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
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
    }
    
    var pageIndex: Int = 0
    
    private var imageScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
    }
    
    var image: UIImage? = UIImage(named: "port1")
    
    var images: [UIImage] = []
    
    private let cancelImageView = UIImageView().then {
        $0.isUserInteractionEnabled = true
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(systemName: "x.circle.fill")
    }
    
    var completion: ()->Void = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        imageView.image = image
        addGestures()
        render()
        configureImageScrollView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureImageScrollView()
    }
    
    private func render() {
        view.addSubviews(imageScrollView, cancelImageView)
        
        imageScrollView.addSubview(imageView)
        
        imageScrollView.snp.makeConstraints {
            $0.width.height.equalToSuperview()
        }
//
//        imageView.snp.makeConstraints {
//            $0.width.height.equalToSuperview()
//        }
        
        cancelImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.width.height.equalTo(28)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    // configure horizontal scroll of images
    private func configureImageScrollView() {
        imageScrollView.contentSize.width = view.frame.width * CGFloat(images.count)

        for pageIndex in 0..<images.count {
            let imageView = UIImageView()
            let xPositionOrigin = view.frame.width * CGFloat(pageIndex)
            imageView.frame = CGRect(x: xPositionOrigin, y: 0, width: view.bounds.width, height: view.bounds.height)
            imageView.backgroundColor = .black
            imageView.image = images[pageIndex]
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            imageScrollView.addSubview(imageView)
        }
        
        let startingPoint = CGPoint(x: view.frame.width * CGFloat(pageIndex), y: 0)
        
        imageScrollView.setContentOffset(startingPoint, animated: false)
    }
    
    private func addGestures() {
        cancelImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCancelButton(_:))))
    }
    
    @objc private func didTapCancelButton(_ sender: Any) {
        dismiss(animated: false) { self.completion() }
    }
}
