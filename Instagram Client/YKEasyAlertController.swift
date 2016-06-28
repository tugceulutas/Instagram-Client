//
//  YKEasyAlertController.swift
//  
//  Created by yusuf_kildan on 29/02/16.
//
//  https://github.com/yusufkildan/YKEasyAlertController

import UIKit


public class YKEasyAlertController {
    
    
    private func topMostController() -> UIViewController {
        var topController = (UIApplication.sharedApplication().keyWindow!.rootViewController)!
        while let presentedVC = topController.presentedViewController {
            topController = presentedVC
        }
        
        return topController
    }
    
    static var instance = YKEasyAlertController()
    
 
   
    
    public class func alert(title: String) -> UIAlertController {
        return alert(title, message: "")
    }
    
    public class func alert(title: String, message: String) -> UIAlertController {
        return alert(title, message: message, acceptMessage: "OK") { () -> () in
            
        }
    }
  
    public class func alert(title: String, message: String, acceptMessage: String, acceptBlock: () -> ()) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let acceptButton = UIAlertAction(title: acceptMessage, style: .Default, handler: { (action: UIAlertAction) in
            acceptBlock()
        })
        alert.addAction(acceptButton)
        
        instance.topMostController().presentViewController(alert, animated: true, completion: nil)
        return alert
    }
    
    public class func alert(title: String, message: String, cancelBlock: () -> (), acceptBlock: () -> ()) -> UIAlertController {
        return alert(title, message: message, leftButtonMessage: "Cancel", rightButtonMessage: "Accept", leftBlock: { () -> () in
            cancelBlock()
            }) { () -> () in
                acceptBlock()
        }
    }
    
    public class func alert(title: String, message: String, leftButtonMessage: String, rightButtonMessage: String, leftBlock: () -> (), rightBlock: () -> ()) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let declineButton = UIAlertAction(title: leftButtonMessage, style: .Default, handler: { (action: UIAlertAction) in
            leftBlock()
        })
        let acceptButton = UIAlertAction(title: rightButtonMessage, style: .Default, handler: { (action: UIAlertAction) in
            rightBlock()
        })
        alert.addAction(declineButton)
        alert.addAction(acceptButton)
        
        instance.topMostController().presentViewController(alert, animated: true, completion: nil)
        return alert
    }
    
    
    
}