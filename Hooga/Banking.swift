//
//  Banking.swift
//  Hooga
//
//  Created by Omar Abbas on 12/10/16.
//  Copyright © 2016 Omar Abbas. All rights reserved.
//

import UIKit
import Stripe

class Banking: UIViewController, CardIOPaymentViewControllerDelegate,STPPaymentCardTextFieldDelegate {
    
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var creditCardNumber: UITextField!
    @IBOutlet weak var cvsNumber: UITextField!
    @IBOutlet weak var expirationDate: UITextField!
    
    var paymentTextField = STPPaymentCardTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame1 = CGRect(x: 20, y: 150, width: self.view.frame.size.width - 40, height: 40)
                paymentTextField = STPPaymentCardTextField(frame: frame1)
                paymentTextField.center = view.center
                paymentTextField.delegate = self
                view.addSubview(paymentTextField)

                
        // Do any additional setup after loading the view, typically from a nib.
        CardIOUtilities.preload()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scanCard(_ sender: Any) {
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
    }
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        resultLabel.text = "user canceled"
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            let str = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
            resultLabel.text = str as String
        }
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
}

