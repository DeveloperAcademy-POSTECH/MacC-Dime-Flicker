//
//  ArtistEditViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/21.
//

import UIKit
import SnapKit
import Then

class ArtistEditViewController: UIViewController {
    
    // MARK: - data sets to post to the server
    private let dataFirebase = FirebaseManager()
    
    // MARK: datas from Firebase
    private var downloadedItems: Artist = Artist(regions: [], camera: "", lens: "", tags: [], detailDescription: "", portfolioImageUrls: [], userInfo: [:])
    
    // MARK: datas collected from downloadedItems to edit
    private var originalEditData: EditData = EditData(regions: [], camera: "", lens: "", tags: [], detailDescription: "", portfolioImages: [], portfolioUrls: [])
    
    // MARK: copied datas to check whether datas are edited
    private var copiedItems: EditData = EditData(regions: [], camera: "", lens: "", tags: [], detailDescription: "", portfolioImages: [], portfolioUrls: [])
    
    // MARK: - observer to check whether the async tasks are done
    private var temporaryStrings: [String] = [] {
        didSet {
            if self.temporaryStrings.count == self.copiedItems.portfolioImages.count {
                Task {
                    self.copiedItems.portfolioUrls = self.temporaryStrings
                    await self.dataFirebase.updateArtistInformation(copiedItems)
                    print("Updated")
                    self.hideLoadingView()
                    self.navigationController?.pushViewController(TabbarViewController(), animated: true)
                }
            }
        }
    }
    
    // MARK: - table lists components
    // TODO: enum 으로 바꾸기
    private let editItemsArray: [String] = ["지역 수정", "장비 수정", "태그 수정", "자기 소개 수정", "포트폴리오 수정"]
    
    private let editItemsImageArray: [String] = ["mappin.and.ellipse", "camera.shutter.button", "tag", "doc.plaintext", "photo.artframe"]
    
    // MARK: - loading UI view
    private let loadingView = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = .black.withAlphaComponent(0.7)
    }
    
    private let spinnerView = UIActivityIndicatorView(style: .large).then {
        $0.stopAnimating()
        $0.color = .mainPink
    }
    
    private let loadingLabel = UILabel().makeBasicLabel(labelText: "수정 중이에요!", textColor: .mainPink.withAlphaComponent(0.8), fontStyle: .headline, fontWeight: .bold).then {
        $0.shadowOffset = CGSize(width: 0.7, height: 0.7)
        $0.layer.shadowRadius = 20
        $0.shadowColor = .black.withAlphaComponent(0.6)
        $0.isHidden = true
    }
    
    // MARK: - view UI components
    private let editRegionsViewContrller = ArtistEditRegionsViewController()
    private let editGearsViewController = ArtistEditGearsViewController()
    private let editTagsViewController = ArtistEditTagsViewController()
    private let editDescriptionViewController = ArtistEditDescriptionViewController()
    private let editPortfoiloViewController = ArtistEditPortfoiloViewController()
    
    private let mainTitleLabel = UILabel().makeBasicLabel(labelText: "작가 정보 수정하기", textColor: .textMainBlack, fontStyle: .title1, fontWeight: .bold)
    
    private lazy var editItemsTableView = UITableView().then {
        $0.clipsToBounds = true
        $0.separatorStyle = .none
        $0.rowHeight = self.view.bounds.height/11
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    
    private let resetEditButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        $0.tintColor = .black.withAlphaComponent(0.6)
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        $0.backgroundColor = .systemGray3.withAlphaComponent(0.5)
        $0.setTitleColor(.systemOrange.withAlphaComponent(0.2), for: .highlighted)
        $0.clipsToBounds = true
    }
    
    private let completeEditButton = UIButton(type: .system).then {
        $0.tintColor = .white
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        $0.backgroundColor = .mainPink
        $0.setTitle("수정 완료", for: .normal)
        $0.clipsToBounds = true
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(copiedItems)
        self.editItemsTableView.reloadData()
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - layout constraints
    private func render() {
        view.addSubviews(mainTitleLabel, editItemsTableView, resetEditButton, completeEditButton, loadingView, spinnerView, loadingLabel)

        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            $0.leading.equalToSuperview().inset(30)
        }

        editItemsTableView.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(editItemsTableView.rowHeight*5)
        }
        
        resetEditButton.snp.makeConstraints {
            $0.centerY.equalTo(completeEditButton.snp.centerY)
            $0.leading.equalToSuperview().inset(20)
            $0.height.width.equalTo(view.bounds.height/13.5)
        }
        
        completeEditButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(UIScreen.main.bounds.height/13)
            $0.leading.equalTo(resetEditButton.snp.trailing).offset(18)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(view.bounds.height/12)
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        spinnerView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        loadingLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.spinnerView.snp.bottom).offset(35)
        }
    }
    
    // MARK: - view configurations
    private func configUI() {
        view.backgroundColor = .white
        
        editRegionsViewContrller.delegate = self
        editGearsViewController.delegate = self
        editTagsViewController.delegate = self
        editDescriptionViewController.delegate = self
        editPortfoiloViewController.delegate = self
        
        editItemsTableView.delegate = self
        editItemsTableView.dataSource = self
        editItemsTableView.register(ArtistEditItemsTableViewCell.self, forCellReuseIdentifier: "editCell")
        editItemsTableView.layer.cornerRadius = 20
        
        resetEditButton.addTarget(self, action: #selector(resetEditTapped), for: .touchUpInside)
        completeEditButton.addTarget(self, action: #selector(completeEditTapped), for: .touchUpInside)
        
        // MARK: get Artist datas from the server
        Task {
            await getData()
            moveDataToEditItems()
            copyDataWithinEditItems()
            print(originalEditData, copiedItems)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let buttonCornerRadius = view.bounds.width/18
        resetEditButton.layer.cornerRadius = self.resetEditButton.frame.width/2
        completeEditButton.layer.cornerRadius = buttonCornerRadius
    }
}

    // MARK: - action functions
extension ArtistEditViewController {
    // MARK: reset action
    @objc func resetEditTapped() {
        self.copiedItems = self.originalEditData
        UIView.animate(withDuration: 0.2, delay: 0.0,options: [.allowUserInteraction, .curveEaseInOut]) {
            self.resetEditButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        
        UIView.animate(withDuration: 0.1, delay: 0.0,options: [.allowUserInteraction, .curveEaseInOut]) {
            self.resetEditButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        self.editItemsTableView.reloadData()
        print(self.copiedItems)
    }
    
    // MARK: complete action
    @objc func completeEditTapped() {
        if originalEditData == copiedItems {
            print("None of data has been edited.")
            self.navigationController?.popViewController(animated: true)
        } else {
            recheckAlert()
        }
    }
    
    // MARK: alert action with networking *
    private func recheckAlert() {
        let recheckAlert = UIAlertController(title: "수정이 끝나셨나요?", message: "", preferredStyle: .actionSheet)
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            // MARK: 먼저 url 을 통해 서버에 저장된 image를 지우게 만들어야 함 ✅
            let numberOfUrls = self.copiedItems.portfolioUrls.count
            for indexNumber in 0..<numberOfUrls {
                Task {
                    await self.dataFirebase.removeImages(urlCount: indexNumber)
                }
            }
            
            // MARK: Concurrent uploading photos
            for (indexNum, photo) in self.copiedItems.portfolioImages.enumerated() {
                Task {
                    async let urlString = self.dataFirebase.uploadImage(photo: photo, indexNum: indexNum)
                    await self.temporaryStrings.append(urlString)
                }
            }
            self.copiedItems.portfolioUrls.removeAll()
            self.openLoadingView()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        
        recheckAlert.addAction(confirm)
        recheckAlert.addAction(cancel)
        present(recheckAlert, animated: true, completion: nil)
    }
    
    // MARK: get datas from the server
    private func getData() async {
        guard let temporaryArtist = await dataFirebase.getArtists() else { return }
        downloadedItems = temporaryArtist
    }
    
    // MARK: modify and copy datas to edit
    private func moveDataToEditItems() {
        originalEditData.regions = downloadedItems.regions.sorted()
        originalEditData.camera = downloadedItems.camera
        originalEditData.lens = downloadedItems.lens
        originalEditData.tags = downloadedItems.tags
        originalEditData.detailDescription = downloadedItems.detailDescription
        originalEditData.portfolioUrls = downloadedItems.portfolioImageUrls
    }
    
    private func copyDataWithinEditItems() {
        copiedItems = originalEditData
    }
    
    // MARK: changing loading view status action
    private func openLoadingView() {
        self.loadingView.isHidden = false
        self.spinnerView.startAnimating()
        self.loadingLabel.isHidden = false
    }
    
    private func hideLoadingView() {
        self.loadingView.isHidden = true
        self.spinnerView.stopAnimating()
        self.loadingLabel.isHidden = true
        print("⭐️⭐️⭐️⭐️⭐️⭐️⭐️HIDELOADINGVIEW")
    }
}

    // MARK: - tableView delegate and dataSource
extension ArtistEditViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        editItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath) as? ArtistEditItemsTableViewCell else { return UITableViewCell() }
        let imageWeight = UIImage.SymbolConfiguration(weight: .semibold)
        
        switch indexPath.row {
        case 0:
            let isEdited = self.originalEditData.regions != self.copiedItems.regions
            cell.cellImage.image = UIImage(systemName: editItemsImageArray[indexPath.row], withConfiguration: imageWeight)
            cell.cellTextLabel.text = editItemsArray[indexPath.row]
            if isEdited {
                cell.edittedLabel.isHidden = false
            } else {
                cell.edittedLabel.isHidden = true
            }
            
            return cell
        case 1:
            let isEditedBody = self.originalEditData.camera != self.copiedItems.camera
            let isEditedLens = self.originalEditData.lens != self.copiedItems.lens
            cell.cellImage.image = UIImage(systemName: editItemsImageArray[indexPath.row], withConfiguration: imageWeight)
            cell.cellTextLabel.text = editItemsArray[indexPath.row]
            if isEditedBody || isEditedLens {
                cell.edittedLabel.isHidden = false
            } else {
                cell.edittedLabel.isHidden = true
            }
            return cell
        case 2:
            let isEdited = self.originalEditData.tags != self.copiedItems.tags
            cell.cellImage.image = UIImage(systemName: editItemsImageArray[indexPath.row], withConfiguration: imageWeight)
            cell.cellTextLabel.text = editItemsArray[indexPath.row]
            if isEdited {
                cell.edittedLabel.isHidden = false
            } else {
                cell.edittedLabel.isHidden = true
            }
            
            return cell
        case 3:
            let isEdited = self.originalEditData.detailDescription != self.copiedItems.detailDescription
            cell.cellImage.image = UIImage(systemName: editItemsImageArray[indexPath.row], withConfiguration: imageWeight)
            cell.cellTextLabel.text = editItemsArray[indexPath.row]
            if isEdited {
                cell.edittedLabel.isHidden = false
            } else {
                cell.edittedLabel.isHidden = true
            }
            
            return cell
        case 4:
            let isEdited = self.originalEditData.portfolioImages != self.copiedItems.portfolioImages
            cell.cellImage.image = UIImage(systemName: editItemsImageArray[indexPath.row], withConfiguration: imageWeight)
            cell.cellTextLabel.text = editItemsArray[indexPath.row]
            if isEdited {
                cell.edittedLabel.isHidden = false
            } else {
                cell.edittedLabel.isHidden = true
            }
            
            return cell
        default:
            
            return cell
        }
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = editRegionsViewContrller.then {
                $0.currentRegion = self.copiedItems.regions
            }
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = editGearsViewController.then {
                $0.currentLens = self.copiedItems.lens
                $0.currentBody = self.copiedItems.camera
            }
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = editTagsViewController.then {
                $0.currentTags = self.copiedItems.tags
            }
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = editDescriptionViewController.then {
                $0.currentInfo = self.copiedItems.detailDescription
            }
            navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = editPortfoiloViewController
            navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
}

    // MARK: - data transfer delegates
extension ArtistEditViewController: EditRegionsDelegate, EditGearsDelegate, EditConceptTagDelegate, EditTextInfoDelegate, EditPortfolioDelegate {
    func photoSelected(photos imagesPicked: [UIImage]) {
        self.copiedItems.portfolioImages = imagesPicked
    }
    func textViewDescribed(textView textDescribed: String) {
        self.copiedItems.detailDescription = textDescribed
    }
    func conceptTagDescribed(tagLabel: [String]) {
        self.copiedItems.tags = tagLabel
    }
    func cameraBodySelected(cameraBody bodyName: String) {
        self.copiedItems.camera = bodyName
    }
    func cameraLensSelected(cameraLens lensName: String) {
        self.copiedItems.lens = lensName
    }
    func regionSelected(regions regionDatas: [String]) {
        self.copiedItems.regions = regionDatas.sorted()
    }
}
