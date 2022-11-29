//
//  ArtistRegisterViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/01.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SnapKit
import Then

// TODO: (다음 버전에..)
final class ArtistRegisterViewController: UIViewController {
    
    // MARK: - datas collected to post to the server
    private let dataFirebase = FirebaseManager()
    private let userDefaultInfo = UserDefaults.standard.getObjects(forKeys: ["userEmail", "userName", "userProfileImageUrl", "userToken", "userId"])
    
    private lazy var dataSourceToServer = Artist(regions: [], camera: "", lens: "", tags: [], detailDescription: "", portfolioImageUrls: [], userInfo: userDefaultInfo)
    
    // MARK: observer to check whether the async tasks are done
    private var temporaryStrings: [String] = [] {
        didSet {
            if self.temporaryStrings.count == self.temporaryImages.count {
                Task {
                    self.dataSourceToServer.portfolioImageUrls = self.temporaryStrings
                    await self.dataFirebase.storeArtistInformation(self.dataSourceToServer)
                    self.hideLoadingView()
                    self.navigationController?.pushViewController(self.pageSevenEnd, animated: true)
                }
            }
        }
    }
    
    private var temporaryImages: [UIImage] = []
    
    // MARK: - custom navigation bar
    private let customNavigationBarView = RegisterCustomNavigationView()
    
    // MARK: - pageViewController UI components
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var pages: [UIViewController] = []
    private var currentPage: UIViewController!
    
    private let pageTwoRegion = RegisterRegionViewController()
    private let pageThreeGears = RegisterGearsViewController()
    private let pageFourConcepts = RegisterConceptTagViewController()
    private let pageFiveTextDescription = RegisterTextDescriptionViewController()
    private let pageSixPortpolio = RegisterPortfolioViewController()
    private let pageSevenEnd = RegisterConfirmViewController()
    
    // MARK: - action button UI components
    // TODO: 앞의 버튼과 차별점을 두기 위해 약간 튀어오르는 느낌 하나 있으면 좋을 것 같다.
    private let dynamicNextButton = UIButton(type: .system).then {
        $0.setTitle("다음", for: .normal)
        $0.tintColor = .white
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        $0.backgroundColor = .mainPink
    }
    
    // MARK: - loading UI view
    private let loadingView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .black.withAlphaComponent(0.7)
    }
    
    private let spinnerView = UIActivityIndicatorView(style: .large).then {
        $0.stopAnimating()
        $0.color = .mainPink
    }
    
    private let loadingLabel = UILabel().makeBasicLabel(labelText: "등록 중이에요!", textColor: .mainPink.withAlphaComponent(0.8), fontStyle: .headline, fontWeight: .bold).then {
        $0.shadowOffset = CGSize(width: 0.7, height: 0.7)
        $0.layer.shadowRadius = 20
        $0.shadowColor = .black.withAlphaComponent(0.6)
        $0.isHidden = true
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pageSetup()
        render()
        configUI()
        nextButtonTap()
        customBackButtom()
        setupNotification()
    }
    
    // MARK: - navigation bar hide configurations with life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // TODO: ViewController들을 다 넣었다면 이 함수는 discard 해야함
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - layout constraints
    private func render() {
        addChild(pageViewController)
        view.addSubviews(pageViewController.view, customNavigationBarView, dynamicNextButton, loadingView, spinnerView, loadingLabel)
        
        customNavigationBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(view.bounds.height/16)
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(customNavigationBarView.snp.bottom).offset(UIScreen.main.bounds.height/24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.dynamicNextButton.snp.top).offset(-20)
        }
        
        dynamicNextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(UIScreen.main.bounds.height/13)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(view.bounds.height/12)
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        spinnerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        loadingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.spinnerView.snp.bottom).offset(35)
        }
    }
    
    // MARK: - view configurations
    private func configUI() {
        view.backgroundColor = .systemBackground
        dynamicNextButton.layer.cornerRadius = view.bounds.width/18
        
        pageTwoRegion.delegate = self
        pageThreeGears.delegate = self
        pageFourConcepts.delegate = self
        pageFiveTextDescription.delegate = self
        pageSixPortpolio.delegate = self
    }
    
    // MARK: - pageViewControl setups
    private func pageSetup() {
        pages.append(pageTwoRegion)
        pages.append(pageThreeGears)
        pages.append(pageFourConcepts)
        pages.append(pageFiveTextDescription)
        pages.append(pageSixPortpolio)
        
        guard let firstPage = pages.first else { return }
        currentPage = firstPage
        
        pageViewController.didMove(toParent: self)
        pageViewController.setViewControllers([pages.first!], direction: .forward, animated: false)
        
        guard let firstPage = pages.first else { return }
        currentPage = firstPage
    }
    
    // MARK: - notification setups
    private func setupNotification() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            NotificationCenter.default.addObserver(self, selector: #selector(self.moveUpAction(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.moveDownAction(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - action functions
extension ArtistRegisterViewController {
    // MARK: action with layout changes as keyboard goes up and down
    @objc func moveUpAction(_ notification: Notification) {
        let userInfos = notification.userInfo
        guard let keyboardSize = userInfos?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        UIView.animate(withDuration: 2.0, delay: 1.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: .curveEaseIn) {
            self.pageViewController.view.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(self.customNavigationBarView.snp.top)
                $0.bottom.equalToSuperview()
            }
            
            self.dynamicNextButton.snp.remakeConstraints {
                $0.bottom.equalToSuperview().inset(keyboardHeight + 10)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(self.view.bounds.height/12)
            }
        }
    }
    
    @objc func moveDownAction(_ notification: Notification) {
        UIView.animate(withDuration: 0.5) {
            self.pageViewController.view.snp.remakeConstraints {
                $0.top.equalTo(self.customNavigationBarView.snp.bottom).offset(UIScreen.main.bounds.height/24)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(self.dynamicNextButton.snp.top).offset(-20)
            }
            
            self.dynamicNextButton.snp.remakeConstraints {
                $0.bottom.equalToSuperview().inset(UIScreen.main.bounds.height/13)
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.height.equalTo(self.view.bounds.height/12)
            }
        }
    }
    
    private func nextButtonTap() {
        let buttonTapped = UITapGestureRecognizer(target: self, action: #selector(moveNextTapped))
        dynamicNextButton.addGestureRecognizer(buttonTapped)
    }
    
    // MARK: custom navigation bar back button action
    private func customBackButtom() {
        let backButtonTapped = UITapGestureRecognizer(target: self, action: #selector(moveBackTapped))
        customNavigationBarView.customBackButton.addGestureRecognizer(backButtonTapped)
    }
    
    // MARK: alert action with networking *
    private func recheckAlert() {
        let recheckAlert = UIAlertController(title: "등록이 끝나셨나요?", message: "지역과 자기소개, 그리고 사진은 추후에 수정 가능해요!", preferredStyle: .actionSheet)
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            // MARK: Concurrent uploading photos
            for (indexNum, photo) in self.temporaryImages.enumerated() {
                Task {
                    async let urlString = self.dataFirebase.uploadImage(photo: photo, indexNum: indexNum)
                    await self.temporaryStrings.append(urlString)
                    print("Artist is \(self.temporaryStrings)")
                }
            }
            UserDefaults.standard.set(true, forKey: "isArtist")
            // MARK: Intentional delay for uploading the photos
            self.openLoadingView()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        
        recheckAlert.addAction(confirm)
        recheckAlert.addAction(cancel)
        present(recheckAlert, animated: true, completion: nil)
    }
    
    // MARK: uploading Data func (Not UIImages)
    private func sequenceUploadingDatas() async {
        await self.dataFirebase.storeArtistInformation(self.dataSourceToServer)
    }
    
    // MARK: changing loading view status action
    private func openLoadingView() {
        self.loadingView.isHidden = false
        self.spinnerView.startAnimating()
        self.loadingLabel.isHidden = false
    }
    
    private func hideLoadingView() {
        self.loadingView.isHidden = true
        self.spinnerView.stopAnimating()
        self.loadingLabel.isHidden = true
        print("⭐️⭐️⭐️⭐️⭐️⭐️⭐️HIDELOADINGVIEW")
    }
    
    // MARK: moving foward and backward to next pages action
    @objc func moveNextTapped() {
        let regionEmpty = dataSourceToServer.regions.isEmpty
        let bodyEmpty = dataSourceToServer.camera.isEmpty
        let lensEmpty = dataSourceToServer.lens.isEmpty
        let textInfoEmpty = dataSourceToServer.detailDescription.isEmpty
        let photoEmpty = temporaryImages.isEmpty
        guard let page = pages.firstIndex(of: currentPage) else { return }
        
        switch currentPage {
        case pages[0]:
            if regionEmpty {
                makeAlert(title: "지역을 선택해주세요!", message: "최소 하나의 지역을 선택하셔야 해요!")
            } else {
                pageViewController.setViewControllers([pages[page + 1]], direction: .forward, animated: true)
                currentPage = pages[page + 1]
            }
        case pages[1]:
            if (bodyEmpty && lensEmpty) == true {
                makeAlert(title: "바디와 렌즈를 입력해주세요!", message: "주로 사용하시는 카메라 바디와 렌즈에 대해 적어주세요!")
            } else {
                pageViewController.setViewControllers([pages[page + 1]], direction: .forward, animated: true)
                currentPage = pages[page + 1]
            }
        case pages[2]:
            print(self.dataSourceToServer.tags)
            pageViewController.setViewControllers([pages[page + 1]], direction: .forward, animated: true)
            currentPage = pages[page + 1]
            
        case pages[3]:
            print(self.dataSourceToServer.tags)
            if textInfoEmpty {
                makeAlert(title: "어필할 내용을 입력해주세요!", message: "미래의 클라이언트들에게 어필할 내용이에요! 간단하게라도 적어주세요!")
            } else {
                pageViewController.setViewControllers([pages[page + 1]], direction: .forward, animated: true)
                currentPage = pages[page + 1]
            }
        case pages[4]:
            if photoEmpty {
                makeAlert(title: "사진을 올려주세요!", message: "포트폴리오에 올라갈 사진을 선택해주세요!")
            } else {
                recheckAlert()
            }
        default:
            return
        }
    }
    
    @objc func moveBackTapped() {
        if currentPage == pages[0] {
            navigationController?.popViewController(animated: true)
        } else {
            guard let page = pages.firstIndex(of: currentPage) else { return }
            pageViewController.setViewControllers([pages[page - 1]], direction: .reverse, animated: true)
            currentPage = pages[page - 1]
        }
    }
    
    private func tagStringConvert(label: String) -> [String] {
        let array = label.components(separatedBy: "#").filter{ $0 != ""}
        return array
    }
}

// MARK: - data transfer delegates
extension ArtistRegisterViewController: RegisterRegionDelegate, RegisterGearsDelegate,  RegisterConceptTagDelegate, RegisterTextInfoDelegate, RegisterPortfolioDelegate {
    func cameraBodySelected(cameraBody bodyName: String) {
        self.dataSourceToServer.camera = bodyName
    }
    
    func cameraLensSelected(cameraLens lensName: String) {
        self.dataSourceToServer.lens = lensName
    }
    
    func conceptTagDescribed(tagLabel: String) {
        let editedStringArray = tagStringConvert(label: tagLabel)
        if editedStringArray.count > 4 {
            var temporaryArray: [String] = []
            for i in 0...3 {
                temporaryArray.append(editedStringArray[i])
            }
            self.dataSourceToServer.tags = temporaryArray
        } else {
            self.dataSourceToServer.tags = editedStringArray
        }
    }
    
    func regionSelected(regions regionDatas: [String]) {
        self.dataSourceToServer.regions = regionDatas
    }
    
    func textViewDescribed(textView textDescribed: String) {
        self.dataSourceToServer.detailDescription = textDescribed
    }
    
    func photoSelected(photos imagesPicked: [UIImage]) {
        self.temporaryImages = imagesPicked
    }
}
