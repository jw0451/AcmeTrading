//
//  ProfileListViewController.swift
//  AcmeTrading
//
//  Created by John Wilson on 27/10/2020.
//

import UIKit

class ProfileListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ProfileCollectionViewCellDelegate {

    private var collectionView: UICollectionView?
    private let viewModel = ProfileListViewModel()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 150)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 60)
                
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.collectionView = collectionView
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        collectionView.register(ProfileListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.backgroundColor
        self.view.addSubview(collectionView)
        collectionView.autoPinEdgesToSuperviewEdges()
        refreshList()
        
        refreshControl.tintColor = .accentTeal
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc func refreshList() {
        viewModel.getProfiles { (_) in
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfProfiles()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as? ProfileCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let profile = viewModel.profile(forIndexPath: indexPath)
        cell.setup(withProfile: profile)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let headerView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath)
        headerView.frame.size.height = 60
        headerView.backgroundColor = .white
        
        let logoImage = UIImage(named: "Logo")
        let logo = UIImageView(image: logoImage)
        logo.contentMode = .scaleAspectFit
        headerView.addSubview(logo)
        logo.autoPinEdgesToSuperviewEdges()

        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        headerView.addSubview(backgroundView)
        backgroundView.autoPinEdge(.bottom, to: .top, of: headerView)
        backgroundView.autoSetDimensions(to: CGSize(width: UIScreen.main.bounds.width, height: 300))
        
        let button = UIButton()
        button.setTitle("Menu", for: .normal)
        button.setTitleColor(UIColor.accentTeal, for: .normal)
        button.addTarget(self, action: #selector(menuAction), for: .touchUpInside)
        headerView.addSubview(button)
        button.autoAlignAxis(toSuperviewAxis: .horizontal)
        button.autoPinEdge(toSuperviewEdge: .right, withInset: 20)
        
        return headerView
    }
    
    func contact() {
        let alertController = UIAlertController(title: "Message sent", message:
            "They'll get back to you", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Got it", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func menuAction() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (action) in
            UserManager.shared.logout()
            self.navigationController?.popViewController(animated: true)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
}

class ProfileListHeaderView: UICollectionReusableView {}
