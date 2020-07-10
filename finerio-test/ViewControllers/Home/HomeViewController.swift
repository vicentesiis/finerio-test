//
//  HomeViewController.swift
//  finerio-test
//
//  Created by Macintosh HD on 09/07/20.
//  Copyright © 2020 vicentesiis. All rights reserved.
//

import UIKit

fileprivate let CHARGE = "CHARGE"

class HomeViewController: UIViewController {
    
    @IBOutlet weak var movementsTableView: UITableView!
    
    private var offset = 0
    private var movements: [MovementsData] = []
    private var needReload = true
    
    private var spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        title = defaults.string(forKey: "Email")
        
        getMovements()
        movementsTableView.estimatedRowHeight = movementsTableView.frame.size.height / CGFloat(10)
        
    }
    
    private func getMovements() {
        
        let defaults = UserDefaults.standard
        let userID = defaults.string(forKey: "UserID")
        
        let parameters = [
            "deep": true,
            "offset": offset,
            "max": 10,
            "includeCharges": true,
            "includeDeposits": true,
            "includeDuplicates": false
        ] as [String : Any]
        
        RestAPI.movements(userID: userID ?? "", parameters: parameters) { (response) in
            
            switch response {
                
            case .success(let movements):
                
                if movements.data.count > 0 {
                    self.movements.append(contentsOf: movements.data.map({$0}))
                    self.movementsTableView.reloadData()
                    self.spinner.stopAnimating()
                } else {
                    self.spinner.stopAnimating()
                    self.needReload.toggle()
                }
                
            case .failure(let error): print(error.localizedDescription)
                
            }
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        if y >= h && h > 0 {
            if needReload {
                self.offset += 10
                getMovements()
            }
        }
        
    }

}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return movementsTableView.frame.size.height / CGFloat(10)
    }
    
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = movementsTableView.dequeueReusableCell(withIdentifier: "detail_cell") as! DetailTableViewCell
        
        let movement = movements[indexPath.row]
        
        cell.movementImage.image = UIImage(named: "dinerio_shield")
        cell.movementDetail.text = movement.description
        cell.date.text = ISO8601DateFormatter().date(from: movement.date)?.getFormattedDate(format: "dd-MM-yy")
        
        let concept = movement.concepts.first
        
        cell.amount.text = "$" + String(concept?.amount ?? 0.0)
        cell.amount.textColor = movement.type == CHARGE ? .red : .green
        
        let category = concept?.category
        
        cell.categoryLabel.text = category?.name ?? ""
        cell.categoryView.backgroundColor = UIColor(hexString: category?.color ?? "")
        
        let parent = category?.parent
        
        cell.categoryImage.image = UIImage(named: (parent?.id ?? "").components(separatedBy: "-").last ?? "")
        
        return cell
        
    }
    
}
