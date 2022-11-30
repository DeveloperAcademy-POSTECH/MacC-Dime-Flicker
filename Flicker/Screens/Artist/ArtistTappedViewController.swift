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
import MessageUI

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

    private lazy var reportButton = ReportButton().then {
        $0.frame.size.width = 30
        $0.frame.size.height = 30
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .white.withAlphaComponent(0.7)
        $0.addTarget(self, action: #selector(didTapReportButton), for: .touchUpInside)
    }

    // view life cycle
    override func viewDidLoad() {
        render()
        configUI()
        setDelegateAndDataSource()
        setupRightNavigationBarItem(with: reportButton)

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

    // configuration about view UI
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
    
    private func setDelegateAndDataSource() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
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

    // set skeletonView
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

    // get images from server
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

    // set layout
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

        // fixed bottomView with counseling button
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
}

extension ArtistTappedViewController: UICollectionViewDataSource {

    // set number of cells according to images
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }

    // set reusable cell and its image
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistPortfolioCell.className, for: indexPath) as! ArtistPortfolioCell
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

        present(viewController, animated: false)
    }
    
    // set NavigationBar while scrolling
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
    
    // fuctions to call for button
    @objc func didTapCustomBackButton() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.popViewController(animated: true)
    }

    @objc func didTapCounselingButton() {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else { return }
        let viewController = ChatViewController(name: artist.userInfo["userName"]!, fromId: userId, toId: artist.userInfo["userId"]!)
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc func didTapReportButton() {
        let recheckAlert = UIAlertController(title: "신고하시겠어요?", message: "이 게시글을 신고하시게 된 사유에 대해서 자세히 말씀해주세요.", preferredStyle: .actionSheet)
        let confirm = UIAlertAction(title: "신고", style: .default) { _ in
            self.sendReportMail(userName: UserDefaults.standard.string(forKey: "userName"), reportType: .reportAnotherUser)
        }
        let cancel = UIAlertAction(title: "취소", style: .destructive, handler: nil)

        recheckAlert.addAction(confirm)
        recheckAlert.addAction(cancel)
        present(recheckAlert, animated: true, completion: nil)
    }
}

extension ArtistTappedViewController: MFMailComposeViewControllerDelegate {

    func sendReportMail(userName: String?, reportType: ReportType) {
        if MFMailComposeViewController.canSendMail() {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let currentDateString = formatter.string(from: Date())
            let composeViewController = MFMailComposeViewController()
            let dimeEmail = "haptic_04_minis@icloud.com"

            let messageBody = """
                                   -----------------------------
                                   - 신고자: \(String(describing: userName ?? "UNKNOWN"))
                                   - 일시: \(currentDateString)
                                   ------------------------------
                                   - 신고 사유 (상대의 이름, 왜 신고하시는지)




                                   """
            composeViewController.mailComposeDelegate = self
            composeViewController.setToRecipients([dimeEmail])
            composeViewController.setSubject("")
            composeViewController.setMessageBody(messageBody, isHTML: false)
            self.present(composeViewController, animated: true, completion: nil)
        }
        else {
            showSendMailErrorAlert()
        }
    }

    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) {
            (action) in
            print("확인")
        }
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
//TODO: 공유하기 기능으로 출시 후 업데이트 예정
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
