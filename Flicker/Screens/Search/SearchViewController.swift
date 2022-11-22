//
//  SearchViewController.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

import FirebaseFirestore
import SnapKit
import Then

final class SearchViewController: BaseViewController {
    
    private enum Size {
        static let collectionHorizontalSpacing: CGFloat = 20.0
        static let collectionVerticalSpacing: CGFloat = 20.0
        static let cellWidth: CGFloat = (UIScreen.main.bounds.size.width - collectionHorizontalSpacing * 2 - 10)/3
        static let cellHeight: CGFloat = cellWidth
        static let collectionInset = UIEdgeInsets(top: collectionVerticalSpacing,
                                                  left: collectionHorizontalSpacing,
                                                  bottom: collectionVerticalSpacing,
                                                  right: collectionHorizontalSpacing)
    }
    
    private var artists = [Artist]()
    private var cursor: DocumentSnapshot?

    // MARK: - property

    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.sectionInset = Size.collectionInset
        $0.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        $0.minimumLineSpacing = 5
        $0.minimumInteritemSpacing = 5
    }
    
    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
        $0.register(ThumnailCollectionViewCell.self, forCellWithReuseIdentifier: ThumnailCollectionViewCell.className)
    }
    
    private let emptyThumnailView = EmptyThumnailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    private func loadData() {
        Task {
            cursor = nil
            
            emptyThumnailView.isHidden = true
            
            if let result = await FirebaseManager.shared.loadArtist(regions: ["전체"]) {
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
    
    override func render() {
        view.addSubviews(listCollectionView, emptyThumnailView)
        
        listCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyThumnailView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumnailCollectionViewCell.className, for: indexPath) as? ThumnailCollectionViewCell else {
            assert(false, "Wrong Cell")
        }
        
        let artist = artists[indexPath.item]
        
        Task {
            try await cell.thumnailImageView.image = NetworkManager.shared.fetchOneImage(withURL: artist.portfolioImageUrls.first ?? "")
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
}
