//
//  DetailsViewController.swift
//  ToDoForEM
//
//  Created by APashin on 07/03/2026.
//  Copyright © 2026 EM. All rights reserved.
//

import UIKit
import Foundation
import SnapKit

class DetailsViewController: UIViewController, DetailsViewInput {

    var output: DetailsViewOutput!

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }


    // MARK: DetailsViewInput
    func setupInitialState() {
    }
}
