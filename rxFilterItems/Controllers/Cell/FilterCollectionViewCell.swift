//
//  FilterCollectionViewCell.swift
//  rxFilterItems
//
//  Created by Jad Messadi on 11/16/20.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var checkBox: UIImageView!
    var data: Category! {
        didSet {
            self.categoryTitle.text = data.type
            if (data.isSelected) {
                self.checkBox.image = UIImage(named:"check.png")
            } else {
                self.checkBox.image = UIImage(named:"uncheck.png")
            }
        }
    }
}
