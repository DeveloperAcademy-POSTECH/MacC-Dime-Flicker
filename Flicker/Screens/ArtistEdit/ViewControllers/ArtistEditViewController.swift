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
}

class ArtistEditViewController: UIViewController {
    
    // 1. 받아온 나의 정보를 캐싱한 데이터 [A data] + A의 복사본 [B Data]
    
    // 2. [A Data] 전부를 바로 각 에디트하는 뷰컨에다가 뿌려!
    //  예) private let gnbjerg = EditRegionViewController().then {
    //    $0.ddd = 1
    //  } 식으로~ 각 에디트 뷰컨 에 전달시키기
    
    // 3. 각 에디트 뷰컨에서는 델리겟을 선언해서 메인 뷰컨의 [B Data] 에 동기화시키기
    // 4. A,B 데이터 비교하는건, 델리겟에서 받았던 A 와 보낸 B 데이터를 비교한 Bool 을 넣어놓고 매번 메인 뷰컨에서 테이블뷰 어차피 리로드 할거니깐, 테이블뷰 dataSource 에 bool 조건 넣어서 에디트함 띄우게 하기
    // 5. 그리고 초기화 버튼은... 그냥 B = A 시키고 테이블뷰 리로드 시켜
    // 6. 수정 완료하면, 기존의 사진... 지우고..? B 데이터로... 새롭게 올리기...? -> 코비에게 물어보기
    let exImage = UIImage(named: "RegisterEnd") ?? UIImage()
    
    private lazy var dataA = EditData(regions: ["마포구",  "강동구"].sorted(), camera: "소니 a7", lens: "짜이즈 55mm f1.8", tags: ["인물사진", "색감장인", "소니장인"], detailDescription: "뇸뇸뇸뇸자기소개", portfolioImages: [exImage])
    
    private lazy var dataB = EditData(regions: ["마포구",  "강동구"].sorted(), camera: "소니 a7", lens: "짜이즈 55mm f1.8", tags: ["인물사진", "색감장인", "소니장인"], detailDescription: "뇸뇸뇸뇸자기소개", portfolioImages: [exImage])
    
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
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        print(dataB)
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
        print("reset")
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
        
        cell.cellImage.image = UIImage(systemName: editItemsImageArray[indexPath.row], withConfiguration: imageWeight)
        cell.cellTextLabel.text = editItemsArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = editRegionsViewContrller
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

extension ArtistEditViewController: EditRegionsDelegate, EditGearsDelegate, EditConceptTagDelegate, EditTextInfoDelegate {
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
        self.dataB.regions = regionDatas
    }
}
