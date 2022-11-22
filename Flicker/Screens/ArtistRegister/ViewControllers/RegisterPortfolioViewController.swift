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
    
    // MARK: - custom delegate to send Datas
    weak var delegate: RegisterPortfolioDelegate?
    
    // MARK: - view UI components
    private let mainTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "포트폴리오"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .bold)
        $0.text = "작가님의 포트폴리오를 제출해주세요!"
    }
    
    private let bodyTitleLabel = UILabel().then {
        $0.numberOfLines = 3
        $0.textColor = .systemGray
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        $0.text = "최대 12장까지 선택 가능하며, 등록된 사진들 중 사람들에게 가장 먼저 보여질 대표 사진을 눌러 정해보세요!"
    }
    
    private let guideLabel = UILabel().makeBasicLabel(labelText: "사진을 탭해, 대표 사진을 바꿔보세요!", textColor: .red.withAlphaComponent(0.5), fontStyle: .subheadline, fontWeight: .medium).then {
        $0.isHidden = true
    }
    
    // MARK: - portfolio image components
    private var portfolioPhotosFetched: [UIImage] = []
    
    private enum portfolioCellIdentifier: String {
        case images = "portfoilo"
        case addButton = "button"
    }
    
    private let portfolioFlowLayout = UICollectionViewFlowLayout().then {
        let imageWidth = (UIScreen.main.bounds.width - 80)/3
        $0.itemSize = CGSize(width: imageWidth , height: imageWidth)
        $0.minimumLineSpacing = 10
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
    
    //MARK: Guide label for changing main photo by tapping images
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.portfolioPhotosFetched.count > 0 {
            self.guideLabel.isHidden = false
        }
    }
    
    // MARK: - layout constraints
    private func render() {
        view.addSubviews(mainTitleLabel, subTitleLabel, bodyTitleLabel, guideLabel, portfolioCollectionView)
        
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
        
        guideLabel.snp.makeConstraints {
            $0.top.equalTo(bodyTitleLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(33)
        }
        
        portfolioCollectionView.snp.makeConstraints {
            $0.top.equalTo(bodyTitleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - view configurations
    private func configUI() {
        view.backgroundColor = .systemBackground
        
        portfolioPicker.delegate = self
        
        portfolioCollectionView.delegate = self
        portfolioCollectionView.dataSource = self
        portfolioCollectionView.register(RegisterPortfolioImageCell.self, forCellWithReuseIdentifier: portfolioCellIdentifier.images.rawValue)
        portfolioCollectionView.register(RegisterAddPhotosCollectionViewCell.self, forCellWithReuseIdentifier: portfolioCellIdentifier.addButton.rawValue)
    }
}

    // MARK: - PHPickerView delegate
extension RegisterPortfolioViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let photoItems = results
            .map { $0.itemProvider }
            .filter { $0.canLoadObject(ofClass: UIImage.self) }
        let dispatchGroup = DispatchGroup()
        var temporaryImages = [UIImage]()
        var indexNumber: Int = 0
        
        for photoItem in photoItems {
            indexNumber += 1
            dispatchGroup.enter()
            photoItem.loadObject(ofClass: UIImage.self) { photos, error in
                if let image = photos as? UIImage {
                    guard let compressedImage = image.jpegData(compressionQuality: 0.0) else { return }
                    if let jpegPhoto = UIImage(data: compressedImage) {
                        temporaryImages.append(jpegPhoto)
                    }
                }
                if let error = error {
                    print(error)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            if (!temporaryImages.isEmpty) {
                self.portfolioPhotosFetched = temporaryImages
                self.portfolioCollectionView.reloadData()
            }
            self.delegate?.photoSelected(photos: temporaryImages)
            print(temporaryImages)
        }
    }
}

    // MARK: - UICollectionView datasource
extension RegisterPortfolioViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return portfolioPhotosFetched.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item < portfolioPhotosFetched.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: portfolioCellIdentifier.images.rawValue, for: indexPath) as? RegisterPortfolioImageCell else { return UICollectionViewCell()}
            // MARK: First item of photos becomes the main Photo
            if indexPath.item == 0 {
                cell.photoImage.image = self.portfolioPhotosFetched[indexPath.item]
                cell.mainPhotoMarkLabel.isHidden = false
                cell.photoImage.layer.borderWidth = 4
                self.delegate?.photoSelected(photos: portfolioPhotosFetched)
                return cell
            }
            cell.photoImage.image = self.portfolioPhotosFetched[indexPath.item]
            cell.mainPhotoMarkLabel.isHidden = true
            cell.photoImage.layer.borderWidth = 0
            self.delegate?.photoSelected(photos: portfolioPhotosFetched)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: portfolioCellIdentifier.addButton.rawValue, for: indexPath) as? RegisterAddPhotosCollectionViewCell else { return UICollectionViewCell()}
            if portfolioPhotosFetched.count != 0 {
                return cell
            }
            return cell
        }
    }
}

    // MARK: - UICollectionView delegate
extension RegisterPortfolioViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == portfolioPhotosFetched.count {
            self.present(portfolioPicker, animated: true)
        } else {
            // MARK: Selected Image moves to top of the array
            let selectedCellIndex = indexPath.item
            let selectedPhoto = self.portfolioPhotosFetched[selectedCellIndex]
            self.portfolioPhotosFetched.remove(at: selectedCellIndex)
            self.portfolioPhotosFetched.insert(selectedPhoto, at: 0)
            self.portfolioCollectionView.reloadData()
        }
    }
}

// MARK: - RegisterPortfolio custom delegate protocol
protocol RegisterPortfolioDelegate: AnyObject {
    func photoSelected(photos imagesPicked: [UIImage])
}
