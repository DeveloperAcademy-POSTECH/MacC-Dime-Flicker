//
//  CollectionViewReusableView.swift
//  Flicker
//
//  Created by Jisu Jang on 2022/10/29.
//
import UIKit
import SnapKit
import Then

class HeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "HeaderCollectionReusableView"

    private var imageScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
    }

    private let imageHeight: Int = 380
    private let profileImageSize: Int = 45

    private let images: [UIImage?] = [UIImage(named: "port2"), UIImage(named: "port1"), UIImage(named: "port3"), UIImage(named: "port4")]

    private lazy var pageControl = UIPageControl().then {
        $0.numberOfPages = images.count
        $0.backgroundColor = .clear
        $0.pageIndicatorTintColor = .gray
        $0.currentPageIndicatorTintColor = .mainYellow
    }

    // seller information
    private let artistUIView = UIView().then {
        $0.isUserInteractionEnabled = true
    }

    private let artistNickname = UILabel().makeBasicLabel(labelText: "장루키 작가님", textColor: .black, fontStyle: .title3, fontWeight: .bold)

    private let artistInformation = UILabel().makeBasicLabel(labelText: "#우정사진 #필름사진 #웨딩촬영", textColor: .systemGray, fontStyle: .footnote, fontWeight: .light)

    private lazy var artistProfileImage = UIImageView().then {
        $0.image = UIImage(named: "port3")
        $0.layer.cornerRadius = CGFloat(profileImageSize / 2)
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }

    private let firstSeperator = UIView().then {
        $0.backgroundColor = .systemGray5
    }

    private let secondSeperator = UIView().then {
        $0.backgroundColor = .systemGray5
    }

    private let thirdSeperator = UIView().then {
        $0.backgroundColor = .systemGray5
    }

    private let introductionLabel = UILabel().makeBasicLabel(labelText: "자기소개", textColor: .MainTintColor, fontStyle: .subheadline, fontWeight: .medium)

    private let introductionTextView = UITextView().then {
        $0.setLineAndLetterSpacing("저는 송도에 거주하며 인천대에 재학중입니다. 송도와 영종도 부근을 많이 찍어봤고 주로 커플 스냅을 많이 찍습니다.편하게 연락주세요!종도 부근을 많이 찍어봤고 하며 인천대에 재학중입니다. 송도와 영종도 부근을 많이 찍어봤고 주로 커플 스냅을 많이 찍습니다.편하게 연락주세요!종도 부근을 많이 찍어봤고")
        $0.isScrollEnabled = false
        $0.font = .preferredFont(forTextStyle: .callout, weight: .regular)
        $0.isUserInteractionEnabled = false
    }

    //TODO: 추후에 horizontal stackView로 바꾸기
    
    private let regionImageView = UIImageView().then {
        $0.image = UIImage(systemName: "map.fill")
        $0.tintColor = .mainPink
    }

    private let lensInfoImageView = UIImageView().then {
        $0.image = UIImage(systemName: "camera.metering.center.weighted")
        $0.tintColor = .mainPink
    }

    private let bodyInfoImageView = UIImageView().then {
        $0.image = UIImage(systemName: "circle.rectangle.filled.pattern.diagonalline")
        $0.tintColor = .mainPink
    }

    private let regionInfo = UILabel().makeBasicLabel(labelText: "서초구, 서대문구, 은평구", textColor: .black, fontStyle: .callout, fontWeight: .light)

    private let lensInfo = UILabel().makeBasicLabel(labelText: "Sony 50mm f1.8 GM", textColor: .black, fontStyle: .callout, fontWeight: .light)

    private let bodyInfo = UILabel().makeBasicLabel(labelText: "Sony a7m3", textColor: .black, fontStyle: .callout, fontWeight: .light)

    override init (frame: CGRect) {
        super.init(frame: frame)
        // subview
        self.addSubviews(imageScrollView, pageControl, artistUIView, artistProfileImage, artistNickname, artistInformation, introductionLabel, introductionTextView, firstSeperator, secondSeperator, thirdSeperator)

        self.addSubviews(regionInfo, lensInfo, bodyInfo)

        self.addSubviews(regionImageView, lensInfoImageView, bodyInfoImageView)

        configureImageScrollView()
        setFunctionAndDelegate()
    }

    required init?(coder: NSCoder) {
        fatalError ()
    }

    override func layoutSubviews () {
        super.layoutSubviews ()

        imageScrollView.snp.makeConstraints {
            $0.height.equalTo(imageHeight)
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }

        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(imageScrollView.snp.bottom).inset(5)
            $0.height.equalTo(50)
            $0.width.equalTo(300)
        }

        // artistInformaiton
        artistUIView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageScrollView.snp.bottom).offset(5)
            $0.width.equalToSuperview().inset(20)
            $0.height.equalTo(70)
        }

        artistUIView.addSubviews(artistProfileImage, artistNickname, artistInformation)

        artistProfileImage.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(profileImageSize)
            $0.height.equalTo(profileImageSize)
        }

        artistNickname.snp.makeConstraints {
            $0.leading.equalTo(artistProfileImage.snp.trailing).offset(10)
            $0.top.equalTo(artistProfileImage)
        }

        artistInformation.snp.makeConstraints {
            $0.leading.equalTo(artistNickname)
            $0.top.equalTo(artistNickname.snp.bottom).offset(5)
        }

        firstSeperator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(artistUIView.snp.bottom).offset(3)
            $0.width.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }

        introductionLabel.snp.makeConstraints {
            $0.leading.equalTo(artistProfileImage)
            $0.top.equalTo(firstSeperator.snp.bottom).offset(9)
        }

        introductionTextView.snp.makeConstraints {
            $0.leading.equalTo(introductionLabel)
            $0.width.equalToSuperview().inset(20)
            $0.top.equalTo(introductionLabel.snp.bottom).offset(5)
        }
        
        secondSeperator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(introductionTextView.snp.bottom).offset(5)
            $0.width.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }

        // Photographer Information
        regionImageView.snp.makeConstraints {
            $0.leading.equalTo(secondSeperator)
            $0.top.equalTo(secondSeperator.snp.bottom).offset(12)
            $0.width.height.equalTo(18)
        }

        regionInfo.snp.makeConstraints {
            $0.leading.equalTo(regionImageView.snp.trailing).offset(8)
            $0.top.equalTo(secondSeperator.snp.bottom).offset(12)
        }

        lensInfoImageView.snp.makeConstraints {
            $0.leading.equalTo(secondSeperator)
            $0.top.equalTo(regionInfo.snp.bottom).offset(5)
            $0.width.height.equalTo(18)
        }
        
        lensInfo.snp.makeConstraints {
            $0.leading.equalTo(lensInfoImageView.snp.trailing).offset(8)
            $0.top.equalTo(regionInfo.snp.bottom).offset(5)
        }

        bodyInfoImageView.snp.makeConstraints {
            $0.leading.equalTo(secondSeperator)
            $0.top.equalTo(lensInfoImageView.snp.bottom).offset(5)
            $0.width.height.equalTo(18)
        }

        bodyInfo.snp.makeConstraints {
            $0.leading.equalTo(bodyInfoImageView.snp.trailing).offset(8)
            $0.top.equalTo(lensInfo.snp.bottom).offset(5)
        }
    }

    private func setFunctionAndDelegate() {
        imageScrollView.delegate = self
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
    }

    private func configureImageScrollView() {
        imageScrollView.contentSize.width = self.frame.width * CGFloat(images.count)

        for pageIndex in 0..<images.count {
            let imageView = UIImageView()
            let xPositionOrigin = self.frame.width * CGFloat(pageIndex)
            imageView.frame = CGRect(x: xPositionOrigin, y: 0, width: self.bounds.width, height: CGFloat(imageHeight))
            imageView.backgroundColor = .orange
            imageView.image = images[pageIndex]
            imageScrollView.addSubview(imageView)
        }
    }

    private func selectedPage(_ currentPage: Int) {
        pageControl.currentPage = currentPage
    }
}

//delegate
extension HeaderCollectionReusableView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let size = scrollView.contentOffset.x / scrollView.frame.size.width
        selectedPage(Int(round(size)))
    }
}

extension HeaderCollectionReusableView {
    @objc func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        imageScrollView.setContentOffset(CGPoint(x: CGFloat(current) * self.frame.size.width, y: 0), animated: true)
    }
}

extension HeaderCollectionReusableView {
    func getTotalViewHeight() -> CGFloat {
        var totalViewHeight: CGFloat = 0
        for view in subviews {
            totalViewHeight += view.frame.size.height
        }
        return totalViewHeight - 30
    }
}
