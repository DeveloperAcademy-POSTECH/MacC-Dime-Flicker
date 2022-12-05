//
//  ImagePageController.swift
//  Flicker
//
//  Created by Jisu Jang on 2022/12/04.
//

import UIKit

class ImageSliderViewController: UIPageViewController {

    var images: [UIImage] = []

    var startingPageIndex: Int = 0

    var subViewControllers: [UIViewController] = []

    private lazy var backButton = BackButton().then {
        $0.frame.size.width = 30
        $0.frame.size.height = 30
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .white.withAlphaComponent(0.7)
        $0.addTarget(self, action: #selector(didTapCustomBackButton), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setImageSlide()
        setViewControllerFromIndex(index: startingPageIndex)
        configUI()
    }

    private func configUI() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.hidesBackButton = true
    }

    private func setImageSlide() {
        for image in images {
            let imageViewController = ImageViewController()
            imageViewController.image = image
            subViewControllers.append(imageViewController)
        }
    }

    private func setViewControllerFromIndex(index:Int) {
        self.setViewControllers([subViewControllers[index]], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
    }
}

// objc 함수
extension ImageSliderViewController {
    @objc func didTapCustomBackButton() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension ImageSliderViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        if currentIndex <= 0 { return nil }
        return subViewControllers[currentIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        if currentIndex >= subViewControllers.count - 1 { return nil }
        return subViewControllers[currentIndex + 1]
    }
}

