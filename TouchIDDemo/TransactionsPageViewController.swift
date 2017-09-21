//
//  TransactionsPageViewController.swift
//  TouchIDDemo
//
//  Created by Iva on 16/09/2017.
//  Copyright © 2017 Iva. All rights reserved.
//

import UIKit
import MapKit

class TransactionsPageViewController: UIPageViewController, UIPageViewControllerDataSource {

//    var arrCoordinates = Array<CLLocationCoordinate2D>()
    var page: Int!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.setViewControllers([getViewControllerAtIndex(index: 0)] as [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let pageContent: AlertViewController = viewController as! AlertViewController
        var index = pageContent.pageIndex
        if ((index == 0) || (index == NSNotFound))
        {
            return nil
        }
        index -= 1;
        return getViewControllerAtIndex(index: index)
    }

    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let pageContent: AlertViewController = viewController as! AlertViewController
        var index = pageContent.pageIndex
        if (index == NSNotFound)
        {
            return nil;
        }
        index += 1;
        if (index == PendingTransactions.items())
        {
            return nil;
        }
        return getViewControllerAtIndex(index: index)
    }

    func getViewControllerAtIndex(index: NSInteger) -> AlertViewController
    {
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        let transaction = PendingTransactions.getTransaction(atIndex: index)
        pageContentViewController.coordinates = transaction.location
        pageContentViewController.company = transaction.company
        pageContentViewController.date = transaction.date
        pageContentViewController.value = String(describing: transaction.value) + transaction.currency!.rawValue
        pageContentViewController.pageIndex = index
        
        return pageContentViewController
    }

//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return
//    }


    @IBAction func openPageView(segue: UIStoryboardSegue) {

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
