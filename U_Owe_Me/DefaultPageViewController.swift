//
//  DefaultPageViewController.swift
//  U_Owe_Me
//
//  Created by Anthony on 2019-12-21.
//  Copyright © 2019 Anthony. All rights reserved.
//

import UIKit
// (Apple Doc)- UIPageViewController = A container view controller that manages navigation between pages of content, where each page is managed by a child view controller.
//  UIPageViewController is a protocol name. Protocols define that this class must adhere to the provided blueprints	
class DefaultPageViewController: UIPageViewController {
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newColoredViewController(color: "Green"),
                self.newColoredViewController(color: "Blue"),
                self.newColoredViewController(color: "Red")]
    }()
    
    private func newColoredViewController(color: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewController(withIdentifier: "\(color)ViewController")
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dataSource is a reference to a protocol. We satisfy the protocol in the below extension of UIPageViewControllerDataSource
        // Satisfying this protocol allows us to assign this object to dataSource : (protocol) UIPageViewControllerDataSource
        dataSource = self
        // Do any additional setup after loading the view.
    }
    
    // we use viewDidAppear as opposed to viewDidLoad becasue viewDidLoad is called before the view controller is presented. Cannot present another view while itself is not presented. 
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        // uses the array extension for safe access of the orderedViewControllers array
        if let firstViewController : UIViewController = orderedViewControllers[safe:1]{
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
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

// MARK: UIPageViewControllerDataSource
// extension to implement ViewControllerDataSource delegate
// extends this class (DefaultPageViewController)
// I do not think this needs to be in an extension, I think extension may be a good way to organize delegate code

// (Apple Doc) UIPageViewControllerDataSource protocol is adopted by an object that provides view controllers to the page view controller on an as-needed basis, in response to navigation gestures.

extension DefaultPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex - 1
        
        // I dont think we necessarily need guard  here, we can use a normal if
        if nextIndex < 0 {
            return nil
        }

        return orderedViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else{
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < orderedViewControllers.count else{
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
    
}

// safe access to an array
extension Array{
    subscript (safe index: Index) -> Element?{
        return indices.contains(index) ? self[index] : nil
    }
}
