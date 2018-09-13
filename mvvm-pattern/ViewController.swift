//
//  ViewController.swift
//  mvvm-pattern
//
//  Created by Watanabe Takehiro on 2018/09/13.
//  Copyright © 2018年 Watanabe Takehiro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func btnTapped(_ sender: UIButton) {
        let sb = self.storyboard!
        let vc = sb.instantiateViewController(withIdentifier: "second") as! SecondViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true, completion: nil)
//        self.performSegue(withIdentifier: "test", sender: nil)
    }
}

