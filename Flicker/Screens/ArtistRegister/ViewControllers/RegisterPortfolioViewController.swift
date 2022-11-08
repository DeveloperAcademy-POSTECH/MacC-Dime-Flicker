//
//  RegisterPortfolioViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/02.
//

import UIKit
import PhotosUI
import SnapKit
import Then

    // TODO: (다음 버전에..)
final class RegisterPortfolioViewController: UIViewController {

    var dummyNUMBER: [UIColor] = [.red, .black, .systemGray3, .MainTintColor, .FreeDealBlue, .red, .red, .red, .red, .red, .red]
    
    // MARK: - view UI components
    private let mainTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "포트폴리오"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .bold)
        $0.text = "작가님의 포트폴리오를 제출해주세요!"
    }
    
    // TODO: 검토하겠다는 말은 mvp 에서는 넣지 않고, 넣어도 맨 마지막에 "검토 후 알려드릴게요" 라고 하는게 어떨까요?
    private let bodyTitleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .systemGray
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        $0.text = "포트폴리오가 따로 없어도 괜찮아요.\n자신있는 사진을 등록해주세요."
    }
    
    // MARK: - portfolio image components
    private enum portfolioCellIdentifier: String {
        case images = "portfoilo"
        case addButton = "button"
    }
    
    private var portfolioPhotosFetched: [UIImage?] = []
    
    private let portfolioFlowLayout = UICollectionViewFlowLayout().then {
        let imageWidth = (UIScreen.main.bounds.width - 80)/3
        $0.itemSize = CGSize(width: imageWidth , height: imageWidth)
        $0.minimumLineSpacing = 4
    }
    
    private let portfolioPicker: PHPickerViewController = {
        var photoConfiguration = PHPickerConfiguration()
        photoConfiguration.selectionLimit = 12
        photoConfiguration.filter = .images
        let photoPicker = PHPickerViewController(configuration: photoConfiguration)
        return photoPicker
    }()
    
    private lazy var portfolioCollectionView = UICollectionView(frame: .zero, collectionViewLayout: portfolioFlowLayout).then {
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = true
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        render()
    }
    
    private func render() {
        view.addSubviews(mainTitleLabel, subTitleLabel, bodyTitleLabel, portfolioCollectionView)
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(30)
        }
        
        bodyTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        portfolioCollectionView.snp.makeConstraints {
            $0.top.equalTo(bodyTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configUI() {
        portfolioPicker.delegate = self
        portfolioCollectionView.delegate = self
        portfolioCollectionView.dataSource = self
        portfolioCollectionView.register(RegisterPortfolioImageCell.self, forCellWithReuseIdentifier: portfolioCellIdentifier.images.rawValue)
        portfolioCollectionView.register(RegisterAddPhotosCollectionViewCell.self, forCellWithReuseIdentifier: portfolioCellIdentifier.addButton.rawValue)
    }

}

extension RegisterPortfolioViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
    }
    
}

extension RegisterPortfolioViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return portfolioPhotosFetched.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < portfolioPhotosFetched.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: portfolioCellIdentifier.images.rawValue, for: indexPath) as? RegisterPortfolioImageCell else { return UICollectionViewCell()}

            cell.photoImage.tintColor = dummyNUMBER[indexPath.row]
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: portfolioCellIdentifier.addButton.rawValue, for: indexPath) as? RegisterAddPhotosCollectionViewCell else { return UICollectionViewCell()}
            if portfolioPhotosFetched.count != 0 {
                cell.addImage.image = UIImage(systemName: "delete.backward.fill")
                return cell
            }
            return cell
        }
    }
}

extension RegisterPortfolioViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == portfolioPhotosFetched.count {
            // 사진 기능
        }
    }
}
