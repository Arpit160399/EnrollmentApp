//
//  FormPage.swift
//  EnrollmentApp
//
//  Created by Arpit Singh on 25/10/20.
//

import Firebase
import UIKit

class FormPage: UIView {
    @IBOutlet var TelPhoneField: UITextField!
    @IBOutlet var PhoneField: UITextField!
    @IBOutlet var HomeField: UITextField!
    @IBOutlet var stateField: UITextField!
    @IBOutlet var countryField: UITextField!
    @IBOutlet var genderField: UITextField!
    @IBOutlet var dobFiled: UITextField!
    @IBOutlet var lastNameFiled: UITextField!
    @IBOutlet var fristNameField: UITextField!
    @IBOutlet var bottomConstrantButton: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var profileImage: UIImageView!
    private let pickerController = UIImagePickerController()
    var presentationController: UIViewController?
    var activefiled: UITextField!
    var selectedImage: UIImage?
    lazy var messageView = ErrorMessage(parent: self, type: .normal)
    var datePickerView: UIDatePicker = UIDatePicker()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func load() -> FormPage {
        let view = UINib(nibName: "FormPage", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FormPage
        return view
    }

    func setUpViews() {
        profileImage.isUserInteractionEnabled = true
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image", "public.movie"]
        pickerController.sourceType = .photoLibrary
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ShowImagepicker)))
    }

    func setTextFiledBorder() {
        [TelPhoneField, PhoneField, HomeField, stateField, countryField, genderField, dobFiled, lastNameFiled, fristNameField].forEach { textfiled in
            textfiled?.layer.borderWidth = 0.9
            textfiled?.layer.borderColor = UIColor(named: "primaryColor")?.cgColor
            textfiled?.layer.cornerRadius = 7
        }
        datePickerView.datePickerMode = .date
        datePickerView.preferredDatePickerStyle = .wheels
        datePickerView.maximumDate = Date()
        dobFiled.inputView = datePickerView
        setUpViews()
        setupKeyBoardManagement()
    }

    @IBAction func AddUserData(_ sender: UIButton) {
        
        guard let gender = genderField.text else {
            messageView.show(message: "enter gender", type: .error)
            return
        }
        guard let homeField = HomeField.text else {
            messageView.show(message: "enter Home address", type: .error)
            return
        }
        guard let state = stateField.text else {
            messageView.show(message: "enter state address", type: .error)
            return
        }
        guard let country = countryField.text else {
            messageView.show(message: "enter country", type: .error)
            return
        }
        
        if NameVaildtion(), formDateField(), validaPhoneNumber() {
            let time: NSNumber = NSNumber(value: Int(NSDate().timeIntervalSince1970))
            sender.isEnabled = false
            sender.alpha = 0.5
            var userData = UserModel(firstName: fristNameField.text!, LastName: lastNameFiled.text!, phoneNumber: PhoneField.text!, telPhone: TelPhoneField.text!, DoB: dobFiled.text!, state: state, profileImageUrl: "", country: country, gender: gender, Home: homeField, creationTime: time)
        if let uploadImage = selectedImage?.jpegData(compressionQuality: 0.1) {
            saveImage(uploadImage) { (error, url) in
                if error != nil {
                    sender.isEnabled = true
                    sender.alpha = 1
                    self.messageView.show(message: error.debugDescription, type: .error)
                }
                guard let url = url else { return }
                userData.profileImageUrl = url
                self.saveData(userData.mapdata(), sender)
            }
        } else {
            sender.isEnabled = true
            sender.alpha = 1
            messageView.show(message: "select the profile Image", type: .error)
        }
      }
    }
}
//MARK:- Firebase Actions
extension FormPage {
    fileprivate func saveImage(_ uploadImage: Data,compiltion: @escaping (_ error:Error?,_ url: String?) -> ()){
        let imageName = NSUUID().uuidString
        let Stroage = Storage.storage().reference().child("Profile_Image").child("\(imageName).jpg")
            Stroage.putData(uploadImage, metadata: nil, completion: { _, error in
                if error != nil {
                    compiltion(error,nil)
                    return
                }
                Stroage.downloadURL(completion: { url, Error in
                    if Error != nil {
                        compiltion(Error,nil)
                        return
                    }

                    guard let url = url else { return }
                    compiltion(nil,url.absoluteString)
                })
            })
    }
    
   fileprivate func saveData(_ newuser: [String: Any], _ sender: UIButton) {
        let userRef = Database.database().reference().child("users").childByAutoId()
        userRef.setValue(newuser) { error, _ in
            if error != nil {
                self.messageView.show(message: error.debugDescription, type: .error)
                sender.isEnabled = true
                sender.alpha = 1
            } else {
                self.messageView.show(message: "User Added", type: .succes)
                sender.isEnabled = true
                sender.alpha = 1
            }
        }
    }
}

// MARK: - Image Picker

extension FormPage: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func ShowImagepicker() {
        presentationController?.present(pickerController, animated: true, completion: nil)
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        pickerController.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        guard let image = info[.editedImage] as? UIImage else {
            return pickerController.dismiss(animated: true, completion: nil)
        }
        selectedImage = image
        profileImage.image = image
        pickerController.dismiss(animated: true, completion: nil)
    }
}

//MARK:-  KeyboredMangagement
extension FormPage: UITextFieldDelegate {
    // MARK: add the event handelr for keyboard will appear

    func setupKeyBoardManagement() {
        countryField.delegate = self
        lastNameFiled.delegate = self
        fristNameField.delegate = self
        PhoneField.delegate = self
        TelPhoneField.delegate = self
        HomeField.delegate = self
        stateField.delegate = self
        genderField.delegate = self
        dobFiled.delegate = self
        TelPhoneField.keyboardType = .numberPad
        PhoneField.keyboardType = .numberPad
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDoneEditing)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.width, height: 30))
        let fexl = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(viewDoneEditing))
        toolbar.setItems([fexl, done], animated: false)
        toolbar.sizeToFit()
        countryField.inputAccessoryView = toolbar
        lastNameFiled.inputAccessoryView = toolbar
        fristNameField.inputAccessoryView = toolbar
        PhoneField.inputAccessoryView = toolbar
        TelPhoneField.inputAccessoryView = toolbar
        HomeField.inputAccessoryView = toolbar
        stateField.inputAccessoryView = toolbar
        genderField.inputAccessoryView = toolbar
        let datebar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.width, height: 30))
        let pickerdone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(datePicked))
        datebar.setItems([fexl, pickerdone], animated: false)
        datebar.sizeToFit()
        dobFiled.inputAccessoryView = datebar
    }

    @objc func viewDoneEditing() {
        endEditing(true)
    }

    @objc func datePicked() {
        let format = DateFormatter()
        format.dateStyle = .short
        let date = format.string(from: datePickerView.date)
        dobFiled.text = date
        endEditing(true)
    }

    // MARK: Set UP Keyboard scolling logic

    @objc func keyboardDidShow(notification: NSNotification) {
        if let active = activefiled {
            let info = notification.userInfo! as NSDictionary
            let value = info.value(forKey: UIResponder.keyboardFrameBeginUserInfoKey) as! NSValue
            let keyboard = value.cgRectValue.size
            bottomConstrantButton.constant = keyboard.height + 20
            bottomConstrantButton.isActive = true
            let constentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboard.height + 160, right: 0)
            scrollView.contentInset = constentInset
            var rect = frame
            rect.size.height -= keyboard.height
            let fieldRect = active.frame
            let activefieldPostion = CGPoint(x: fieldRect.origin.x, y: fieldRect.origin.y)
            if !rect.contains(activefieldPostion) {
                scrollView.scrollRectToVisible(fieldRect, animated: true)
            }
        }
    }

    @objc func keyboardDidHide() {
        scrollView.contentInset = .zero
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        activefiled = textField
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        activefiled?.resignFirstResponder()
        bottomConstrantButton.constant = 20
        bottomConstrantButton.isActive = true
        activefiled = nil
    }
}

// MARK: - Form Vaildation

extension FormPage {
   fileprivate func formDateField() -> Bool {
        guard let dob = dobFiled.text else {
            messageView.show(message: "enter Date of Birth", type: .error)
            return false
        }
        let format = DateFormatter()
        format.dateStyle = .short
        guard format.date(from: dob) != nil else {
            messageView.show(message: "enter a valide Date of Birth", type: .error)
            return false
        }
        return true
    }

   fileprivate func NameVaildtion() -> Bool {
        guard let firstname = fristNameField.text else {
            messageView.show(message: "enter firstName", type: .error)
            return false
        }
        guard let lastName = lastNameFiled.text else {
            messageView.show(message: "enter LastName", type: .error)
            return false
        }
        let nameRegex = "^\\w{3,18}$"
        let firstNameTrimmed = firstname.trimmingCharacters(in: .whitespaces)
        let lastNameTrimmed = lastName.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateFirstName = validateName.evaluate(with: firstNameTrimmed)
        let isValidateLastName = validateName.evaluate(with: lastNameTrimmed)
        if !isValidateLastName {
            messageView.show(message: "enter vaild LastName", type: .error)
        }

        if !isValidateLastName {
            messageView.show(message: "enter vaid FirstName", type: .error)
        }

        return isValidateLastName || isValidateFirstName
    }

    fileprivate func validaPhoneNumber() -> Bool {
        guard let phone = PhoneField.text else {
            messageView.show(message: "enter  Phone Number", type: .error)
            return false
        }
        guard let telphone = TelPhoneField.text else {
            messageView.show(message: "enter telephone Number", type: .error)
            return false
        }

        if phone.count != 10 {
            messageView.show(message: "enter valid Phone Number", type: .error)
            return false
        }
        if telphone.count < 8 || telphone.count > 15 {
            messageView.show(message: "enter valid telePhone Number", type: .error)
            return false
        }
        return true
    }
    
}
