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
        $0.isPagingEnabled = true
        $0.isScrollEnabled = true
    }

    private let imageHeight: Int = 400
    private let profileImageSize: Int = 45

    private let images: [UIImage?] = [UIImage(named: "port1"), UIImage(named: "port2"), UIImage(named: "port3"), UIImage(named: "port4")]

    private lazy var pageControl = UIPageControl().then {
        $0.numberOfPages = images.count
        $0.backgroundColor = .clear
        $0.pageIndicatorTintColor = .gray
        $0.currentPageIndicatorTintColor = .mainYellow
    }

    // seller information

    private let sellerInformationCell = UIView().then {
        $0.isUserInteractionEnabled = true
    }

    private let sellerNickName = UILabel().then {
        $0.text = "곽규보 작가님"
        $0.font = .preferredFont(forTextStyle: .title3, weight: .bold)
    }

    private let sellerInformation = UILabel().then {
        $0.text = "#우정사진 #필름사진 #웨딩촬영"
        $0.font = .preferredFont(forTextStyle: .footnote, weight: .light)
        $0.textColor = .systemGray
    }

    private lazy var sellerProfileImage = UIImageView().then {
        $0.image = UIImage(named: "장루키")
        $0.layer.cornerRadius = CGFloat(profileImageSize / 2)
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }

    private let firstSeperator = UIView().then {
        $0.backgroundColor = .systemGray4
    }

    private let introductionLabel = UILabel().then {
        $0.text = "자기소개"
        $0.font = .preferredFont(forTextStyle: .footnote, weight: .regular)
        $0.textColor = .systemGray
    }

    private let introductionTextView = UITextView().then {
        $0.text = "저는 송도에 거주하며 인천대에 재학중입니다. 송도와 영종도 부근을 많이 찍어봤고 주로 커플 스냅을 많이 찍습니다.편하게 연락주세요!"
        $0.isScrollEnabled = false
        $0.font = .preferredFont(forTextStyle: .callout, weight: .regular)
        $0.isUserInteractionEnabled = false
    }

    override init (frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews(imageScrollView, pageControl, sellerInformationCell, sellerProfileImage, sellerNickName, sellerInformation, introductionLabel, introductionTextView)
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

        // sellerInformaiton
        sellerInformationCell.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageScrollView.snp.bottom).offset(5)
            $0.width.equalToSuperview().inset(20)
            $0.height.equalTo(70)
        }

        sellerInformationCell.addSubviews(sellerProfileImage, sellerNickName, sellerInformation)

        sellerProfileImage.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(profileImageSize)
            $0.height.equalTo(profileImageSize)
        }

        sellerNickName.snp.makeConstraints {
            $0.leading.equalTo(sellerProfileImage.snp.trailing).offset(10)
            $0.top.equalTo(sellerProfileImage)
        }

        sellerInformation.snp.makeConstraints {
            $0.leading.equalTo(sellerNickName)
            $0.top.equalTo(sellerNickName.snp.bottom).offset(5)
        }

        introductionLabel.snp.makeConstraints {
            $0.leading.equalTo(sellerProfileImage)
            $0.top.equalTo(sellerInformationCell.snp.bottom).offset(5)
        }

        introductionTextView.snp.makeConstraints {
            $0.leading.equalTo(introductionLabel)
            $0.width.equalToSuperview().inset(20)
            $0.top.equalTo(introductionLabel.snp.bottom).offset(5)
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
