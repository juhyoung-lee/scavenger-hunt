//
//  solvedViewController.swift
//
//
//  Created by codeplus on 4/11/21.
//

import UIKit

class solvedViewController: UIViewController {
    var vc = ViewController()

    @IBOutlet weak var greatJob: UIImageView!
    @IBOutlet weak var findHunt: UIButton!
    @IBOutlet weak var congratsSolved: UIButton!
    
    @IBAction func findHuttonButton(_ sender: Any) {
        performSegue(withIdentifier: "returnHomeSegue", sender: self)
    }

    @IBAction func congratsButton(_ sender: Any) {
        self.greatJob.isHidden = false
        self.findHunt.isHidden = false
        self.congratsSolved.isHidden = true
    }
    
    @IBOutlet weak var solvedText: UILabel!
    var rID: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        view.addBackground(imageName: "solvedBackground")
        if rID == 0 {
            solvedText.text = "This is where you would get the answer and extra fun information about the location."
        }
        else{
            solvedText.text = vc.returnRiddleData(idnum: rID, select: "blurb")
            solvedText.textColor = .black
            vc.addProgress(rId: Int64(rID))
            //vc.printDatabase(db: vc.database)
        }
        
        self.greatJob.isHidden = true
        self.findHunt.isHidden = true
        self.congratsSolved.isHidden = true
        
        if rID%100 == 21 {
            self.congratsSolved.isHidden = false
        }

    }
    

/*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)

        if let ViewController = segue.destination as? ViewController {
            ViewController.modalPresentationStyle = .fullScreen
        }
    }
 */

}
