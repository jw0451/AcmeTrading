//
//  ProfileListViewModel.swift
//  AcmeTrading
//
//  Created by John Wilson on 29/10/2020.
//

import Foundation

class ProfileListViewModel {
    var profiles = [Profile]()
    
    func getProfiles(completionHandler: @escaping (Bool) -> Void) {
        APIService().getProfileList() { (profileListResponse, error) in
            if let error = error {
                print(error)
                completionHandler(false)
            }
            if let profiles = profileListResponse?.data.profiles {
                self.profiles = profiles
                completionHandler(true)
            }
        }
    }
    
    func numberOfProfiles() -> Int {
        return profiles.count
    }
    
    func profile(forIndexPath indexPath: IndexPath) -> Profile {
        return profiles[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }
}
