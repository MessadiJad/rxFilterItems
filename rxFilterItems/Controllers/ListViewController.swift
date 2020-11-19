//
//  ListViewController.swift
//  rxFilterItems
//
//  Created by Jad Messadi on 11/16/20.
//

import UIKit
import RxSwift
import RxCocoa

class ListViewController: UITableViewController {
    
    var itemsSubject = BehaviorSubject<[Item]>(value: [])
    var itemsObservable : Observable<[Item]> {
        return itemsSubject.asObservable()
    }
    var filtredListItems: [Item] = []
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        getItems()
    }
    
    private func getItems() {
        ListItems.load(resource: ListItems.all).subscribe(onNext : { result in
            self.itemsSubject.onNext(result!.items)
        }).disposed(by: disposeBag)
        
        self.itemsObservable.subscribe(onNext: { items in
            self.filtredListItems  = items
            self.refreshList()
        }).disposed(by: self.disposeBag)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtredListItems.count == 0 {
            self.tableView.setEmptyMessage("There are no items to show")
        } else {  self.tableView.restore() }
        return filtredListItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ListViewControllerCell
        cell.itemTitle?.text = filtredListItems[indexPath.row].title
        cell.itemDescription?.text = filtredListItems[indexPath.row].description
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController,
              let homeVC = navC.viewControllers.first as? FilterCollectionViewController else { fatalError("Segue destination is not found") }
        
        homeVC.selectedCategoryObservable.subscribe(onNext: { category in
            if category == 0 {
                self.itemsSubject.map{ items in
                    self.filtredListItems = items
                }.subscribe().disposed(by: self.disposeBag)
                self.refreshList()
            }else if category > 0 {
                self.itemsObservable.map{ items in
                    items.filter { itm in
                        itm.categoryId == category
                    }
                }.subscribe(onNext: { filterdList in
                    self.filtredListItems = filterdList
                    self.refreshList()
                }).disposed(by: self.disposeBag)
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func refreshList() {
        self.tableView.reloadData()
    }
    
}

