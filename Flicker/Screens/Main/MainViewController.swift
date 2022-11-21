//
//  MainViewController.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

import FirebaseFirestore
import SkeletonView
import SnapKit
import Then

final class MainViewController: BaseViewController {
    
    private enum Size {
        static let collectionHorizontalSpacing: CGFloat = 20.0
        static let collectionVerticalSpacing: CGFloat = 0.0
        static let cellWidth: CGFloat = UIScreen.main.bounds.size.width - collectionHorizontalSpacing * 2
        static let cellHeight: CGFloat = 300
        static let collectionInset = UIEdgeInsets(top: collectionVerticalSpacing,
                                                  left: collectionHorizontalSpacing,
                                                  bottom: collectionVerticalSpacing,
                                                  right: collectionHorizontalSpacing)
    }
    
    private var selectedRegions: [String] = ["전체"]
    private var artists = [Artist]()
    
    private var cursor: DocumentSnapshot?
    private var dataMayContinue = true
    
    // MARK: - property
    
    private let appTitleLabel = UILabel().then {
        $0.font = UIFont(name: "TsukimiRounded-Bold", size: 30)
        $0.textColor = .mainPink
        $0.textAlignment = .center
        $0.text = "SHUGGLE"
    }
    
    private lazy var regionTagButton = UIButton().then {
        $0.tintColor = .mainPink
        $0.setTitle("전체 ", for: .normal)
        $0.setTitleColor(.mainBlack.withAlphaComponent(0.7), for: .normal)
        $0.titleLabel?.font = .preferredFont(forTextStyle: .body, weight: .semibold)
        $0.setImage(ImageLiteral.btnDown, for: .normal)
        $0.semanticContentAttribute = .forceRightToLeft
        $0.addTarget(self, action: #selector(didTapRegionTag), for: .touchUpInside)
    }
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.sectionInset = Size.collectionInset
        $0.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        $0.minimumLineSpacing = 20
    }
    
    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.register(ArtistThumnailCollectionViewCell.self, forCellWithReuseIdentifier: ArtistThumnailCollectionViewCell.className)
        $0.isSkeletonable = true
    }
    
    private let emptyThumnailView = EmptyThumnailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRegion()
        loadData()
        
        navigationController?.isNavigationBarHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.realoadTable(_:)), name: Notification.Name("willDissmiss"), object: nil)
    }
    
    override func render() {
        view.addSubviews(appTitleLabel, regionTagButton, listCollectionView, emptyThumnailView)
        
        appTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        regionTagButton.snp.makeConstraints {
            $0.bottom.equalTo(appTitleLabel.snp.bottom).offset(-6)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(appTitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyThumnailView.snp.makeConstraints {
            $0.top.equalTo(appTitleLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - func
    
    private func setRegion() {
        guard let regions = UserDefaults.standard.stringArray(forKey: "regions") else { return }
        selectedRegions = regions
        
        if selectedRegions.isEmpty {
            selectedRegions = ["전체"]
        }
        let count = selectedRegions.count == 1 ? "" : "외 \(selectedRegions.count-1)곳"
        regionTagButton.setTitle("\(selectedRegions[0]) \(count) ", for: .normal)
    }
    
    private func loadData() {
        emptyThumnailView.isHidden = true
        cursor = nil
        dataMayContinue = true
        artists = [Artist]()
        listCollectionView.reloadData()
        
        let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        listCollectionView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.gray001, .gray002]), animation: skeletonAnimation, transition: .none)
        
        Task {
            if let result = await FirebaseManager.shared.loadArtist(regions: selectedRegions) {
                self.artists = result.artists
                self.cursor = result.cursor
                
                if self.artists.isEmpty {
                    self.emptyThumnailView.isHidden = false
                }
            }
            
            DispatchQueue.main.async {
                self.listCollectionView.stopSkeletonAnimation()
                self.listCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
            }
        }
    }
    
    private func continueData() {
        guard dataMayContinue, let cursor = cursor else { return }
        
        Task {
            if let result = await FirebaseManager.shared.continueArtist(regions: selectedRegions, cursor: cursor) {
                self.artists += result.artists
                self.cursor = result.cursor
            }
            
            DispatchQueue.main.async {
                self.listCollectionView.reloadData()
            }
            
            dataMayContinue = false
        }
    }
    
    @objc func realoadTable(_ noti: Notification) {
        listCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        setRegion()
        loadData()
    }
    
    @objc private func didTapRegionTag() {
        let vc = RegionViewController()
        vc.modalPresentationStyle = .pageSheet
        vc.sheetPresentationController?.detents = [.medium()]
        
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource
extension MainViewController: SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        ArtistThumnailCollectionViewCell.className
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistThumnailCollectionViewCell.className, for: indexPath) as? ArtistThumnailCollectionViewCell else {
            assert(false, "Wrong Cell")
        }
        
        let artist = artists[indexPath.item]
        cell.artistNameLabel.text = artist.userInfo["userName"]
        cell.artistTagLabel.text = "#\(artist.tags.joined(separator: "#"))"
        
        Task {
            try await cell.artistThumnailImageView.image = NetworkManager.shared.fetchOneImage(withURL: artist.portfolioImageUrls[0])
            cell.makeBackgroudShadow()
            try await cell.artistProfileImageView.image =  NetworkManager.shared.fetchOneImage(withURL: artist.userInfo["userProfileImageUrl"]!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 터치시 넘어가는 화면 코드 구현 예정
        let artist = artists[indexPath.item] // 선택한 아티스트 데이터
        let vc = ArtistTappedViewController()
        vc.artist = artist
        navigationController?.isNavigationBarHidden = false
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard velocity.y != 0 else { return }
            if velocity.y < 0 {
                let height = self?.tabBarController?.tabBar.frame.height ?? 0.0
                self?.tabBarController?.tabBar.alpha = 1.0
                self?.tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY - height)
            } else {
                self?.tabBarController?.tabBar.alpha = 0.0
                self?.tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY)
            }
        }
    }
}

extension MainViewController {
    /* Standard scroll-view delegate */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize.height
        
        if contentSize - scrollView.contentOffset.y <= scrollView.bounds.height {
            didScrollToBottom()
        }
    }
    
    private func didScrollToBottom() {
        continueData()
    }
}
