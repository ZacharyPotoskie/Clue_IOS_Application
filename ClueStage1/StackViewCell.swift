//
//  StackViewCell.swift
//  ClueStage1
//
//  Created by Holly Pemberton on 9/16/18.
//  Copyright © 2018 Zack. All rights reserved.
//

import UIKit

class StackViewCell: UITableViewCell {
    
    var cellExists:Bool = false
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var stuffView: UIView! {
        didSet {
            stuffView?.isHidden = true
            stuffView?.alpha = 0
        }
    }
    @IBOutlet weak var headerButton: UIButton!
    @IBOutlet weak var asker: UILabel!
    @IBOutlet weak var responder: UILabel!
    @IBOutlet weak var suspect: UILabel!
    @IBOutlet weak var weapon: UILabel!
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var primaryResponse: UILabel!
    @IBOutlet weak var secondaryResponse: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor.white
    }
    
    func animate(duration:Double, c: @escaping () -> Void) {
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration, animations: {
                self.stuffView.isHidden = !self.stuffView.isHidden
                if self.stuffView.alpha == 1 {
                    self.stuffView.alpha = 0.5
                } else {
                    self.stuffView.alpha = 1
                }
            })
        }, completion: {    (finished: Bool) in
            c()
        })
    }

}
