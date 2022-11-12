//
//  ArtistTappedView.swift
//  Flicker
//
//  Created by Jisu Jang on 2022/10/29.
//
import UIKit
import SnapKit

class ArtistTappedViewController: BaseViewController {

    private let networkManager = NetworkManager.shared

    private var posts: [Post] = []

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView( frame: .zero, collectionViewLayout: UICollectionViewLayout())
        let layout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = layout
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()

    private let bottomBackgroundView = {
        let UIView = UIView()
        UIView.backgroundColor = .white
        return UIView
    }()

    private let counselingButton = UIButton().then {
        $0.setTitle("문의하기", for: .normal)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout, weight: .black)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 15
    }

    private let statusBarBackGroundView = UIView().then {
        $0.backgroundColor = .white
    }

    private let navigationBarseperator = UIView().then {
        $0.backgroundColor = .systemGray5
    }
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        collectionView.register(ArtistPortfolioCell.self, forCellWithReuseIdentifier: ArtistPortfolioCell.identifier)

        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)

        setDelegateAndDataSource()
        
        view.addSubviews(collectionView, statusBarBackGroundView, navigationBarseperator, bottomBackgroundView, counselingButton)

        queryImageDataSet()
        configUI()
        setupBackButton()
        setupNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusBarBackGroundView.isHidden = true
        navigationBarseperator.isHidden = true
        navigationController?.navigationBar.backgroundColor = .clear
    }

    override func configUI() {
        tabBarController?.tabBar.isHidden = true
        statusBarBackGroundView.isHidden = true
        navigationBarseperator.isHidden = true
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
    
    override func viewDidLayoutSubviews () {
        super.viewDidLayoutSubviews()
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
            $0.center.equalToSuperview()
            $0.width.equalToSuperview()
        }

        statusBarBackGroundView.translatesAutoresizingMaskIntoConstraints = false

        statusBarBackGroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        statusBarBackGroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true

        statusBarBackGroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

        statusBarBackGroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        statusBarBackGroundView.translatesAutoresizingMaskIntoConstraints = false

        navigationBarseperator.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }

        guard let navigationBar = navigationController?.navigationBar else { return }

        navigationBarseperator.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true


        bottomBackgroundView.addSubview(counselingButton)

        bottomBackgroundView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(view.frame.height / 9)
            $0.width.equalToSuperview()
        }

        counselingButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalToSuperview().inset(20)
        }
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

extension ArtistTappedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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

    // headerView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath)
    }

   //  header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 720)
    }

    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/3) - 3 , height: (collectionView.frame.width/3) - 3 )
    }

    // Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath) as! ArtistPortfolioCell
//        let cellImage = cell.image ?? UIImage(named: "port1")

        let viewController = ImageViewController()
        viewController.image = cell.imageView.image 
        viewController.modalPresentationStyle = .fullScreen

        present(viewController, animated: true)

    }

    // 스크롤시 네비게이션바 커스텀화
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collectionView.contentOffset.y > 280 {
            navigationController?.navigationBar.backgroundColor = .white
            statusBarBackGroundView.isHidden = false
            navigationBarseperator.isHidden = false

        } else {
            navigationController?.navigationBar.backgroundColor = .clear
            statusBarBackGroundView.isHidden = true
            navigationBarseperator.isHidden = true
        }
    }
}
