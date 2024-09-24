//
//  ResultViewController.swift
//  Map
//
//  Created by Rakesh Kumar on 24/09/24.
//

import UIKit
import CoreLocation

protocol ResultViewControllerDelegate: AnyObject {
    func ResultViewControllerDidTap(with coordinate: CLLocationCoordinate2D)
}

class ResultViewController: UIViewController {
    
    var placeArray: [Place] = [Place]()
    weak var delegate: ResultViewControllerDelegate?
    
    var resultTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(ResultTableViewCell.self, forCellReuseIdentifier: ResultTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(resultTableView)
        resultTableView.delegate = self
        resultTableView.dataSource = self
        for i in placeArray {
            print(i.place)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resultTableView.frame = view.bounds
    }
    
    func configure(with model: [Place]){
        resultTableView.isHidden = false
        placeArray = model
        DispatchQueue.main.async{
            self.resultTableView.reloadData()
        }
    }
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.identifier, for: indexPath) as? ResultTableViewCell else {
            return UITableViewCell()
        }
        let place = placeArray[indexPath.row].place
        cell.configure(with: place)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let place = placeArray[indexPath.row]
        GoogleManager.shared.resolveLocation(with: place) {[weak self] result in
            switch result {
            case .success(let data):
                self?.delegate?.ResultViewControllerDidTap(with: data)
                self?.resultTableView.isHidden = true
            case .failure(let error):
                print(error)
            }
        }
    }
}
