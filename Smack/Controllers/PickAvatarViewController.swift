//
//  PickAvatarViewController.swift
//  Smack
//
//  Created by Zhengshan Cao on 27/1/18.
//  Copyright © 2018 Zhengshan Cao. All rights reserved.
//

import UIKit

class PickAvatarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var delegate: isAbleToReceiveStringData?
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var avatarType = AvatarType.dark
    var selectedAvatar: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell {
            cell.configureCell(index: indexPath.item, type: avatarType)
            return cell
        } else {
            return AvatarCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            // dark is selected
            avatarType = .dark
        } else {
            avatarType = .light
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var numberOfColumn: CGFloat = 3
        if UIScreen.main.bounds.width > 320 {
            numberOfColumn = 4
        }
        
        let spaceBetweenCells: CGFloat = 10
        let padding: CGFloat = 40
        let cellDimension: CGFloat = ((collectionView.bounds.width - padding) - (numberOfColumn - 1) * spaceBetweenCells) / numberOfColumn
        
        return CGSize(width: cellDimension, height: cellDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var prefix: String = "dark"
        if avatarType == .light {
            prefix = "light"
        }
        selectedAvatar = prefix + "\(indexPath.item)"
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if selectedAvatar == "" { return }
        
        delegate?.pass(data: selectedAvatar)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
