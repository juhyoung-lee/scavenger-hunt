//
//  solvedViewController.swift
//  
//
//  Created by codeplus on 4/11/21.
//

import UIKit

class solvedViewController: UIViewController {
    var vc = ViewController()

    @IBOutlet weak var solvedText: UILabel!
    var rID: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addBackground(imageName: "solvedBackground")
        
        solvedText.text = vc.returnRiddleData(idnum: rID, select: "blurb")
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
