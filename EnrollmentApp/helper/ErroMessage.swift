//
//  ErroMessage.swift
//  EnrollmentApp
//
//  Created by Arpit Singh on 26/10/20.
//

import UIKit

class ErrorMessage: UIView {
    
    
    enum MessageType {
        case error
        case waring
        case succes
    }
    enum ParentView {
        case normal
    }
    
 private var messageIsDisplayed = false
 private var messageHeight : NSLayoutConstraint?
 private let icon = UIImageView()
 private var pendingRequest: DispatchWorkItem?
 private let erromessage : UILabel = {
        let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        return label
        
    }()
  private var parentView : UIView
   private let subview = UIView()
    private  var  viewType : ParentView = .normal
    init(parent: UIView,type : ParentView) {
        viewType = type
          parentView = parent
        super.init(frame: .zero)
        subview.layer.cornerRadius = subview.DPI(size: 10)
        subview.layer.shadowOpacity = 0.4
        subview.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        self.addSubview(subview)
        subview.addSubview(erromessage)
        icon.contentMode = .scaleAspectFit
        icon.tintColor = .white
        subview.addSubview(icon)
        subview.anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor,padding: .init(top: 5, left: 5, bottom: -5, right: -5))
        icon.anchor(top: subview.topAnchor, bottom: subview.bottomAnchor, left: subview.leftAnchor, right: nil, size: .init(width: icon.DPI(size: 22), height: DPI(size: 22)), padding: .init(top: 5, left: 5, bottom: -5, right: 0))
        erromessage.anchor(top: subview.topAnchor, bottom: subview.bottomAnchor, left: icon.rightAnchor, right: subview.rightAnchor,padding: .init(top: 5, left: 5, bottom: -5, right: -5))
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
  
    private func addMessageView(){
        switch viewType {
        case .normal: do {
            parentView.addSubview(self)
            self.anchor(top: parentView.topAnchor, bottom: nil, left: parentView.leftAnchor, right: parentView.rightAnchor,padding: .init(top: 110, left: 10, bottom: 0, right: -10))
           
            }
        }
        self.widthAnchor.constraint(equalToConstant: parentView.frame.width - 20).isActive = true
       messageHeight =  self.heightAnchor.constraint(equalToConstant: 0)
        messageHeight?.isActive = true
    }
private  func setupview(kind : MessageType , message : String = "") {
    icon.image = UIImage.init(systemName: "multiply.circle")
    switch kind {
                 case .error: do {
                         subview.backgroundColor = .systemRed
                        erromessage.text = message
                      }
             case .waring : do {
                   subview.backgroundColor = .systemYellow
                    erromessage.text = message
                    }
case .succes : do {
    subview.backgroundColor = .systemGreen
                       erromessage.text = message
    icon.image = UIImage.init(systemName: "paperplane.fill")
    }
              }
  }
  
    func show(message : String , type: MessageType) {
        setupview(kind: type, message: message)
        let size = CGSize(width: self.frame.width - 40, height: 1000)
        let rect = NSString(string: message).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font :UIFont.systemFont(ofSize: 15, weight: .regular)], context: nil)
        addMessageView()
        messageHeight?.isActive = false
        messageHeight?.constant = rect.height + 50
         messageHeight?.isActive = true
        if !messageIsDisplayed
        {
            messageIsDisplayed = true
               UIView.animate(withDuration: 0.3, animations: {
                self.frame = self.frame.offsetBy(dx: 0, dy: 180)
            }) { (bool) in
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                      UIView.animate(withDuration: 0.3, animations: {
                        self.frame = self.frame.offsetBy(dx: 0, dy: -120)
                        }) { (bool) in
                            self.removeFromSuperview()
                            self.messageIsDisplayed = false
                }
        })
        
    }
    
    }
}
