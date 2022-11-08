//
//  ArtistRegisterViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/01.
//

import UIKit
import SnapKit
import Then

    // TODO: (다음 버전에..) 1.전 view에서넘어올때, dissolve 같은 간단한 애니메이션 추가 2.버튼 잠깐이라도 튀어오르는 애니메이션 추가
final class ArtistRegisterViewController: UIViewController {
    
    // MARK: - datas collected to post to the server
    // TODO: 이미지데이터가 delegate 으로 먹히지 않아ㅏㅏㅏㅏㅏㅏㅏ
    private var regionData: [String] = []
    private var cameraBodyData: String = ""
    private var cameraLensData: String = ""
    private var textInfoDatas: String = ""
    private var portfolioImageData: [UIImage] = []
    
    // MARK: - custom navigation bar
    private let customNavigationBarView = RegisterCustomNavigationView()

    // MARK: - pageViewController UI components
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var pages: [UIViewController] = []
    private var currentPage: UIViewController!
    
    private let pageTwoRegion = RegisterRegionViewController()
    private let pageThreeGears = RegisterGearsViewController()
    private let pageFourTextDescription = RegisterTextDescriptionViewController()
    private let pageFivePortpolio = RegisterPortfolioViewController()
    private let pageSixConfirm = RegisterConfirmViewController()
    private let pageSevenEnd = RegisterEndViewController()
    
    // MARK: - action button UI components
    // TODO: 앞의 버튼과 차별점을 두기 위해 약간 튀어오르는 느낌 하나 있으면 좋을 것 같다.
    private let dynamicNextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.tintColor = .black
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        $0.backgroundColor = .mainPink
    }

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pageSetup()
        render()
        configUI()
        nextButtonTap()
        customBackButtom()
    }
    
    // MARK: - navigation bar hide configurations with life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // TODO: ViewController들을 다 넣었다면 이 함수는 discard 해야함
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - layout constraints
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
            $0.height.equalTo(view.bounds.height/12)
        }
    }
    
    // MARK: - view configurations
    private func configUI() {
        view.backgroundColor = .systemBackground
        dynamicNextButton.layer.cornerRadius = view.bounds.width/18
        
        pageTwoRegion.delegate = self
        pageThreeGears.delegate = self
        pageFourTextDescription.delegate = self
    }
    
    // MARK: - pageViewControl setups
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


    // MARK: - data transfer delegates
extension ArtistRegisterViewController: RegisterRegionDelegate, RegisterGearsDelegate, RegisterTextInfoDelegate, RegisterPortfolioDelegate {
    func cameraBodySelected(cameraBody bodyName: String) {
        self.cameraBodyData = bodyName
    }
    
    func cameraLensSelected(cameraLens lensName: String) {
        self.cameraLensData = lensName
    }
    
    func regionSelected(regions regionDatas: [String]) {
        self.regionData = regionDatas
    }
    
    func textViewDescribed(textView textDescribed: String) {
        self.textInfoDatas = textDescribed
    }
    
    func photoSelected(photos imagesPicked: [UIImage]) {
        self.portfolioImageData = imagesPicked
    }
}

    // MARK: - action functions
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
            navigationController?.pushViewController(pageSevenEnd, animated: true)
            print(regionData, cameraBodyData, cameraLensData, textInfoDatas, self.portfolioImageData)
        } else {
            guard let page = pages.firstIndex(of: currentPage) else { return }
            pageViewController.setViewControllers([pages[page + 1]], direction: .forward, animated: true)
            currentPage = pages[page + 1]
            print(regionData, cameraBodyData, cameraLensData, textInfoDatas, self.portfolioImageData.count)
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
