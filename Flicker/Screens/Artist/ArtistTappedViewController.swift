//
//  ArtistTappedView.swift
//  Flicker
//
//  Created by Jisu Jang on 2022/10/29.
//
import SkeletonView
import UIKit
import Then
import SnapKit

final class ArtistTappedViewController: BaseViewController {

    lazy var artist: Artist = defaultArtistInfo

    private let networkManager = NetworkManager.shared

    private let defaultArtistInfo: Artist = Artist(regions: [], camera: "", lens: "", tags: [], detailDescription: "", portfolioImageUrls: [], userInfo: [:])

    private var imageList: [UIImage] = [UIImage(), UIImage(), UIImage()]

    private var isDownLoaded: Bool = false

    private var profileImage: UIImage = UIImage()

    private var headerHeight: Int = 750

    private lazy var portfolioFlowLayout = UICollectionViewFlowLayout().then {
        let imageWidth = (UIScreen.main.bounds.width - 50)/3
        $0.itemSize = CGSize(width: imageWidth , height: imageWidth)
        $0.minimumLineSpacing = 5
        $0.minimumInteritemSpacing = 1
        $0.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(headerHeight))
    }

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: portfolioFlowLayout).then {
        $0.register(ArtistPortfolioCell.self, forCellWithReuseIdentifier: ArtistPortfolioCell.className)

        $0.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.className)
        $0.contentInsetAdjustmentBehavior = .never
        $0.isSkeletonable = true
        $0.skeletonCornerRadius = 5
    }

    private let bottomBackgroundView = {
        let UIView = UIView()
        UIView.backgroundColor = .white
        UIView.isSkeletonable = true
        return UIView
    }()
    
    private lazy var counselingButton = UIButton().then {
        $0.setTitle("문의하기", for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout, weight: .black)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .mainPink
        $0.layer.cornerRadius = 15
        $0.isSkeletonable = true
        $0.skeletonCornerRadius = 15
        $0.addTarget(self, action: #selector(didTapCounselingButton), for: .touchUpInside)
    }

    private let mutualPayLabel = UILabel().makeBasicLabel(labelText: "상호 페이", textColor: .textSubBlack.withAlphaComponent(0.9), fontStyle: .title3, fontWeight: .bold).then {
        $0.skeletonCornerRadius = 5
    }

    private let statusBarBackGroundView = UIView().then {
        $0.backgroundColor = .white
    }

    private let navigationBarSeperator = UIView().then {
        $0.backgroundColor = .systemGray5
    }

    private let bottomBarSeperator = UIView().then {
        $0.backgroundColor = .systemGray5
    }

    private lazy var backButton = BackButton().then {
        $0.frame.size.width = 30
        $0.frame.size.height = 30
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .white.withAlphaComponent(0.7)
        $0.addTarget(self, action: #selector(didTapCustomBackButton), for: .touchUpInside)
    }

    override func viewDidLoad() {
        render()
        configUI()
        setDelegateAndDataSource()

        Task {
            await fetchImages()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                self.showSkeletonView()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupBackButton()
        setupNavigationBar()
        tabBarController?.tabBar.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            self.showSkeletonView()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.backgroundColor = .clear
        tabBarController?.tabBar.isHidden = false
    }
    // MARK: 추후 다른 뷰와 연결시 불필요하다고 판단되면 삭제 예정 (일단 주석)
    //    override func viewDidDisappear(_ animated: Bool) {
    //        super.viewDidDisappear(animated)
    //        statusBarBackGroundView.isHidden = true
    //        navigationBarSeperator.isHidden = true
    //        navigationController?.navigationBar.backgroundColor = .clear
    //    }

    override func configUI() {
        tabBarController?.tabBar.isHidden = true
        statusBarBackGroundView.isHidden = true
        navigationBarSeperator.isHidden = true

        mutualPayLabel.linesCornerRadius = 10
        mutualPayLabel.skeletonTextLineHeight = SkeletonTextLineHeight.fixed(30)
    }

    override func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }

    override func setupBackButton() {
        let leftOffsetBackButton = removeBarButtonItemOffset(with: backButton, offsetX: 0)
        let backButton = makeBarButtonItem(with: leftOffsetBackButton)
        navigationItem.leftBarButtonItem = backButton
    }

    private func showSkeletonView() {
        if !isDownLoaded {
            let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)

            self.collectionView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.gray001, .lightGray]), animation: skeletonAnimation, transition: .none)

            self.bottomBackgroundView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.gray001, .lightGray]), animation: skeletonAnimation, transition: .none)
        }
    }

    private func stopSkeleton(with views: [UIView]) {
        for view in views {
            view.stopSkeletonAnimation()
            view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
        }
    }

    private func setDelegateAndDataSource() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
    }

    private func fetchImages() async {
        do {
            self.imageList = try await networkManager.fetchImages(withURLs: artist.portfolioImageUrls)
            self.profileImage = try await networkManager.fetchOneImage(withURL: artist.userInfo["userProfileImageUrl"] ?? "")
            isDownLoaded = true
            self.collectionView.reloadData()
            self.collectionView.performBatchUpdates {
                self.resetHeaderViewSize()
                self.stopSkeleton(with: [collectionView, bottomBackgroundView])
            }
        } catch {
            print(error)
        }
    }

    private func resetNavigationBarBackground() {
        if collectionView.contentOffset.y > 280 {
            navigationController?.navigationBar.backgroundColor = .white
            statusBarBackGroundView.isHidden = false
            navigationBarSeperator.isHidden = false
        } else {
            navigationController?.navigationBar.backgroundColor = .clear
            statusBarBackGroundView.isHidden = true
            navigationBarSeperator.isHidden = true
        }
    }

    private func resetHeaderViewSize() {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(headerHeight))
        self.collectionView.collectionViewLayout = layout
    }

    override func render() {

        view.addSubviews(collectionView, statusBarBackGroundView, navigationBarSeperator, bottomBackgroundView, counselingButton, bottomBarSeperator)

        for subview in view.subviews {
            subview.isSkeletonable = true
        }

        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom).inset(view.frame.height / 10)
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
        }

        statusBarBackGroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }

        navigationBarSeperator.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }

        navigationBarSeperator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true

        // 하단의 문의하기 버튼이 있는 UIView
        bottomBackgroundView.addSubviews(counselingButton, mutualPayLabel)

        for subview in bottomBackgroundView.subviews {
            subview.isSkeletonable = true
        }

        bottomBackgroundView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(view.frame.height / 10)
            $0.width.equalToSuperview()
        }

        counselingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(10)
            $0.height.equalTo(view.frame.height / 18)
            $0.width.equalTo(view.frame.width / 2.2)
        }

        mutualPayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(40)
            $0.centerY.equalTo(counselingButton)
        }

        bottomBarSeperator.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalTo(bottomBackgroundView.snp.top)
        }
    }
    
    @objc func didTapCounselingButton() {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else { return }
        let viewController = ChatViewController(name: artist.userInfo["userName"]!, fromId: userId, toId: artist.userInfo["userId"]!)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ArtistTappedViewController: UICollectionViewDataSource {

    // numberOfCell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }

    // ReusableCell setting + image loading
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistPortfolioCell.className, for: indexPath) as! ArtistPortfolioCell
        // 이미지 URL을 가진 response 배열
        cell.isSkeletonable = true
        let image = imageList[indexPath.item]
        cell.image = image
        return cell
    }

    // dequeheaderView, set headerHeight
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.className, for: indexPath) as! HeaderCollectionReusableView
        headerHeight = Int(headerView.getTotalViewHeight())

        let thumnailImages = Array(imageList.prefix(4))

        headerView.isSkeletonable = true
        headerView.resetProfileImage(with: profileImage)
        headerView.resetPortfolioImage(with: thumnailImages)
        headerView.resetArtistInfo(with: artist)
        return headerView
    }
}

extension ArtistTappedViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ArtistPortfolioCell
        let viewController = ImageViewController()
        viewController.image = cell.imageView.image
        viewController.modalPresentationStyle = .fullScreen
        // MARK: 추후 다른 뷰와 연결시 불필요하다고 판단되면 삭제 예정 (일단 주석)
        //        viewController.completion = {
        //            self.resetNavigationBarBackground()
        //            self.tabBarController?.tabBar.isHidden = true
        //        }
        present(viewController, animated: false)
    }
    // 스크롤시 네비게이션바 커스텀화
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        resetNavigationBarBackground()
    }
}

extension ArtistTappedViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 20, bottom: 0, right: 20)
    }
}

extension ArtistTappedViewController {
    @objc func didTapCustomBackButton() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }
}


//        //TODO: 공유하기 기능으로 출시 후 업데이트 예정
//        let shareImageView = UIImageView().then {
//            $0.image = UIImage(systemName: "square.and.arrow.up")
//            $0.frame = .init(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 24, height: 24))
//            $0.tintColor = .black
//            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapShare(_:))))
//        }
//        navigationItem.rightBarButtonItem = makeBarButtonItem(with: shareImageView)

//TODO: 출시 후, 앱스토어 링크 넣을 예정
//    @objc private func didTapShare(_ sender: Any) {
//        guard let image = UIImage(named: "AppIcon") else { return }
//        let descriptionText = "나에게 맞는 작가님을 찾아 인생샷을 건져보세요"
//        let activityViewController = UIActivityViewController(activityItems: [image, descriptionText], applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view
//        self.present(activityViewController, animated: true, completion: nil)
//    }
