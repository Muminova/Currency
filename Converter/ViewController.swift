//
//  ViewController.swift
//  Converter
//
//  Created by ScrumTJ on 06.07.2020.
//  Copyright © 2020 ScrumTJ. All rights reserved.
//

import UIKit
import iOSDropDown

struct Currency {
    var char_code: String
    var nominal: String
    var name: String
    var value: String
}

   var allCurrencies = [[String]]()
    
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {

    var currencies: [Currency] = []
    var elementName: String = String()
    var char_code = String()
    var nominal = String()
    var name = String()
    var value = String()
    
    var currentParsingElement:String = ""
    
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.table.dataSource = self
        self.table.delegate = self
        self.table.rowHeight = UITableView.automaticDimension
        self.table.estimatedRowHeight = 185
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.date.text = String(dateFormatter.string(from: Date()))
        self.date!.setInputViewDatePicker(target: self, selector: #selector(self.tapDone))
        
        getFromServer()
    }


    @IBAction func openConverter(_ sender: Any) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "convert") as! ConvertorController
        next.modalPresentationStyle = .fullScreen
        self.present(next, animated: true, completion: nil)

    }
    
    // Choose date on tap click
    @objc func tapDone() {
        if let datePicker = self.date!.inputView as? UIDatePicker { // 2-1
            let dateformatter2 = DateFormatter()
            dateformatter2.dateFormat = "yyyy-MM-dd"
            self.date!.text = dateformatter2.string(from: datePicker.date) //2-4
        }
        self.date!.resignFirstResponder() // 2-5
        getFromServer()
    }
    
    
    func getFromServer(){
        // get data from server
        allCurrencies.removeAll()
        let url = NSURL(string: "https://nbt.tj/ru/kurs/export_xml.php?date=" + self.date.text! + "&export=xmlout")
                
               //Creating data task
               let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
                    
                   if data == nil {
                       print("dataTaskWithRequest error: \(String(describing: error?.localizedDescription))")
                       return
                   }
                    
                   let parser = XMLParser(data: data!)
                   parser.delegate = self
                   parser.parse()
                   
                   
                       DispatchQueue.main.async {
                           self.table.reloadData()
                           self.table.beginUpdates()
                           self.table.endUpdates()                  }
                     }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "TableCurrencyCell", for: indexPath) as! TableCurrencyCell
        let currency = currencies[indexPath.row]

        cell.unit?.text = currency.nominal
        cell.currency?.text = currency.char_code
        cell.rate?.text = currency.value
        
        return cell
    }
        
   func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "Valute" {
            char_code = String()
            nominal = String()
            name = String()
            value = String()
        }

        self.elementName = elementName
    }

    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Valute" {
            let currency = Currency(char_code: char_code, nominal: nominal, name: name, value: value )
            currencies.append(currency)
            
            allCurrencies.append([currency.char_code, currency.nominal, currency.name, currency.value])
        }
    }

    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == "CharCode" {
                char_code += data
            } else if self.elementName == "Nominal" {
                nominal += data
            } else if self.elementName == "Name" {
                name += data
            } else if self.elementName == "Value" {
                value += data
            }
            
            
        }
    }
}

extension UITextField {
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .date //2
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel)) // 6
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
}
