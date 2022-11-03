//
//  ArtistRegisterViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/01.
//

import UIKit
import SnapKit
import Then

final class ArtistRegisterViewController: UIViewController {

    private var pageNumber = 0
    private let pageTwoRegion = RegisterRegionViewController()
    private let pageThreeGears = RegisterGearsViewController()
    private let pageFourTextDescription = RegisterTextDescriptionViewController()
    private let pageFivePortpolio = RegisterPortfolioViewController()
    private let pageSixConfirm = RegisterConfirmViewController()
    private let pageSevenEnd = RegisterEndViewController()
    
    private let dynamicNextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.tintColor = .black
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        $0.backgroundColor = .systemPink
    }

    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var pages: [UIViewController] = []
    private var currentPage: UIViewController!
    private let customNavigationBarView = RegisterCustomNavigationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        pageSetup()
        render()
        configUI()
        nextButtonTap()
        customBackButtom()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // TODO: ViewController들을 다 넣었다면 이 함수는 discard 해야함
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func render() {
        addChild(pageViewController)
        view.addSubview(customNavigationBarView)
        view.addSubview(pageViewController.view)
        view.addSubview(dynamicNextButton)
        
        customNavigationBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(view.bounds.height/16)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(customNavigationBarView.snp.bottom).offset(UIScreen.main.bounds.height/20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.dynamicNextButton.snp.top).offset(-20)
        }
    
        dynamicNextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(UIScreen.main.bounds.height/13)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(view.bounds.height/14)
        }
    }
    
    private func configUI() {
        view.backgroundColor = .systemBackground
        dynamicNextButton.layer.cornerRadius = view.bounds.width/18
    }
    
    private func pageSetup() {
        
        pages.append(pageTwoRegion)
        pages.append(pageThreeGears)
        pages.append(pageFourTextDescription)
        pages.append(pageFivePortpolio)
        pages.append(pageSixConfirm)
        
        guard let firstPage = pages.first else { return }
        currentPage = firstPage
        
        pageViewController.didMove(toParent: self)
        pageViewController.setViewControllers([pages.first!], direction: .forward, animated: false)
        
        guard let firstPage = pages.first else { return }
        currentPage = firstPage
    }
}

extension ArtistRegisterViewController {
    private func nextButtonTap() {
        let buttonTapped = UITapGestureRecognizer(target: self, action: #selector(moveNextTapped))
        dynamicNextButton.addGestureRecognizer(buttonTapped)
    }
    
    private func customBackButtom() {
        let backButtonTapped = UITapGestureRecognizer(target: self, action: #selector(moveBackTapped))
        customNavigationBarView.customBackButton.addGestureRecognizer(backButtonTapped)
    }
    
    @objc func moveNextTapped() {
        if currentPage == pages[4] {
            navigationController?.pushViewController(RegisterEndViewController(), animated: true)
        } else {
            guard let page = pages.firstIndex(of: currentPage) else { return }
            pageViewController.setViewControllers([pages[page + 1]], direction: .forward, animated: true)
            currentPage = pages[page + 1]
        }
    }
    
    @objc func moveBackTapped() {
        if currentPage == pages[0] {
            navigationController?.popViewController(animated: false)
        } else {
            guard let page = pages.firstIndex(of: currentPage) else { return }
            pageViewController.setViewControllers([pages[page - 1]], direction: .reverse, animated: true)
            currentPage = pages[page - 1]
        }
    }
    
}
