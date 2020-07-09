//
//  ConvertorController.swift
//  Converter
//
//  Created by ScrumTJ on 07.07.2020.
//  Copyright © 2020 ScrumTJ. All rights reserved.
//

import UIKit
import iOSDropDown

class ConvertorController: UIViewController {

    var fromIndex: Int = 0
    var toIndex: Int = 0
    @IBOutlet weak var from: DropDown!
    @IBOutlet weak var to: DropDown!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var summa: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        //add data to drop down array for list
        for x in 0..<allCurrencies.count{
            from.optionArray.append(allCurrencies[x][0])
            from.optionIds?.append(x)
            to.optionArray.append(allCurrencies[x][0])
            to.optionIds?.append(x)
            print(allCurrencies[x][0])
        }
        
        from.optionArray.append("TJS")
        from.optionIds?.append(allCurrencies.count)
        to.optionArray.append("TJS")
        to.optionIds?.append(allCurrencies.count)
        
        from.text = "USD"
        to.text = "TJS"
        from.selectedIndex = 0
        to.selectedIndex = allCurrencies.count
        fromIndex = from.selectedIndex!
        toIndex = to.selectedIndex!
        
        from.didSelect{(selectedText , index ,id) in
            self.fromIndex = index
        }
        
        to.didSelect{(selectedText , index ,id) in
            self.toIndex = index
        }
        
    }
    
    @IBAction func change(_ sender: Any) {
        var res = 0.0
        let sum = Double((summa.text! as NSString).doubleValue)
        
        print(sum)
        if (toIndex == allCurrencies.count) {
            // example: from usd to tjs
            let val = Double((allCurrencies[fromIndex][3] as NSString).doubleValue)
            let nominal = Double((allCurrencies[fromIndex][1] as NSString).doubleValue)
            res = Double((sum * val) / nominal)
        }
        else if (fromIndex == allCurrencies.count) {
            // example: from tjs to usd
            let val = Double((allCurrencies[toIndex][3] as NSString).doubleValue)
            let nominal = Double((allCurrencies[toIndex][1] as NSString).doubleValue)
            res = Double((sum * nominal) / val)
        }
        else {
            // example: from usd to eur or from eur to usd
            let val1 = Double((allCurrencies[fromIndex][3] as NSString).doubleValue)
            let nominal1 = Double((allCurrencies[fromIndex][1] as NSString).doubleValue)
            let val2 = Double((allCurrencies[toIndex][3] as NSString).doubleValue)
            let nominal2 = Double((allCurrencies[toIndex][1] as NSString).doubleValue)
            let ak = (sum * nominal1) / val1
            let bk = (sum * nominal2) / val2
            
            print(ak)
            print(bk)
            
            res = Double((sum * bk * sum) / (sum * ak))
        }
        result.text = String(Double(round(10000*res)/10000))
    }
    
    @IBAction func goBack(_ sender: Any) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "main") as! ViewController
        next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)
    }
    

}
