//
//  ArtistTappedView.swift
//  Flicker
//
//  Created by Jisu Jang on 2022/10/29.
//
import UIKit
import Then
import SnapKit

class ArtistTappedViewController: BaseViewController {

    private let networkManager = NetworkManager.shared

    private var posts: [Post] = []

    private var headerHeight: Int = 700

    private lazy var portfolioFlowLayout = UICollectionViewFlowLayout().then {
        let imageWidth = (UIScreen.main.bounds.width - 50)/3
        $0.itemSize = CGSize(width: imageWidth , height: imageWidth)
        $0.minimumLineSpacing = 5
        $0.minimumInteritemSpacing = 5
        $0.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(headerHeight))
    }

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: portfolioFlowLayout).then { $0.contentInsetAdjustmentBehavior = .never
    }

    private let bottomBackgroundView = {
        let UIView = UIView()
        UIView.backgroundColor = .white
        return UIView
    }()

    private let counselingButton = UIButton().then {
        $0.setTitle("문의하기", for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout, weight: .black)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .mainPink
        $0.layer.cornerRadius = 15
    }
        
    private let mutualPayLabel = UILabel().makeBasicLabel(labelText: "상호 페이", textColor: .textSubBlack.withAlphaComponent(0.9), fontStyle: .title3, fontWeight: .bold)

    private let statusBarBackGroundView = UIView().then {
        $0.backgroundColor = .white
    }

    private let navigationBarSeperator = UIView().then {
        $0.backgroundColor = .systemGray5
    }
    
    private let bottomBarSeperator = UIView().then {
        $0.backgroundColor = .systemGray5
    }
    
    override func viewDidLoad() {
        collectionView.register(ArtistPortfolioCell.self, forCellWithReuseIdentifier: ArtistPortfolioCell.identifier)

        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)

        setDelegateAndDataSource()
        
        view.addSubviews(collectionView, statusBarBackGroundView, navigationBarSeperator, bottomBackgroundView, counselingButton, bottomBarSeperator)

        queryImageDataSet()
        configUI()
        setupBackButton()
        setupNavigationBar()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        statusBarBackGroundView.isHidden = true
        navigationBarSeperator.isHidden = true
        navigationController?.navigationBar.backgroundColor = .clear
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetHeaderViewSize()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.backgroundColor = .clear
    }

    override func configUI() {
        tabBarController?.tabBar.isHidden = true
        statusBarBackGroundView.isHidden = true
        navigationBarSeperator.isHidden = true
    }

    override func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance

        //        //TODO: 공유하기 기능으로 출시 후 업데이트 예정
        //        let shareImageView = UIImageView().then {
        //            $0.image = UIImage(systemName: "square.and.arrow.up")
        //            $0.frame = .init(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 24, height: 24))
        //            $0.tintColor = .black
        //            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapShare(_:))))
        //        }
        //        navigationItem.rightBarButtonItem = makeBarButtonItem(with: shareImageView)
    }

    //TODO: 출시 후, 앱스토어 링크 넣을 예정
    //    @objc private func didTapShare(_ sender: Any) {
    //        guard let image = UIImage(named: "AppIcon") else { return }
    //        let descriptionText = "나에게 맞는 작가님을 찾아 인생샷을 건져보세요"
    //        let activityViewController = UIActivityViewController(activityItems: [image, descriptionText], applicationActivities: nil)
    //        activityViewController.popoverPresentationController?.sourceView = self.view
    //        self.present(activityViewController, animated: true, completion: nil)
    //    }

    private func setDelegateAndDataSource() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
    }

    private func resetHeaderViewSize() {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: CGFloat(headerHeight))
        self.collectionView.collectionViewLayout = layout
    }
    
    override func viewDidLayoutSubviews () {
        super.viewDidLayoutSubviews()
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        // navigationBar 상단의 statusBar 자리를 UIView로 대체하여 조정
        statusBarBackGroundView.translatesAutoresizingMaskIntoConstraints = false

        statusBarBackGroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        statusBarBackGroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true

        statusBarBackGroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        statusBarBackGroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        statusBarBackGroundView.translatesAutoresizingMaskIntoConstraints = false

        navigationBarSeperator.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }

        guard let navigationBar = navigationController?.navigationBar else { return }

        navigationBarSeperator.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true

        // 하단의 문의하기 버튼이 있는 UIView
        bottomBackgroundView.addSubviews(counselingButton, mutualPayLabel)

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

    private func getImageData() async throws {
        // ULR 사용해서 request
//        URLSession.shared.dataTask(with: <#T##URLRequest#>)
    }

    private func queryImageDataSet() {
        networkManager.queryDB(query: "cat") { [weak self] posts, error in
            if let error = error {
                print("error occured \(error.localizedDescription)")
                return
            }

            self?.posts = posts!
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

extension ArtistTappedViewController: UICollectionViewDataSource {

    // numberOfCell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    // ReusableCell setting + image loading
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistPortfolioCell.identifier, for: indexPath) as! ArtistPortfolioCell

        // 이미지 URL을 가진 response 배열
        let post = posts[indexPath.item]

        cell.image = nil

        func imageOptionalBind(data: Data?) -> UIImage? {
            if let data = data {
                return UIImage(data: data)
            }
            return UIImage(systemName: "picture")
        }

        networkManager.loadImageCheckingCached(post: post) { data, error  in
            let img = imageOptionalBind(data: data)
            DispatchQueue.main.async {
                cell.image = img
            }
        }
        return cell
    }

    // dequeheaderView, set headerHeight
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath) as! HeaderCollectionReusableView
        headerHeight = Int(headerView.getTotalViewHeight())
        headerView.sizeToFit()
//        resetHeaderViewSize()
        return headerView
    }
}

extension ArtistTappedViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath) as! ArtistPortfolioCell

        let viewController = ImageViewController()
        viewController.image = cell.imageView.image
        viewController.modalPresentationStyle = .fullScreen
        viewController.completion = {
            self.statusBarBackGroundView.isHidden = false
            self.navigationBarSeperator.isHidden = false
        }
        present(viewController, animated: false)
    }

    // 스크롤시 네비게이션바 커스텀화
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
}

extension ArtistTappedViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}
