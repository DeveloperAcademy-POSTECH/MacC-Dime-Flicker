//
//  StateTagListView.swift
//  Flicker
//
//  Created by COBY_PRO on 2022/11/15.
//

import UIKit

import SnapKit
import Then

final class StateTagListView: UIView {
    
    private var parent: RegionViewController?
    
    private let stateList: [String] = ["전체", "서울강북", "서울강남"]
    
    private enum Size {
        static let collectionHorizontalSpacing: CGFloat = 20.0
        static let collectionVerticalSpacing: CGFloat = 0.0
        static let cellWidth: CGFloat = (UIScreen.main.bounds.size.width - collectionHorizontalSpacing * 2 - 24) / 4
        static let cellHeight: CGFloat = 40
        static let collectionInset = UIEdgeInsets(top: collectionVerticalSpacing,
                                                  left: collectionHorizontalSpacing,
                                                  bottom: collectionVerticalSpacing,
                                                  right: collectionHorizontalSpacing)
    }
    
    // MARK: - property
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.sectionInset = Size.collectionInset
        $0.itemSize = CGSize(width: Size.cellWidth, height: Size.cellHeight)
        $0.minimumLineSpacing = 8
    }
    
    private lazy var listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = .clear
        $0.dataSource = self
        $0.delegate = self
        $0.showsHorizontalScrollIndicator = false
        $0.register(StateCollectionViewCell.self,
                                forCellWithReuseIdentifier: StateCollectionViewCell.className)
    }
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func render() {
        self.addSubview(listCollectionView)
        
        listCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setParentViewController(viewController: RegionViewController) {
        self.parent = viewController
    }
}

// MARK: - UICollectionViewDataSource
extension StateTagListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stateList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StateCollectionViewCell.className, for: indexPath) as? StateCollectionViewCell else {
            assert(false, "Wrong Cell")
        }
        
        cell.stateLabel.text = stateList[indexPath.item]
    
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension StateTagListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        parent?.setState(state: stateList[indexPath.item])
    }
}
