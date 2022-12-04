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
    
    var startingPageIndex: Int = 0

    private var selectedPage: Int = 0

    private lazy var imageScrollView = UIScrollView().then {
        $0.minimumZoomScale = 1
        $0.maximumZoomScale = 1
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
    }
    
    var images: [UIImage] = []
    
    private let cancelImageView = UIImageView().then {
        $0.isUserInteractionEnabled = true
        $0.tintColor = .white
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(systemName: "x.circle.fill")
    }

    private var scrollViewForZoom = UIScrollView(frame: .zero)
    
    var completion: ()->Void = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addGestures()
        render()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureImageScrollView()
    }
    
    private func render() {
        view.addSubviews(imageScrollView, cancelImageView)
        
        imageScrollView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        
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
            let scrollViewForZoom = UIScrollView().then {
                $0.delegate = self
                $0.zoomScale = 1.0
                $0.minimumZoomScale = 1.0
                $0.maximumZoomScale = 3.0
                $0.showsVerticalScrollIndicator = false
                $0.isScrollEnabled = false
                $0.tag = pageIndex
            }
            let imageView = UIImageView().then {
                $0.image = images[pageIndex]
                $0.backgroundColor = .black
                $0.clipsToBounds = true
                $0.contentMode = .scaleAspectFit
                $0.tag = pageIndex
            }
            let xPositionOrigin = view.frame.width * CGFloat(pageIndex)

            imageScrollView.addSubview(scrollViewForZoom)
            scrollViewForZoom.addSubview(imageView)

            scrollViewForZoom.frame = CGRect(x: xPositionOrigin, y: 0, width: view.bounds.width, height: view.bounds.height)
            imageView.snp.makeConstraints { $0.width.height.equalToSuperview()
                $0.center.equalToSuperview()
            }
        }
        
        let startingPoint = CGPoint(x: view.frame.width * CGFloat(startingPageIndex), y: 0)
        imageScrollView.setContentOffset(startingPoint, animated: false)
        selectedPage = startingPageIndex
    }
    
    private func addGestures() {
        cancelImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCancelButton(_:))))
    }
    
    @objc private func didTapCancelButton(_ sender: Any) {
        dismiss(animated: false) { self.completion() }
    }
}

extension ImageViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == imageScrollView {
            let size = scrollView.contentOffset.x / scrollView.frame.size.width
            guard !(round(size).isNaN || round(size).isInfinite) else { return }
            selectedPage = Int(round(size))
            print(selectedPage)
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        var viewForZoom = UIView()
        if scrollView.tag == self.selectedPage {
            guard let imageView = scrollView.subviews.first else { return nil }
            viewForZoom = imageView
            print("=============")
            print("View For Zoom")
            print("=============")
        } else {
            return nil
        }
        return viewForZoom
    }

//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        if scrollView.tag == self.selectedPage {
//            guard let imageUIView = scrollView.subviews.first else { return }
//            let imageView = imageUIView as! UIImageView
//            if scrollView.zoomScale > 1 {
//                if let image = imageView.image {
//                    let widthRatio = imageView.frame.width / image.size.width
//                    let heightRatio = imageView.frame.height / image.size.height
//
//                    let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
//                    let newWidth = image.size.width * ratio
//                    let newHeight = image.size.height * ratio
//                    let conditionLeft = newWidth * scrollView.zoomScale > imageView.frame.width
//                    let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
//                    let conditioTop = newHeight * scrollView.zoomScale > imageView.frame.height
//
//                    let top = 0.5 * (conditioTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
//
//                    scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
//                }
//            } else {
//                scrollView.contentInset = .zero
//            }
//
//        }
//    }
}
