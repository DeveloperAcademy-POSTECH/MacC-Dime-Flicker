//
//  ArtistTappedView.swift
//  Flicker
//
//  Created by Jisu Jang on 2022/10/29.
//
import UIKit
import SnapKit
import Foundation

class ArtistTappedViewController: UIViewController {

    private let networkManager = NetworkManager.shared

    private var posts: [Post] = []

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView( frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
    
    override func viewDidLoad() {
        super.viewDidLoad ()
        collectionView.register(ArtistPortfolioCell.self, forCellWithReuseIdentifier: ArtistPortfolioCell.identifier)

        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)

        setDelegateAndDataSource()
        view.addSubviews(collectionView, bottomBackgroundView, counselingButton)

        queryImageDataSet()
    }

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
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalToSuperview()
        }

        bottomBackgroundView.addSubview(counselingButton)

        bottomBackgroundView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(100)
            $0.width.equalToSuperview()
        }

        counselingButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
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


    // header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / 1 - 130)
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
}
