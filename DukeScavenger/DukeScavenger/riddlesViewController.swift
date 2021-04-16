//
//  riddlesViewController.swift
//  DukeScavenger
//
//  Created by codeplus on 4/6/21.
//

import UIKit

class riddlesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    let vc = ViewController()
    
    var menuShowing = false
    var nums = (1...10).map{"Riddle \($0)"}
    
    private var tapGesture: UITapGestureRecognizer? = nil
    
    var solvedMode: [Bool] = [false]
    
    var solvedRiddle: [Bool] =  [false, false, true, true, false, false, true, true, false, false]
    
    @IBOutlet weak var tab: UIButton!
    @IBOutlet weak var solvedNotification: UIImageView!
    @IBAction func solvedSegue(_ sender: Any) {
        performSegue(withIdentifier: "solvedSegue", sender: self)
    }
    @IBOutlet weak var riddleName: UILabel!
    
    @IBOutlet weak var LeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var riddleTable: UITableView!
    
    @IBOutlet weak var answerButton: UIButton!
    
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var riddleText: UILabel!
    
    @IBOutlet weak var findHuntButton: UIButton!
    @IBAction func findHuntButton(_ sender: Any) {
        performSegue(withIdentifier: "returnHomeSegue", sender: self)
    }
    
    @IBOutlet var blurView: UIView!
    
    @IBAction func showHint(_ sender: Any) {
        performSegue(withIdentifier: "showHintSegue", sender: self)
    }
    
    @IBOutlet weak var passed: UIImageView!
    
    @IBAction func openMenu(_ sender: Any) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        if(menuShowing){
            LeadingConstraint.constant = -270
            self.navigationItem.setHidesBackButton(true, animated: true)
            for subview in blurView.subviews{
                if subview is UIVisualEffectView{
                    subview.removeFromSuperview()
                }
            }
        }
        else{
            LeadingConstraint.constant = 0
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(blurEffectView)
            self.view.addSubview(riddleTable)
            self.view.addSubview(tab)
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                self.navigationItem.setHidesBackButton(false, animated: true)
            }
            
            
        }
        menuShowing = !menuShowing
    }
    
    @IBAction func touchWasDetected(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: view)
        if (!riddleTable.frame.contains(touchPoint)){
            if(menuShowing){
                openMenu((Any).self)
            }
        }
        else{
            let row = riddleTable.indexPathForRow(at: touchPoint)![1]
            if row > 0 {
                
                let riddleTxt = vc.returnRiddleData(idnum: row + 100, select: "message")
                riddleName.text = "Riddle \(row)"
                riddleText.text = "\(riddleTxt)"
                openMenu((Any).self)
                if solvedRiddle[row-1]{
                    answerButton.isHidden = true
                    hintButton.isHidden = true
                    passed.isHidden = false
                    if row-1 == 9{ //if this is len-1 of the riddles array
                        print("finished riddle")
                    
                    }
                }
                else{
                    answerButton.isHidden = false
                    hintButton.isHidden = false
                    passed.isHidden = true
                }
            
        }
    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addBackground(imageName: "RiddleView")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        riddleName.text = "Riddle Number"
        passed.isHidden = true
        
        if solvedMode[0]{
            solvedNotification.isHidden = false
            findHuntButton.isHidden = false
            
            
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(blurEffectView)
            self.view.addSubview(solvedNotification)
            self.view.addSubview(findHuntButton)
        }
        else{
            solvedNotification.isHidden = true
            findHuntButton.isHidden = true
        }
        navigationItem.hidesBackButton = true
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section:Int) -> String? {
        return "All Riddles"
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .center
        header.contentView.backgroundColor = .init(red: 82/255, green: 163/255, blue: 211/255, alpha:0.8)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "riddleCell", for: indexPath)
            as! riddleTableViewCell
        
        // Configure the cell...
        cell.riddleNum.text = nums[indexPath.row]
        cell.riddleNum.font = UIFont.systemFont(ofSize: 22.0)
        cell.riddleNum.textColor = .white
        cell.riddleNum.textAlignment = .center
            

            
            return cell
        }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 10
        
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
        //tableView.contentInset.bottom = (-verticalPadding/2) + 40
        //tableView.contentInset.top = -verticalPadding/2
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
