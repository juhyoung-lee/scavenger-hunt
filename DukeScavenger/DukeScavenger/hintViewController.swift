//
//  hintViewController.swift
//  DukeScavenger
//
//  Created by codeplus on 4/14/21.
//

import UIKit

class hintViewController: UIViewController {

    @IBOutlet weak var answerText: UILabel!
    @IBOutlet weak var answer: UIImageView!
    private var tapGesture: UITapGestureRecognizer? = nil
    var answerShowing = false
    
    @IBOutlet var blurView: UIView!
    
    @IBAction func showAnswer(_ sender: Any) {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        if !answerShowing{
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(blurEffectView)
            self.view.addSubview(answer)
            self.view.addSubview(answerText)
            
            answer.isHidden = false
            answerText.isHidden = false
        }
        else{
            for subview in blurView.subviews{
                if subview is UIVisualEffectView{
                    subview.removeFromSuperview()
                }
            }
            answer.isHidden = true
            answerText.isHidden = true
        }
        answerShowing = !answerShowing
    }
    
    @IBAction func tapDetected(_ sender: Any) {
        if answerShowing{
            let touchPoint = (sender as AnyObject).location(in: view)
            if (!answer.frame.contains(touchPoint)){
                showAnswer((Any).self)
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addBackground(imageName: "hint-page")
        answer.isHidden = true
        answerText.isHidden = true
        
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
