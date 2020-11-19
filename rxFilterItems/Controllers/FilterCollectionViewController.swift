//
//  FilterCollectionViewController.swift
//  rxFilterItems
//
//  Created by Jad Messadi on 11/16/20.
//

import UIKit
import RxSwift
import RxCocoa

class FilterCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var selectedCategoryObservable = BehaviorRelay(value: -1)
    var chooseCategorySubject = PublishSubject<Category>()
    var chooseCategoryObservable : Observable<Category> {
        return chooseCategorySubject.asObservable()
    }
    var listCategories = [Category]()
    
    @IBOutlet weak var saveButton : UIBarButtonItem!
    @IBOutlet weak var resetButton : UIBarButtonItem!
    
    let disposeBag = DisposeBag()
    
    private var selectedCategory: Int? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategories()
        
        self.chooseCategoryObservable.subscribe(onNext : {  cat in
            self.saveButton.isEnabled = true
            self.saveButton.rx.tap.subscribe(onNext: { _ in
                self.selectedCategoryObservable.accept(cat.id)
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        self.resetButton.rx.tap.subscribe(onNext: { _ in
            self.selectedCategoryObservable.accept(0)
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
    }
    
    private func getCategories() {
        ListCategories.load(resource: ListCategories.all).subscribe(onNext : { result in
            if let result = result {
                self.listCategories = result.categories
            }
        }).disposed(by: disposeBag)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCategories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath as IndexPath) as! FilterCollectionViewCell
        let selected = indexPath.row == selectedCategory
        cell.data = self.listCategories[indexPath.row]
        cell.data.isSelected = selected
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateSelectedIndex(indexPath.row)
        chooseCategorySubject.onNext(listCategories[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = 5
        let width = Int(collectionView.frame.width) / 2 - padding
        let height = Int(collectionView.frame.height - 50) / 2 - padding
        return CGSize(width: width, height: height)
    }
    
    private func updateSelectedIndex(_ index: Int) {
        selectedCategory = index
    }
}

