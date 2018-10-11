# CryptoWallet
## iOS app for managing your cryptocurrency
### By Zaid Al Rakabi

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)


#### Description
For this app I have so far implemented the phone verification for CryptoWallet. Currently the app functions by taking in as input a US phone number. Then it parses, formats, and checks the number using the libPhoneNumberiOS library. If the phone number is accurate an alert message is displayed saying that a verification code will be sent. Otherwise an error alert is printed to try again.

#### Tech
* [libPhoneNumber-iOS](https://github.com/iziz/libPhoneNumber-iOS) - phone number verification & formatting
* [Material Design](https://material.io/) - UI elements including phone number field and verify button
* XCode 10 & Swift 4


#### Functions
  ##### VerifyPressed()
  - Action for the Verify Button to check the phone number the user has input
  - Has do() catch() for error handling
  - Gets phoneField input and validates using: **parse()**, **format()**,**isValidNumber()** from the libPhoneNumber-iOS library
   - If the Action is not valid throws an error and alerts the user using: **catchError**, **setGenerateAlert()**
   
##### catchError()
- checks the return of &nbsp; **isValidNumber()**
- if the phone Number is not valid then throws an invalidPhoneNumber error

##### setGenerateAlert()
- Initializes new UIAlertController with the passes in alertTitle and Message
- Then adds an action through &nbsp; **.addAction()** to generate a UIAlertAction as an **OK** button to cancel the alert.

##### touchesBegan()
- Once the user touches away from phone number field it goes away by using &nbsp; **.resignFirstResponder()**

##### textField()
- Function in the Extension of the UITextFieldDelegate
- Takes whatever is being input into the text field and formats it continouously using the &nbsp; **format()** function

##### format()
- Function to format 10 digit phone numbers continuously
- formats the number by checking the digits and calling &nbsp; **replacingOccurrences()**

