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
        static let collectionInset = UIEdgeInsets(top: 0,
                                                  left: collectionHorizontalSpacing,
                                                  bottom: collectionVerticalSpacing,
                                                  right: collectionHorizontalSpacing)
    }
    
    private var artists = [Artist]()
    private var filteredArtists = [Artist]()
    
    private var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
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
            
            if let result = await FirebaseManager.shared.loadArtist(regions: ["전체"], pages: 20) {
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
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "작가를 검색하세요."
        searchController.searchResultsUpdater = self
        navigationItem.leftBarButtonItem = nil
        navigationItem.titleView = searchController.searchBar
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.isFiltering ? filteredArtists.count : artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumnailCollectionViewCell.className, for: indexPath) as? ThumnailCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let artist = isFiltering ? filteredArtists[indexPath.item] : artists[indexPath.item]
        
        Task {
            try await cell.thumnailImageView.image = NetworkManager.shared.fetchOneImage(withURL: artist.portfolioImageUrls.first ?? "")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let artist = isFiltering ? filteredArtists[indexPath.item] : artists[indexPath.item]
        let vc = ArtistTappedViewController()
        vc.artist = artist
        navigationController?.isNavigationBarHidden = false
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        self.filteredArtists = self.artists.filter { $0.userInfo["userName"]!.lowercased().contains(text) }
        self.listCollectionView.reloadData()
    }
}
