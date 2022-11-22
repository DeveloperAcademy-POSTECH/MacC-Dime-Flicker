//
//  MainViewController.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

import FirebaseFirestore
import SnapKit
import Then

final class MainViewController: BaseViewController {
    
    private enum Size {
        static let collectionHorizontalSpacing: CGFloat = 20.0
        static let collectionVerticalSpacing: CGFloat = 20.0
        static let cellWidth: CGFloat = UIScreen.main.bounds.size.width - collectionHorizontalSpacing * 2
        static let cellHeight: CGFloat = 300
        static let collectionInset = UIEdgeInsets(top: 0,
                                                  left: collectionHorizontalSpacing,
                                                  bottom: collectionVerticalSpacing,
                                                  right: collectionHorizontalSpacing)
    }
    
    private var refreshControl = UIRefreshControl()
    
    private var selectedRegions: [String] = ["전체"]
    private var artists = [Artist]()
    
    private var cursor: DocumentSnapshot?
    
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
    }
    
    private let emptyThumnailView = EmptyThumnailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    override func render() {
        view.addSubviews(appTitleLabel, regionTagButton, emptyThumnailView, listCollectionView, emptyThumnailView)
        
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
    
    override func configUI() {
        super.configUI()
        
        navigationController?.isNavigationBarHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(realoadTable(_:)), name: Notification.Name("willDissmiss"), object: nil)
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .mainPink
        
        listCollectionView.refreshControl = refreshControl
    }
    
    // MARK: - func
    
    private func setValues() {
        guard let regions = UserDefaults.standard.stringArray(forKey: "regions") else { return }
        selectedRegions = regions
        
        if selectedRegions.isEmpty {
            selectedRegions = ["전체"]
        }
        let count = selectedRegions.count == 1 ? "" : "외 \(selectedRegions.count-1)곳"
        regionTagButton.setTitle("\(selectedRegions[0]) \(count) ", for: .normal)
        
        cursor = nil
    }
    
    private func loadData() {
        Task {
            setValues()
            
            emptyThumnailView.isHidden = true
            
            if let result = await FirebaseManager.shared.loadArtist(regions: selectedRegions, pages: 10) {
                self.artists = result.artists
                self.cursor = result.cursor
            }
            
            if artists.isEmpty {
                emptyThumnailView.isHidden = false
            }
            
            DispatchQueue.main.async {
                self.listCollectionView.reloadData()
            }
        }
    }
    
    private func continueData() {
        guard let cursor = cursor else { return }
        
        Task {
            if let result = await FirebaseManager.shared.continueArtist(regions: selectedRegions, cursor: cursor, pages: 10) {
                self.artists += result.artists
                self.cursor = result.cursor
            }
            
            DispatchQueue.main.async {
                self.listCollectionView.reloadData()
            }
        }
    }
    
    @objc func realoadTable(_ noti: Notification) {
        loadData()
    }
    
    @objc func pullToRefresh() {
        loadData()
        refreshControl.endRefreshing()
    }
    
    @objc private func didTapRegionTag() {
        let vc = RegionViewController()
        vc.modalPresentationStyle = .pageSheet
        vc.sheetPresentationController?.detents = [.medium()]
        
        present(vc, animated: true, completion: nil)
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
            try await cell.artistThumnailImageView.image = NetworkManager.shared.fetchOneImage(withURL: artist.portfolioImageUrls.first ?? "")
            cell.makeBackgroudShadow()
            try await cell.artistProfileImageView.image =  NetworkManager.shared.fetchOneImage(withURL: artist.userInfo["userProfileImageUrl"] ?? "")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 터치시 넘어가는 화면 코드 구현 예정
        let artist = artists[indexPath.item] // 선택한 아티스트 데이터
        let vc = ArtistTappedViewController()
        vc.artist = artist
        navigationController?.pushViewController(vc, animated: true)
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
