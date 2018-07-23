//
//  paymentUsingStripe.swift
//  Hooga
//
//  Created by Omar Abbas on 1/30/17.
//  Copyright © 2017 Omar Abbas. All rights reserved.
//

import UIKit
import Stripe
import Alamofire


class paymentUsingStripe: UIViewController,STPPaymentCardTextFieldDelegate{


    @IBAction func dismissButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var addPayment: UIButton!
    let paymentTextField = STPPaymentCardTextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPayment.isHidden = true
//        let frame1 = CGRect(x: 20, y: 150, width: self.view.frame.size.width - 40, height: 40)
//        paymentTextField = STPPaymentCardTextField(frame: frame1)
//        paymentTextField.center = view.center
//        paymentTextField.delegate = self
//        view.addSubview(paymentTextField)
        addPayment.layer.borderWidth = 1
        addPayment.layer.borderColor = UIColor.lightGray.cgColor
        addPayment.layer.masksToBounds = true
        addPayment.layer.cornerRadius = 5
        addPayment.addTarget(self, action: #selector(alamoTest), for: .touchUpInside)
        
    }
    func addCard(){
     
//        let addCardViewController = STPAddCardViewController()
//        //addCardViewController.delegate = self
//        let navigationController = UINavigationController(rootViewController: addCardViewController)
//        self.present(navigationController, animated: true, completion: nil)
    }
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController){
        self.dismiss(animated: true, completion: nil)
    }
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        
    }
    func makeRequest(){
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: "https://api.stripe.com/v1/accounts/sk_test_dy8zFmWPveeKkLrUOqOhERZn") else {return}
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        let params = "managed=true&country=us"
        request.httpBody = params.data(using: .utf8, allowLossyConversion: true)
        
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                print("this is it",data as Any)
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
    }
    func alamoTest(){
        let headers: HTTPHeaders = [
        "Authorization":"Bearer sk_test_dy8zFmWPveeKkLrUOqOhERZn",
        "Content-Type":"application/x-www-form-urlencoded"]
        let url = "https://api.stripe.com/v1/accounts"
        let params = ["managed":"true","country":"US"]
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {(response) in
            print("this is what comes out", response)
            if let data = response.data {
                let json = String(data: data, encoding: String.Encoding.utf8)
                print("Response:\(json)")
            }
    }

}
}
