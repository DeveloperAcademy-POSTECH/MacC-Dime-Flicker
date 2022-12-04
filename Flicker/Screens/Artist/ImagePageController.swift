//
//  ImagePageController.swift
//  Flicker
//
//  Created by Jisu Jang on 2022/12/04.
//

import UIKit

class ImagePageController: UIPageViewController {

    var images: [UIImage] = []

    var startingPageIndex: Int = 0

    var subViewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setData()
        setViewControllerFromIndex(index: startingPageIndex)
    }

    private func setData() {
        for image in images {
            let imageViewController = ImageViewController()
            imageViewController.image = image
            subViewControllers.append(imageViewController)
        }
    }

    func setViewControllerFromIndex(index:Int) {
        self.setViewControllers([subViewControllers[index]], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
    }
}

extension ImagePageController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        if currentIndex <= 0 {
            return nil
        }
        return subViewControllers[currentIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        if currentIndex >= subViewControllers.count - 1 {
            return nil
        }
        return subViewControllers[currentIndex + 1]
    }
}

