//
//  introViewController.swift
//  DukeScavenger
//
//  Created by codeplus on 4/2/21.
//

import UIKit

class introViewController: UIViewController {

    @IBAction func riddleSegue(_ sender: Any) {
        performSegue(withIdentifier: "riddleSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addBackground()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
