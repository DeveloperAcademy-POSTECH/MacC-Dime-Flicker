//
//  ArtistEditDescriptionViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/22.
//

import UIKit
import SnapKit
import Then

    // TODO: (다음 버전에..)
final class ArtistEditDescriptionViewController: UIViewController {

    // MARK: - custom delegate to send Datas
    weak var delegate: EditTextInfoDelegate?
    
    // MARK: - custom navigation bar
    private let customNavigationBarView = RegisterCustomNavigationView()
    
    // MARK: - data Transferred
    var currentInfo: String = ""
    lazy var editedInfo: String = currentInfo
    
    // MARK: - view UI components
    private let mainTitleLabel = UILabel().then {
        $0.textColor = .systemTeal
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "자기 소개 수정"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .bold)
        $0.text = "멘트를 수정할 수 있어요!"
    }
    
    private let bodyTitleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .systemGray
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        $0.text = "촬영 경험과 자신의 촬영 스타일을 적어주세요!"
    }
    
    private lazy var descriptionTextView = UITextView().then {
        $0.text = "\(currentInfo)"
        $0.clipsToBounds = true
        $0.isScrollEnabled = true
        $0.dataDetectorTypes = .all
        $0.textColor = .textSubBlack
        $0.autocorrectionType = .no
        $0.isUserInteractionEnabled = true
        $0.backgroundColor = .systemTeal.withAlphaComponent(0.1)
        $0.textContainerInset = UIEdgeInsets(top: 25, left: 10, bottom: 20, right: 10)
        $0.font = .preferredFont(forTextStyle: .callout, weight: .regular)
    }
    
    private lazy var completeEditButton = UIButton(type: .system).then {
        $0.isEnabled = false
        $0.tintColor = .white
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        $0.backgroundColor = .systemGray2.withAlphaComponent(0.6)
        $0.setTitle("소개 수정 완료", for: .normal)
        $0.clipsToBounds = true
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        render()
        customBackButton()
        completeButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        descriptionTextView.text = self.currentInfo
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.customNavigationBarView.popImage.isHidden = true
    }
    
    // MARK: - layout constraints
    private func render() {
        view.addSubviews(customNavigationBarView, mainTitleLabel, subTitleLabel, bodyTitleLabel, descriptionTextView, completeEditButton)
        
        customNavigationBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(view.bounds.height/16)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.top.equalTo(customNavigationBarView.snp.bottom).offset(UIScreen.main.bounds.height/24)
            $0.leading.equalToSuperview().inset(30)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(30)
        }
        
        bodyTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(30)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(bodyTitleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(UIScreen.main.bounds.height/3.3)
        }
        
        completeEditButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(UIScreen.main.bounds.height/13)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(view.bounds.height/12)
        }
    }
    
    // MARK: - view configurations
    private func configUI() {
        view.backgroundColor = .systemBackground
        
        descriptionTextView.delegate = self
        descriptionTextView.layer.cornerRadius = view.bounds.width/22
        
        completeEditButton.layer.cornerRadius = view.bounds.width/18
    }
    
    // MARK: - keyboard touch dismiss
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

    // MARK: - textView delegate
extension ArtistEditDescriptionViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        enableButton()
    }
}

    // MARK: - action functions
extension ArtistEditDescriptionViewController {
    private func customBackButton() {
        let backTapped = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        customNavigationBarView.customBackButton.addGestureRecognizer(backTapped)
    }
    
    private func completeButton() {
        let completeTapped = UITapGestureRecognizer(target: self, action: #selector(completeButtonTapped))
        completeEditButton.addGestureRecognizer(completeTapped)
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func completeButtonTapped() {
        self.delegate?.textViewDescribed(textView: self.descriptionTextView.text)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: enable disabled button under the condtion
    private func enableButton() {
        guard let descText = descriptionTextView.text else { return }
        if !descText.isEmpty {
            completeEditButton.isEnabled = true
            completeEditButton.backgroundColor = .mainPink
        } else {
            completeEditButton.isEnabled = false
            completeEditButton.backgroundColor = .systemGray2.withAlphaComponent(0.6)
        }
    }
}

// MARK: - Edit TextDescription custom delegate protocol
protocol EditTextInfoDelegate: AnyObject {
    func textViewDescribed(textView textDescribed: String)
}
