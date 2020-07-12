//
//  BaseViewController.swift
//  Venues Demo
//
//  Created by Mohammad Shaker on 7/12/20.
//  Copyright © 2020 Mohammad Shaker. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

let loadingIndicatorViewTag = -9999
let dimmingViewTag = -9191


class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}


// MARK: - NVActivityIndicatorView
extension BaseViewController {
    func showError(withMessage message: String) {
        let alert: UIAlertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showLoadingIndicator() {
        guard view.viewWithTag(loadingIndicatorViewTag) == nil else {
            return
        }
        let indicatorViewWidth: CGFloat = 50
        let indicatorViewHeight: CGFloat = 50
        
        let indicatorView: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: indicatorViewWidth, height: indicatorViewHeight), type: .circleStrokeSpin, color: UIColor.defaultAppThemeColor, padding: nil)
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: indicatorViewWidth * 2, height: indicatorViewHeight * 2))
        containerView.tag = loadingIndicatorViewTag
        containerView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        containerView.center = CGPoint(x: view.bounds.width / 2, y: (view.bounds.height - indicatorViewHeight) / 2)
        containerView.layer.cornerRadius = 15.0
        
        indicatorView.center = CGPoint(x: containerView.bounds.width / 2, y: containerView.bounds.height / 2)
        containerView.addSubview(indicatorView)
        
        view.addSubview(containerView)
        view.bringSubviewToFront(containerView)
        view.isUserInteractionEnabled = false
        indicatorView.startAnimating()
    }
    
    func hideLoadingIndicator() {
        if let indicatorView = view.viewWithTag(loadingIndicatorViewTag) {
            indicatorView.removeFromSuperview()
            view.isUserInteractionEnabled = true
        }
    }
}
