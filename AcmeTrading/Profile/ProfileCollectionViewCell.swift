//
//  ProfileCollectionViewCell.swift
//  AcmeTrading
//
//  Created by John Wilson on 29/10/2020.
//

import Foundation

protocol ProfileCollectionViewCellDelegate {
    func contact()
}

class ProfileCollectionViewCell: UICollectionViewCell {
    static let identifier = "ProfileCollectionViewCell"
    
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let distanceLabel = UILabel()
    let starLabel = UILabel()
    let ratingCountLabel = UILabel()
    let contactButton = GradientButton()
    
    var delegate: ProfileCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let topHeight: CGFloat = 96
        let bottomHeight: CGFloat = 150 - topHeight
        let topMargin: CGFloat = 18
        let topSpacing: CGFloat = 15
        let imageSize: CGFloat = topHeight - topMargin * 2
        
        let mainStackView = BetterStackView()
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.backgroundColor = .cellBackground
        self.addSubview(mainStackView)
        mainStackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        mainStackView.layer.cornerRadius = 5.0
        mainStackView.layer.shadowColor = UIColor.black.cgColor
        mainStackView.layer.shadowOpacity = 0.1
        mainStackView.layer.shadowOffset = CGSize(width: 0, height: 1)
        mainStackView.layer.shadowRadius = 1
        
        let topStackView = BetterStackView()
        topStackView.axis = .horizontal
        topStackView.alignment = .center
        topStackView.margin = topMargin
        topStackView.spacing = topSpacing
        topStackView.backgroundColor = .white
        mainStackView.addArrangedSubview(topStackView)
        topStackView.autoSetDimension(.height, toSize: topHeight)
        
        let imageContainer = UIView()
        imageContainer.addSubview(imageView)
        imageView.autoPinEdgesToSuperviewEdges()
        imageView.autoSetDimensions(to: CGSize(width: imageSize, height: imageSize))
        imageView.layer.cornerRadius = imageSize / 2.0
        imageView.clipsToBounds = true
        topStackView.addArrangedSubview(imageContainer)
        
        let labelStackView = BetterStackView()
        labelStackView.axis = .vertical
        labelStackView.alignment = .starting
        labelStackView.spacing = topSpacing / 3.0
        topStackView.addArrangedSubview(labelStackView)
        
        labelStackView.addArrangedSubview(nameLabel)
        nameLabel.textColor = UIColor.darkBlue
        nameLabel.font = UIFont.systemFont(ofSize: 18)
        labelStackView.addArrangedSubview(distanceLabel)
        distanceLabel.textColor = .gray
        distanceLabel.font = UIFont.systemFont(ofSize: 14)
        
        let bottomView = UIView()
        mainStackView.addArrangedSubview(bottomView)
        bottomView.autoSetDimension(.height, toSize: bottomHeight)
        starLabel.textColor = .darkBlue
        starLabel.font = UIFont.boldSystemFont(ofSize: 20)
        bottomView.addSubview(starLabel)
        starLabel.autoPinEdge(toSuperviewEdge: .top)
        starLabel.autoPinEdge(toSuperviewEdge: .left, withInset: topMargin)
        starLabel.autoPinEdge(toSuperviewEdge: .bottom)
        ratingCountLabel.textColor = .gray
        ratingCountLabel.font = UIFont.systemFont(ofSize: 14)
        bottomView.addSubview(ratingCountLabel)
        ratingCountLabel.autoPinEdge(toSuperviewEdge: .top)
        ratingCountLabel.autoPinEdge(toSuperviewEdge: .bottom)
        ratingCountLabel.autoPinEdge(.left, to: .right, of: starLabel)
        
        contactButton.setTitle("Contact", for: .normal)
        contactButton.setTitleColor(.white, for: .normal)
        contactButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        contactButton.gradientColors = [UIColor.darkBlue.cgColor, UIColor.lightBlue.cgColor]
        contactButton.addTarget(self, action: #selector(contactAction), for: .touchUpInside)
        contactButton.layer.cornerRadius = 5.0
        contactButton.clipsToBounds = true
        bottomView.addSubview(contactButton)
        contactButton.autoPinEdge(toSuperviewEdge: .top, withInset: 8.0)
        contactButton.autoPinEdge(toSuperviewEdge: .bottom, withInset: 8.0)
        contactButton.autoSetDimension(.width, toSize: 80)
        contactButton.autoPinEdge(toSuperviewEdge: .right, withInset: topMargin)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(withProfile profile: Profile) {
        nameLabel.text = profile.name
        var distance = profile.distanceFromUser
        if distance.hasSuffix("m") {
            distance.removeLast()
            distance.append(" miles away")
        }
        distanceLabel.text = distance
        if let url = URL(string: profile.profileImage) {
            imageView.load(url: url)
        }
        switch profile.starLevel {
        case 3:
            starLabel.text = "★★★"
        case 2:
            starLabel.text = "★★☆"
        case 1:
            starLabel.text = "★☆☆"
        default:
            starLabel.text = "☆☆☆"
        }
        starLabel.sizeToFit()
        ratingCountLabel.text = " (\(profile.numRatings))"
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        distanceLabel.text = ""
        imageView.image = nil
        starLabel.text = ""
        ratingCountLabel.text = ""
    }
    
    @objc func contactAction(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.contact()
        }
    }
}
