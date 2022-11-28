//
//  ArtistEditViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/21.
//

import UIKit
import SnapKit
import Then

struct EditData {
    var regions: [String]
    var camera: String
    var lens: String
    var tags: [String]
    var detailDescription: String
    var portfolioImages: [UIImage]
    var portfolioUrls: [String]
}

class ArtistEditViewController: UIViewController {
    
    // TODO: main 화면에서 받아온 캐싱된 데이터를 그대로 들고온 dataA 와 그 dataA 와 비교하기 위한 복제된 데이터 dataB 가 있다. 이걸 받아오는 작업이 필요하다. 해당 데이터들은 가데이터들이다.
    private lazy var dataA = EditData(regions: ["마포구",  "강동구"].sorted(), camera: "소니 a7", lens: "짜이즈 55mm f1.8", tags: ["인물사진", "색감장인", "소니장인"], detailDescription: "뇸뇸뇸뇸자기소개", portfolioImages: [exImage], portfolioUrls: [])
    
    private lazy var dataB = EditData(regions: ["마포구",  "강동구"].sorted(), camera: "소니 a7", lens: "짜이즈 55mm f1.8", tags: ["인물사진", "색감장인", "소니장인"], detailDescription: "뇸뇸뇸뇸자기소개", portfolioImages: [exImage], portfolioUrls: [])
    
    let exImage = UIImage(named: "RegisterEnd") ?? UIImage()
    
    private let editItemsArray: [String] = ["지역 수정", "장비 수정", "태그 수정", "자기 소개 수정", "포트폴리오 수정"]
    
    private let editItemsImageArray: [String] = ["mappin.and.ellipse", "camera.shutter.button", "tag", "doc.plaintext", "photo.artframe"]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(dataB)
        self.editItemsTableView.reloadData()
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func render() {
        view.addSubviews(mainTitleLabel, editItemsTableView, resetEditButton, completeEditButton)

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
    }
    
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let buttonCornerRadius = view.bounds.width/18
        resetEditButton.layer.cornerRadius = self.resetEditButton.frame.width/2
        completeEditButton.layer.cornerRadius = buttonCornerRadius
    }
}

extension ArtistEditViewController {
    @objc func resetEditTapped() {
        self.dataB = self.dataA
        UIView.animate(withDuration: 0.2, delay: 0.0,options: [.allowUserInteraction, .curveEaseInOut]) {
            self.resetEditButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        
        UIView.animate(withDuration: 0.1, delay: 0.0,options: [.allowUserInteraction, .curveEaseInOut]) {
            self.resetEditButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        self.editItemsTableView.reloadData()
        print(self.dataB)
    }
    
    @objc func completeEditTapped() {
        print("complete and out")
    }
}

extension ArtistEditViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        editItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "editCell", for: indexPath) as? ArtistEditItemsTableViewCell else { return UITableViewCell() }
        let imageWeight = UIImage.SymbolConfiguration(weight: .semibold)
        
        switch indexPath.row {
        case 0:
            let isEdited = self.dataA.regions != self.dataB.regions
            cell.cellImage.image = UIImage(systemName: editItemsImageArray[indexPath.row], withConfiguration: imageWeight)
            cell.cellTextLabel.text = editItemsArray[indexPath.row]
            if isEdited {
                cell.edittedLabel.isHidden = false
            } else {
                cell.edittedLabel.isHidden = true
            }
            return cell
        case 1:
            let isEditedBody = self.dataA.camera != self.dataB.camera
            let isEditedLens = self.dataA.lens != self.dataB.lens
            cell.cellImage.image = UIImage(systemName: editItemsImageArray[indexPath.row], withConfiguration: imageWeight)
            cell.cellTextLabel.text = editItemsArray[indexPath.row]
            if isEditedBody || isEditedLens {
                cell.edittedLabel.isHidden = false
            } else {
                cell.edittedLabel.isHidden = true
            }
            return cell
        case 2:
            let isEdited = self.dataA.tags != self.dataB.tags
            cell.cellImage.image = UIImage(systemName: editItemsImageArray[indexPath.row], withConfiguration: imageWeight)
            cell.cellTextLabel.text = editItemsArray[indexPath.row]
            if isEdited {
                cell.edittedLabel.isHidden = false
            } else {
                cell.edittedLabel.isHidden = true
            }
            return cell
        case 3:
            let isEdited = self.dataA.detailDescription != self.dataB.detailDescription
            cell.cellImage.image = UIImage(systemName: editItemsImageArray[indexPath.row], withConfiguration: imageWeight)
            cell.cellTextLabel.text = editItemsArray[indexPath.row]
            if isEdited {
                cell.edittedLabel.isHidden = false
            } else {
                cell.edittedLabel.isHidden = true
            }
            return cell
        case 4:
            let isEdited = self.dataA.portfolioImages != self.dataB.portfolioImages
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
                $0.currentRegion = self.dataB.regions
            }
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = editGearsViewController.then {
                $0.currentLens = self.dataB.lens
                $0.currentBody = self.dataB.camera
            }
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = editTagsViewController.then {
                $0.currentTags = self.dataB.tags
            }
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = editDescriptionViewController.then {
                $0.currentInfo = self.dataB.detailDescription
            }
            navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = editPortfoiloViewController
            navigationController?.pushViewController(vc, animated: true)
        default:
            print("not yet")
            return
        }
    }
}

extension ArtistEditViewController: EditRegionsDelegate, EditGearsDelegate, EditConceptTagDelegate, EditTextInfoDelegate, EditPortfolioDelegate {
    func photoSelected(photos imagesPicked: [UIImage]) {
        self.dataB.portfolioImages = imagesPicked
    }
    
    func textViewDescribed(textView textDescribed: String) {
        self.dataB.detailDescription = textDescribed
    }
    
    func conceptTagDescribed(tagLabel: [String]) {
        self.dataB.tags = tagLabel
    }
    
    func cameraBodySelected(cameraBody bodyName: String) {
        self.dataB.camera = bodyName
    }
    
    func cameraLensSelected(cameraLens lensName: String) {
        self.dataB.lens = lensName
    }
    
    func regionSelected(regions regionDatas: [String]) {
        self.dataB.regions = regionDatas.sorted()
    }
}
