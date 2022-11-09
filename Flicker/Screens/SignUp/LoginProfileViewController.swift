//
//  ProfileSettingViewController.swift
//  Flicker
//
//  Created by 김연호 on 2022/11/02.
//

import UIKit

import SnapKit
import Then

final class LoginProfileViewController: BaseViewController {

    private var isNickNameWrite = false

    private lazy var imagePicker = UIImagePickerController().then {
        $0.sourceType = .photoLibrary
        $0.allowsEditing = true
        $0.delegate = self
    }

    private lazy var profileImageView = UIImageView().then {
        $0.image = ImageLiteral.btnProfile
        $0.tintColor = .loginGray
        $0.layer.cornerRadius = 40
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectButtonTouched)))
    }

    private func labelTemplate(labelText: String, textColor: UIColor ,fontStyle: UIFont.TextStyle, fontWeight: UIFont.Weight) -> UILabel {
        let label = UILabel().then {
            $0.text = labelText
            $0.textColor = textColor
            $0.font = .preferredFont(forTextStyle: fontStyle, weight: fontWeight)
        }
        return label
    }

    private lazy var profileLabelFirst = labelTemplate(labelText: "자신을 보여줄 수 있는 간단한 프로필 사진을 보여주세요!", textColor: .textSubBlack, fontStyle: .caption1, fontWeight: .medium)

    private lazy var profileLabelSecond = labelTemplate(labelText: "프로필 사진은 작가와 모델의 매칭에 도움을 줍니다", textColor: .textSubBlack, fontStyle: .caption1, fontWeight: .medium)

    private lazy var nickNameLabel = labelTemplate(labelText: "닉네임", textColor: .black, fontStyle: .title3, fontWeight: .bold)
    private lazy var isArtistLabel = labelTemplate(labelText: "사진작가로 활동할 예정이신가요?", textColor: .black, fontStyle: .title3, fontWeight: .bold)
    private lazy var afterJoinLabel = labelTemplate(labelText: "가입 후 마이프로필에서 작가등록을 하실 수 있어요!", textColor: .textSubBlack, fontStyle: .caption1, fontWeight: .medium)

    
    private let nickNameField = UITextField().then {
        let attributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .bold)
        ]

        $0.backgroundColor = .loginGray
        $0.attributedPlaceholder = NSAttributedString(string: "닉네임", attributes: attributes)
        $0.autocapitalizationType = .none
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        $0.leftViewMode = .always
        $0.clipsToBounds = false
        $0.makeShadow(color: .black, opacity: 0.08, offset: CGSize(width: 0, height: 4), radius: 20)
    }

    private let artistTrueButton = UIButton().then {
        $0.setTitle("네", for: .normal)
        $0.backgroundColor = .loginGray
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 15
    }

    private let artistFalseButton = UIButton().then {
        $0.setTitle("아니오", for: .normal)
        $0.backgroundColor = .loginGray
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 15
    }

    private let signUpButton = UIButton().then {
        $0.backgroundColor = .loginGray
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("완료", for: .normal)
        $0.layer.cornerRadius = 15
    }

    private let navigationDivider = UIView().then {
        $0.backgroundColor = .loginGray
    }

    override func render() {
        nickNameField.delegate = self

        signUpButton.isEnabled = false

        view.addSubviews(profileImageView, profileLabelFirst, profileLabelSecond, nickNameLabel, isArtistLabel, afterJoinLabel, nickNameField, artistTrueButton, artistFalseButton, signUpButton, navigationDivider)


        artistTrueButton.addTarget(self, action: #selector(didTapArtistTrueButton), for: .touchUpInside)
        artistFalseButton.addTarget(self, action: #selector(didTapArtistFalseButton), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)


        navigationDivider.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }


        profileLabelFirst.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }

        profileLabelSecond.snp.makeConstraints {
            $0.top.equalTo(profileLabelFirst.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
        }

        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileLabelSecond.snp.bottom).offset(45)
            $0.leading.equalToSuperview().inset(20)
        }

        nickNameField.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        isArtistLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        afterJoinLabel.snp.makeConstraints {
            $0.top.equalTo(isArtistLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        artistTrueButton.snp.makeConstraints {
            $0.top.equalTo(afterJoinLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(170)
        }

        artistFalseButton.snp.makeConstraints {
            $0.top.equalTo(afterJoinLabel.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(170)
        }

        signUpButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(50)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
    }
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

        }

        override func setupNavigationBar() {
            super.setupNavigationBar()

            title = "프로필 입력"
        }

    @objc private func selectButtonTouched(_ recognizer: UITapGestureRecognizer) {
        self.present(imagePicker, animated: true)
    }

    @objc private func didTapArtistTrueButton() {
        artistTrueButton.backgroundColor = .mainPink
        artistTrueButton.setTitleColor(.white, for: .normal)
        artistFalseButton.backgroundColor = .loginGray
        artistFalseButton.setTitleColor(.black, for: .normal)

        if isNickNameWrite {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .mainPink
        }
    }

    @objc private func didTapArtistFalseButton() {
        artistTrueButton.backgroundColor = .loginGray
        artistTrueButton.setTitleColor(.black, for: .normal)
        artistFalseButton.backgroundColor = .mainPink
        artistFalseButton.setTitleColor(.white, for: .normal)

        if isNickNameWrite {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .mainPink
        }
    }

    @objc private func didTapSignUpButton() {

        let viewController = TabbarViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}

extension LoginProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func textFieldDidEndEditing(_ textField: UITextField) {
        isNickNameWrite = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        var newImage : UIImage? = nil // update 할 이미지

        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage    // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage        // 원본 이미지가 있을 경우
        }
        self.profileImageView.image = newImage
        dismiss(animated: true, completion: nil)
    }
}

