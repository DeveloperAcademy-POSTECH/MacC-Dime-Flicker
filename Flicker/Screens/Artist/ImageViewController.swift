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

    var image: UIImage? = UIImage(named: "RegisterEnd")

    var completion: ()->Void = { }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
    }
    
    private lazy var scrollView = UIScrollView(frame: .zero).then {
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
        $0.zoomScale = 1.0
        $0.minimumZoomScale = 1.0
        $0.maximumZoomScale = 3.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        addGestures()
        render()
    }

    private func configUI() {
        imageView.image = image
        view.backgroundColor = .black
    }
    
    private func render() {
        view.addSubviews(scrollView)
        scrollView.addSubview(imageView)

        scrollView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().inset(5)
            $0.center.equalToSuperview()
        }

        imageView.snp.makeConstraints {
            $0.width.height.equalToSuperview()
            $0.center.equalToSuperview()
        }
    }
    
    private func addGestures() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapImage(_:)))
        doubleTap.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTap)
    }

    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width  = imageView.frame.size.width  / scale
        let newCenter = scrollView.convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}

extension ImageViewController {

    @objc private func didDoubleTapImage(_ sender: UITapGestureRecognizer) {
        let scale = min(scrollView.zoomScale * 2, scrollView.maximumZoomScale)

        if scale != scrollView.zoomScale { // zoom in
            let point = sender.location(in: imageView)

            let scrollSize = scrollView.frame.size
            let size = CGSize(width: scrollSize.width / scrollView.maximumZoomScale,
                              height: scrollSize.height / scrollView.maximumZoomScale)
            let origin = CGPoint(x: point.x - size.width / 2,
                                 y: point.y - size.height / 2)
            scrollView.zoom(to:CGRect(origin: origin, size: size), animated: true)
        } else if scrollView.zoomScale > 1 {
            scrollView.zoom(to: zoomRectForScale(scale: 1, center: sender.location(in: imageView)), animated: true)
        }
    }

}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image = imageView.image {
                let widthRatio = imageView.frame.width / image.size.width
                let heightRatio = imageView.frame.height / image.size.height
                
                let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth * scrollView.zoomScale > imageView.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - imageView.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditioTop = newHeight * scrollView.zoomScale > imageView.frame.height
                
                let top = 0.5 * (conditioTop ? newHeight - imageView.frame.height : (scrollView.frame.height - scrollView.contentSize.height))
                
                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
}
