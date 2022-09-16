//
//  ViewController.swift
//  WeatherBrick
//
//  Created by Oleksandr Melnyk on 16.09.2022.
//  Copyright © 2022 VAndrJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
    }
    
    
}
