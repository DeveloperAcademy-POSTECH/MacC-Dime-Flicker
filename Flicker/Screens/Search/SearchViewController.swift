//
//  SearchViewController.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/10/24.
//

import UIKit

import SkeletonView
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

    private let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
    
    private var artists = [Artist]()

    private var filteredArtists = [Artist]()
    
    private var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    private var cursor: DocumentSnapshot?

    private var refreshControl = UIRefreshControl()

    private var searchText: String = ""

    private var dataMayContinue = true

    private var pages = 20

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
        $0.isSkeletonable = true
        $0.isUserInteractionEnabled = true
    }
    
    private let emptyThumnailView = EmptyThumnailView()

    private lazy var searchBar = UISearchBar().then {
        $0.placeholder = "작가를 검색하세요."
        $0.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideSearchKeyboard()
        loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func hideSearchKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSearchKeyboard))
        view.addGestureRecognizer(tap)
        listCollectionView.addGestureRecognizer(tap)
        emptyThumnailView.addGestureRecognizer(tap)
    }

    @objc func dismissSearchKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    private func loadData() {
        Task {
            cursor = nil
            
            emptyThumnailView.isHidden = true
            
            if let result = await FirebaseManager.shared.loadArtist(regions: ["전체"], pages: 50) {
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

    private func searchArtists() {
        Task {
            self.listCollectionView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.gray001, .lightGray]), animation: skeletonAnimation, transition: .none)

            emptyThumnailView.isHidden = true

            if let result = await FirebaseManager.shared.searchArtist(with: searchText, pages: pages) {
                self.artists = result.artists
                self.cursor = result.cursor
            }

            if artists.isEmpty {
                emptyThumnailView.isHidden = false
            }

            DispatchQueue.main.async {
                self.listCollectionView.reloadData()
                self.listCollectionView.performBatchUpdates {
                    self.listCollectionView.stopSkeletonAnimation()
                    self.listCollectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }

    private func continueData() {
        guard dataMayContinue, let cursor = cursor else { return }
        dataMayContinue = false

        Task {
            if let result = await FirebaseManager.shared.continueArtistInSearch(with: searchText, cursor: cursor, pages: pages) {
                self.artists += result.artists
                self.cursor = result.cursor
            }

            DispatchQueue.main.async {
                self.listCollectionView.reloadData()
            }

            self.dataMayContinue = true
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

        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = nil
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.isFiltering ? filteredArtists.count : artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumnailCollectionViewCell.className, for: indexPath) as? ThumnailCollectionViewCell else {
            assert(false, "Wrong Cell")
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

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        self.searchArtists()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        self.searchText = text
        self.searchArtists()
        dismissSearchKeyboard()
    }
}

extension SearchViewController {
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
