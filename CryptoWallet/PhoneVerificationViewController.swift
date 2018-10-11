//
//  ViewController.swift
//  CryptoWallet
//
//  Created by Zaid Alrakabi on 10/5/18.
//  Copyright © 2018 Zaid Alrakabi. All rights reserved.
//

import UIKit
import libPhoneNumber_iOS
import MaterialComponents.MaterialTextFields

class PhoneVerificationViewController: UIViewController {
    
    //Define types of Error for Input Validation
    enum PhoneNumError: Error{
        case invalidNumber
    }
    
    var generateAlert: UIAlertController = UIAlertController() //Define UI Alerts
    
    //UI text field implemented from Material Design
    @IBOutlet weak var phoneNumField: MDCTextField! = {
        let phoneNumField = MDCTextField()
        phoneNumField.translatesAutoresizingMaskIntoConstraints = false
        phoneNumField.clearButtonMode = .unlessEditing
        phoneNumField.backgroundColor = .white
        return phoneNumField
    }()
    
    @objc func didTapVerify(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //UI Button implemented from Material Design
    @IBOutlet weak var VerifyButton: MDCRaisedButton! = {
        let VerifyButton = MDCRaisedButton()
        VerifyButton.translatesAutoresizingMaskIntoConstraints = false
        VerifyButton.setTitle("Verify", for: .normal)
        VerifyButton.addTarget(self, action: #selector(didTapVerify(sender:)), for: .touchUpInside)
        return VerifyButton
    }()
    
    //Once Verify Button is pressed Check to see if the input is correct
    @IBAction func VerifyPressed(_ sender: Any){
        //check to see if number is valid, if not throw an error
        
        let phoneUtil = NBPhoneNumberUtil()

        
        do {
            let phoneNumber: NBPhoneNumber = try phoneUtil.parse(phoneNumField.text, defaultRegion: "US")
            let formattedString: String = try phoneUtil.format(phoneNumber, numberFormat: .E164)
            let isPhone = phoneUtil.isValidNumber(phoneNumber)
        
            try catchError(isPhone: isPhone)
            
            //Phone number is valid so send verification code
            if(isPhone == true){
                if let validNum = phoneNumField.text{
                setGenerateAlert(alertTitle: "Valid Phone Number.", alertMessage: "Please wait for a verificaition code to: \(validNum)")
                }

            }
            NSLog("[%@]", formattedString)
        }
        catch PhoneNumError.invalidNumber{
            setGenerateAlert(alertTitle: "Invalid Phone Number.", alertMessage: "Please enter a valid number: (XXX) XXX - XXXX.")
            print("Invalid Number. Please try again.")
        }
        catch let error as NSError {
            setGenerateAlert(alertTitle: "Nothing was entered.", alertMessage: "Please enter a valid number: (XXX) XXX - XXXX.")
            print(error.localizedDescription)
        }
        
    }
    
    //Catches invalidNumber error
    func catchError(isPhone: Bool) throws{
        if isPhone != true {
            throw PhoneNumError.invalidNumber
        }
    }
     //var phoneEntry = phoneNumField.text
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumField.delegate = self
        
    }
    
    //Once user clicks out of phone number field it resigns
    override func touchesBegan(_ touches: Set<UITouch>, with: UIEvent?){
        phoneNumField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //general function for generating UIAlerts
    func setGenerateAlert(alertTitle: String, alertMessage: String){
        generateAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        generateAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(generateAlert, animated: true, completion: nil)
    }

}

//Extend UITextField to format input
extension PhoneVerificationViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        
        var fullString = textField.text ?? ""
        fullString.append(string)
        if range.length == 1 {
            textField.text = format(phoneNumber: fullString, shouldRemoveLastDigit: true)
        }
        else {
            textField.text = format(phoneNumber: fullString)
        }
        return false
    }
}

//Format function formats phone numbers as they are being entered
//Inspiration from tutorial on: ivrodriguez.com/format-phone-numbers-in-swift

func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
    guard !phoneNumber.isEmpty else { return "" }
    guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
    let r = NSString(string: phoneNumber).range(of: phoneNumber)
    var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")
    
    if number.count > 10 {
        
        let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
        number = String(number[number.startIndex..<tenthDigitIndex])
    }
    
    if shouldRemoveLastDigit {
        let end = number.index(number.startIndex, offsetBy: number.count-1)
        number = String(number[number.startIndex..<end])
    }
    
    if number.count < 7 {
        let end = number.index(number.startIndex, offsetBy: number.count)
        let range = number.startIndex..<end
        number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)
        
    } else {
        let end = number.index(number.startIndex, offsetBy: number.count)
        let range = number.startIndex..<end
        number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
    }
    
    return number
}


