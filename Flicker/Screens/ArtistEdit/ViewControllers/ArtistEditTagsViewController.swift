//
//  ArtistEditTagsViewController.swift
//  Flicker
//
//  Created by KYUBO A. SHIM on 2022/11/22.
//

import UIKit
import SnapKit
import Then

    // TODO: (다음 버전에..) 새로운 뷰...
final class ArtistEditTagsViewController: UIViewController {
    
    // MARK: - custom delegate to send Datas
    weak var delegate: EditConceptTagDelegate?
    
    // MARK: - custom navigation bar
    private let customNavigationBarView = RegisterCustomNavigationView()
    
    // MARK: - data Transferred
    var currentTags: [String] = [""]
    private var editedString: String = ""
    
    // MARK: - view UI components
    private let mainTitleLabel = UILabel().then {
        $0.textColor = .systemTeal
        $0.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        $0.text = "태그 수정"
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .title3, weight: .bold)
        $0.text = "태그를 수정할 수 있어요!"
    }
    
    private let bodyTitleLabel = UILabel().then {
        $0.numberOfLines = 3
        $0.textColor = .systemGray
        $0.font = UIFont.preferredFont(forTextStyle: .body, weight: .medium)
        $0.text = "태그를 최대 4개까지 남길 수 있습니다. 검색에 쓰이거나 대표 사진과 함께 쓰입니다.\n띄어쓰기 없이 #을 사용하여 적어주세요!"
    }
    
    private let conceptTagSectionLabel = UILabel().then {
        $0.textColor = .MainTintColor
        $0.font = UIFont.preferredFont(forTextStyle: .headline, weight: .heavy)
        $0.text = "태그"
    }
    
    private lazy var conceptTagExampleSectionLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textColor = .systemGray2.withAlphaComponent(0.9)
        $0.font = UIFont.preferredFont(forTextStyle: .footnote, weight: .bold)
        $0.text = "예)  #인물사진#영화사진#가족사진#후지필름"
    }
    
    private let conceptTagWarningLabel = UILabel().makeBasicLabel(labelText: "#로 시작하지 않으면 제대로 태그가 생성되지 않을 수 있어요!", textColor: .red.withAlphaComponent(0.5), fontStyle: .footnote, fontWeight: .medium).then {
        $0.numberOfLines = 2
        $0.isHidden = true
    }
    
    private lazy var completeEditButton = UIButton(type: .system).then {
        $0.isEnabled = false
        $0.tintColor = .white
        $0.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3, weight: .semibold)
        $0.backgroundColor = .systemGray2.withAlphaComponent(0.6)
        $0.setTitle("태그 수정 완료", for: .normal)
        $0.clipsToBounds = true
    }
    
    // MARK: - textField UI components
    private let conceptTagTextField = UITextField().then {
        $0.text = ""
        $0.clipsToBounds = true
        $0.leftViewMode = .always
        $0.autocorrectionType = .no
        $0.textColor = .textSubBlack
        $0.layer.masksToBounds = true
        $0.backgroundColor = .systemTeal.withAlphaComponent(0.1)
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        $0.font = UIFont.preferredFont(forTextStyle: .subheadline, weight: .medium)
        $0.placeholder = "태그 사이를 띄어쓰기 없이 적어주세요!"
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        conceptTagTextField.text = "#\(joinStrings(array: currentTags))"
        self.customNavigationBarView.popImage.isHidden = true
    }
    
    // MARK: - keyboard automatically pop
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - layout constraints
    private func render() {
        view.addSubviews(customNavigationBarView, mainTitleLabel, subTitleLabel, bodyTitleLabel, conceptTagSectionLabel, conceptTagExampleSectionLabel, conceptTagTextField, conceptTagWarningLabel, completeEditButton)
        
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
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        bodyTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        conceptTagSectionLabel.snp.makeConstraints {
            $0.top.equalTo(bodyTitleLabel.snp.bottom).offset(22)
            $0.leading.equalToSuperview().inset(35)
        }
        
        conceptTagExampleSectionLabel.snp.makeConstraints {
            $0.top.equalTo(conceptTagSectionLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(35)
        }
        
        conceptTagTextField.snp.makeConstraints {
            $0.top.equalTo(conceptTagExampleSectionLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(self.view.bounds.height/13)
        }
        
        conceptTagWarningLabel.snp.makeConstraints {
            $0.top.equalTo(conceptTagTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(33)
            $0.trailing.equalToSuperview().inset(33)
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

        conceptTagTextField.delegate = self
        conceptTagTextField.layer.cornerRadius = view.bounds.width/22
        
        completeEditButton.layer.cornerRadius = view.bounds.width/18
    }
}

    // MARK: - textField delegate
extension ArtistEditTagsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textInput = textField.text else { return true }
        if textInput.count > 1 {
            let firstChar: Character = textInput[textInput.startIndex]
            if firstChar == "#" {
                self.conceptTagWarningLabel.isHidden = true
            } else {
                self.conceptTagWarningLabel.isHidden = false
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        enableButton()
        guard let textInput = textField.text else { return }
        if textInput.count > 1 {
            let firstChar: Character = textInput[textInput.startIndex]
            if firstChar == "#" {
                self.conceptTagWarningLabel.isHidden = true
                self.editedString = textInput
            } else {
                self.conceptTagWarningLabel.isHidden = false
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.dismiss(animated: true)
        return true
    }
}

extension ArtistEditTagsViewController {
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
        if conceptTagTextField.text?.count ?? 0 < 2 {
            self.navigationController?.popViewController(animated: true)
        } else {
            conceptTextTagDescribed(tagLabel: editedString)
            if currentTags.count < 1 {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.delegate?.conceptTagDescribed(tagLabel: currentTags)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func joinStrings(array: [String]) -> String {
        return array.joinString(separator: "#")
    }
    
    private func conceptTextTagDescribed(tagLabel: String) {
        let editedStringArray = tagStringConvert(label: tagLabel)
        if editedStringArray.count > 4 {
            var temporaryArray: [String] = []
            for i in 0...3 {
                temporaryArray.append(editedStringArray[i])
            }
            self.currentTags = temporaryArray
        } else {
            self.currentTags = editedStringArray
        }
    }
    
    private func tagStringConvert(label: String) -> [String] {
        let array = label.components(separatedBy: "#").filter{ $0 != ""}
        return array
    }
    
    private func enableButton() {
        guard let tagText = conceptTagTextField.text else { return }
        if !tagText.isEmpty {
            completeEditButton.isEnabled = true
            completeEditButton.backgroundColor = .mainPink
        } else {
            completeEditButton.isEnabled = false
            completeEditButton.backgroundColor = .systemGray2.withAlphaComponent(0.6)
        }
    }
}

// MARK: - RegisterConceptTagDelegate custom delegate protocol
protocol EditConceptTagDelegate: AnyObject {
    func conceptTagDescribed(tagLabel: [String])
}

