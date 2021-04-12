//
//  solvedViewController.swift
//  
//
//  Created by codeplus on 4/11/21.
//

import UIKit

class solvedViewController: UIViewController {

    @IBAction func solvedSegue(_ sender: Any) {
        performSegue(withIdentifier: "returnSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addBackground(imageName: "solvedBackground")
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
