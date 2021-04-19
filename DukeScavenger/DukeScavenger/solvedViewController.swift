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
    
    @IBAction func findHuntButton(_ sender: Any) {
        performSegue(withIdentifier: "returnHomeSegue", sender: self)
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
            vc.addProgress(rId: Int64(rID))
            vc.printDatabase(db: vc.database)
        }
        
        self.greatJob.isHidden = true
        self.findHunt.isHidden = true
        
        if rID%100 == 21 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                self.greatJob.isHidden = false
                self.findHunt.isHidden = false
            }
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
