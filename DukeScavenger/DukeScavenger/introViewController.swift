//
//  introViewController.swift
//  DukeScavenger
//
//  Created by codeplus on 4/2/21.
//

import UIKit

class introViewController: UIViewController {

    @IBOutlet weak var campusToggle: UISegmentedControl!
    @IBAction func riddleSegue(_ sender: Any) {
        performSegue(withIdentifier: "startHuntSegue", sender: self)
    }
    @IBOutlet weak var riddleDescript: UILabel!
    
    let vc = ViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addBackground()
        riddleDescript.text = vc.returnHuntData(idnum: 1, select: "descript") as? String
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! riddlesViewController
        if campusToggle.selectedSegmentIndex == 0{
            destVC.gCampus = 2
        }
        else{
            destVC.gCampus = 1
        }
        
    }

}
