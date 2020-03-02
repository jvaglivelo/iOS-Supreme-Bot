//
//  Supreme.swift
//  iOS-Supreme-Bot
//
//  Created by Jordan Vaglivelo on 2/28/20.
//  Copyright © 2020 Jordan Vaglivelo. All rights reserved.
//

import Foundation
import SwiftyJson

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}

class Supreme
{
    
    //Edit here
    
    //Item Info
    var items:[String] = ["bird"]
    var categories:[String] = ["accessories"]
    var sizes:[String] = ["n/a"]
    var colors:[String] = ["red"]

    //User Info
    var uName = "Test Profile"
    var uEmail = "test@gmail.com"
    var uPhone = "1231111111"
    var uAddress = "123 Fake St"
    var uAddress2 = ""
    var uCity = "New York City"
    var uState = "NY"
    var uZip = "10001"
    var uCCNum = "1111222233334444"
    var uCCMonth = "22"
    var uCCYear = "2022"
    var uCCCVV = "123"

    var location = "US" //Use "US" or "EU"
    
    //DO NOT EDIT BELOW THIS LINE
    
    //Class Variables
    weak var supremeInstance: Supreme?
    var stepFunction: Int = 0
    var timer: DispatchSourceTimer?
    var timerItemStyle: DispatchSourceTimer?
    
    //Time the bot
    var timeToRun = Timer()
    var seconds = 0

    //Delay Variables
    var delayCheckoutClick = 250
    var finalDelay = 0
    
    //Item Variables
    var W2CColor = ""
    var W2CSize = ""
    var W2CName = ""
    var W2CCategory = ""
    var quantity = ""
    var loaded = false
    var currentCategory = ""
    var numItems = 0
    var currentItem = 0
    
    //IDs
    var idName = ""
    var idEmail = ""
    var idPhone = ""
    var idAddress1 = ""
    var idAddress2 = ""
    var idAddress3 = ""
    var idZip = ""
    var idCity = ""
    var idState = ""
    var idCountry = ""
    var idCCType = ""
    var idCC = ""
    var idCCM = ""
    var idCCY = ""
    var idCVV = ""
    
    var addressPt2 = false

    //Link view controller
    var viewController: ViewController?

    
    //Link viewController again
    init(withViewController viewController: ViewController)
    {
        self.viewController = viewController
    }
    
    //INIT SUPREMEINSTANCE
    init(withSupremeInstance supremeInstance: Supreme)
    {
        self.supremeInstance = supremeInstance
    }

    
    func startTimer(){
        timeToRun = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateTimer(){
        seconds += 1
    }
    
    //start Bot
    func startProcess()
    {
        //start timing
        startTimer()
        seconds = 0
        
        //reset variables
        numItems = 0
        currentItem = 0
        
        //get first item info from arrays
        W2CName = items[0].lowercased()
        W2CColor = colors[0].lowercased()
        W2CSize = sizes[0]
        W2CCategory = categories[0]
        
        //see how many items there are
        numItems = (items.count - 1)
        
        //tell viewController bot is starting
        self.viewController!.botRunning = true
        
        //setup javascript event
        DispatchQueue.main.async {
            self.viewController?.supremeBrowser?.evaluateJavaScript("""
                let event = document.createEvent('Event');
                event.initEvent('change', true, true);
                """, completionHandler: nil)
            
        }
        
        
        print("checking out: ",W2CName, "\t in: ", W2CCategory)
        self.loadCategory()

    }
    
    //End bot
    func stopProcess()
    {
        //return time
        print("stop")
        print("Checked out in", seconds, "seconds")
        seconds = 0
        
        //reset timer
        self.timerItemStyle?.cancel()
        self.timerItemStyle = nil
        
        //tell viewController bot is done
        self.viewController!.botRunning = false
        
    }
        
    //load the selected category
    func loadCategory()
    {
        //for the first item, the url can be changed. Will cause problems (on Supreme's end) if this happens more than once.
        if currentItem == 0{
            
            //change to uppercase
            if W2CCategory == "new"{
                currentCategory = "New"
            }else if W2CCategory == "jackets"{
                currentCategory = "Jackets"
            }else if W2CCategory == "shirts"{
                currentCategory = "Shirts"
            }else if W2CCategory == "tops/sweaters"{
                currentCategory = "Tops/Sweaters"
            }else if W2CCategory == "sweatshirts"{
                currentCategory = "Sweatshirts"
            }else if W2CCategory == "pants"{
                currentCategory = "Pants"
            }else if W2CCategory == "shorts"{
                currentCategory = "Shorts"
            }else if W2CCategory == "t-shirts"{
                currentCategory = "T-Shirts"
            }else if W2CCategory == "hats"{
                currentCategory = "Hats"
            }else if W2CCategory == "bags"{
                currentCategory = "Bags"
            }else if W2CCategory == "accessories"{
                currentCategory = "Accessories"
            }else if W2CCategory == "skate"{
                currentCategory = "Skate"
            }else if W2CCategory == "Shoes"{
                currentCategory = "shoes"
            }

            
            DispatchQueue.main.async{
                //Make sure the category is on the page
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(self.W2CCategory)-category').innerHTML",
                                                                        completionHandler:
                    { (catText: Any?, error: Error?) in
                        //If this returns nil, category hasnt loaded
                        if catText == nil{
                            //refresh
                            self.viewController?.supremeBrowser?.evaluateJavaScript("location.reload(true)", completionHandler: nil)
                            //Wait 850-1000ms and try again
                            let browswerBackgroundWaitCategory = DispatchQueue(label: "browswerBackgroundWaitCategory", qos: .userInitiated)
                            let ranRefresh = Int.random(in: 850 ... 1000)
                            browswerBackgroundWaitCategory.asyncAfter(deadline: .now() + .milliseconds(ranRefresh)){
                                //another attempt
                                self.loadCategory()
                            }
                        }else{
                            //if loaded, navigate to the categorie's url
                            let categoryLink = "https://www.supremenewyork.com/mobile/#categories/" + self.currentCategory
                            print(categoryLink)
                            DispatchQueue.main.async{
                                self.viewController?.supremeBrowser?.evaluateJavaScript("window.location.href = '\(categoryLink)';", completionHandler: nil)
                                
                            }
                            //Start looking for items
                            self.loadItems()
                        }
                })
            }
        }else{
            //If this is not the first item, click the button for this category instead
            let selector = W2CCategory + "-category"

            let browserDelayQLoad = DispatchQueue(label: "browserDelayQLoad", qos: .userInitiated)
            browserDelayQLoad.asyncAfter(deadline: .now() + .milliseconds(125))
            {
                DispatchQueue.main.async{
                    self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(selector)').click()", completionHandler: nil)
                }
            }
            //Now start looking for items
            self.loadItems()
        }
    }
    
    func startNext(){
        //Called whenever an item is done to check if there is another
        print("go home")
        DispatchQueue.main.async {
            //This can be buggy sometimes, but this was the best method I found
            self.viewController?.supremeBrowser?.evaluateJavaScript("window.history.go(-3);", completionHandler: nil)
        }

        //Get info for the next item
        if currentItem <  numItems{
            self.currentItem += 1
            W2CName = items[currentItem].lowercased()
            W2CColor = colors[currentItem].lowercased()
            W2CSize = sizes[currentItem]
            W2CCategory = categories[currentItem]
            //Make sure bot ready for next item
            self.canNext()
        }else{
            //If there is only one item, checkout
            self.checkoutButton()
        }
    }

    func canNext(){
        //Make sure ready to begin for any item after the first
        DispatchQueue.main.async{
            //Check the length of the url
            //The homepage has a length of 49 characters
            self.viewController?.supremeBrowser?.evaluateJavaScript("window.location.href.length",
                                                                    completionHandler:
                { (classV: Any?, error: Error?) in
                    //If nil is returned, keep trying because navigation still in progress
                    if classV == nil{
                        self.canNext()
                    }else{
                        //If the length is < 50, then the bot is back on the homepage and the next item can begin
                        let hrefLen = classV as! Int
                        if hrefLen <= 50{
                            let ranDelayCategory = Int.random(in: 95 ... 126) //just being safe
                            let browserDelayQ1 = DispatchQueue(label: "browswerBackgroundQ1", qos: .userInitiated)
                            browserDelayQ1.asyncAfter(deadline: .now() + .milliseconds(ranDelayCategory))
                            {
                                //Load the category for the next item
                                self.loadCategory()
                            }
                        }else{
                            //If not on homepage, wait
                            self.canNext()
                        }
                    }
            })
        }
    }

    //make sure the category page has loaded
    func loadItems(){
        DispatchQueue.main.async {
            //Get the amount of items on the page
            self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementsByClassName('name').length",
                                                                completionHandler:
                { (length: Any?, error: Error?) in
                    if length == nil{
                        //hasnt loaded yet, try again
                        self.loadItems()
                    }else{
                        let itemLength = length as! Int
                        if itemLength > 0{
                            //category page loaded
                            self.findItem()
                        }else{
                            //hasnt loaded yet, try again
                            self.loadItems()
                        }
                    }
            })
        }
    }
        
    //scan every item name in HTML and look for matching keywords
    func findItem()
    {

        print("searching")
        
        let browserDelayQFind = DispatchQueue(label: "browserDelayQFind", qos: .userInitiated)
        browserDelayQFind.asyncAfter(deadline: .now() + .milliseconds(100))
        {
            DispatchQueue.main.async{
                self.viewController?.supremeBrowser?.evaluateJavaScript("""
                    var keyword = 'bird'
                    var items = document.getElementsByClassName("name");
                    for (item of items) {
                        var name = item.innerHTML.toLowerCase()
                        if (name.includes(keyword)){
                            var ans = "found: " + name
                            item.click()
                        }
                        ans
                    }
                    """, completionHandler: { (found: Any?, error: Error?) in
                    
                    //if nothing was found
                    if found == nil{
                        DispatchQueue.main.async{
                            //make sure bot is still running
                            if self.viewController?.botRunning == true{
                                //if there are more items, skip this one and go to next
                                if self.currentItem != self.numItems{
                                    self.startNext()
                                }else{
                                    //If this was the only item, refresh the page and start over
                                    self.viewController?.supremeBrowser?.evaluateJavaScript("location.reload(true)", completionHandler: nil)
                                    let ranRefresh = Int.random(in: 850 ... 1000)
                                    let browserDelayQ2 = DispatchQueue(label: "browswerBackgroundQ2", qos: .userInitiated)
                                    browserDelayQ2.asyncAfter(deadline: .now() + .milliseconds(ranRefresh))
                                    {
                                        self.findItem()
                                    }
                                }
                            }
                        }
                    //if text was returned
                    }else{
                        let foundStr = found as! String
                        
                        //if the word "found" was returned (will be if item was found)
                        if foundStr.contains("found"){
                            let browserDelayQFound = DispatchQueue(label: "browserDelayQFound", qos: .userInitiated)
                            browserDelayQFound.asyncAfter(deadline: .now() + .milliseconds(100))
                            {
                                print(foundStr)
                                
                                self.cartButton()
                            }
                        }else{
                            //if something else was returned (shouldnt happen)
                            //does same as above (if only item, refresh and keep trying. if more items, skip this one)
                            DispatchQueue.main.async{
                                if self.viewController?.botRunning == true{
                                    if self.currentItem != self.numItems{
                                        self.startNext()
                                    }else{
                                        //wait for new drop to load
                                        print("waiting for category to load")
                                        self.viewController?.supremeBrowser?.evaluateJavaScript("location.reload(true)", completionHandler: nil)
                                        let browserDelayQ2 = DispatchQueue(label: "browswerBackgroundQ2", qos: .userInitiated)
                                        let ranRefresh = Int.random(in: 850 ... 1000)
                                        browserDelayQ2.asyncAfter(deadline: .now() + .milliseconds(ranRefresh))
                                        {
                                            self.findItem()
                                        }
                                    }
                                }
                            }

                        }
                    }
                
                })
            }
        }
        }
    
    //make sure "add to cart" button has loaded
    func cartButton(){
        DispatchQueue.main.async{
            //get add to cart button text
            self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementsByClassName('cart-button')[0].innerText",
                                                                    completionHandler:
                { (length: Any?, error: Error?) in
                    if length == nil{
                        //button has not loaded
                        self.cartButton()
                    }else{
                        //add to cart button loaded, we can continue
                        print("loaded")
                        //pass current URL to next funciton
                        let url = self.viewController?.supremeBrowser?.url
                        self.getItemInfo(currentURL: url!)
                    }
            })
        }
    }

    //get json file of current item
    func getItemInfo(currentURL: URL){
        
        //get item number from the url
        let itemURL = currentURL.absoluteString
        let tmpNum = itemURL.components(separatedBy: "/")
        let finalStr = tmpNum.count
        let itemNum = tmpNum[(finalStr - 1)]

        //get the json url
        let jsonFile = "https://www.supremenewyork.com/shop/" + itemNum + ".json"
        var jsonData = ""
        var jsonFData: Data
        
        //attempt to get json data
        if let url = URL(string: jsonFile) {
            do {
                jsonData = try String(contentsOf: url)
                jsonFData = jsonData.data(using: .utf8)!
                self.intJson(jsonFData: jsonFData)
            } catch {
                print("oh no...")
                self.getItemInfo(currentURL: currentURL)
            }
        }
    }
    
    //find size and color values from json
    func intJson(jsonFData: Data){
        
        print("setting size and color")
        
        var arraySizeName = [String]()
        var arraySizeStock = [String]()
        var arraySizeID = [String]()
        var dictStyle = [String: Int]()
        var dictSizes = [String: String]()
        var dictStock = [String: Int]()
        do {
            let json = try JSON(data: jsonFData)
            for item in json["styles"].arrayValue {
                
                dictStyle[(item["name"].stringValue)] = Int((item["id"].stringValue))
                
                for innerItem in item["sizes"].arrayValue {
                    arraySizeName.append(innerItem["name"].stringValue)
                    arraySizeStock.append(innerItem["stock_level"].stringValue)
                    arraySizeID.append(innerItem["id"].stringValue)
                }
            }
            for (name, id) in dictStyle{
                if name.lowercased().contains(W2CColor) || W2CColor == "none"{
                    print("Color entered is:", name, "with ID:", id)
                    let selectedStyle = "style-" + String(id)
                    
                    let browserDelayQColor = DispatchQueue(label: "browserDelayQColor", qos: .userInitiated)
                    browserDelayQColor.asyncAfter(deadline: .now() + .milliseconds(75))
                    {
                        print("chose color")
                        DispatchQueue.main.async {
                            self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById(\"\(selectedStyle)\").getElementsByClassName('style-thumb')[0].click()", completionHandler: nil)
                        }
                    }
                    //get sizes
                    for item in json["styles"].arrayValue {
                        if (item["name"].stringValue) == name{
                            for innerItem in item["sizes"].arrayValue {
                                dictSizes[(innerItem["name"].stringValue)] = (innerItem["id"].stringValue)
                                dictStock[(innerItem["name"].stringValue)] = Int((innerItem["stock_level"].stringValue))
                            }
                            
                        }
                    }
                    for (sName, sID) in dictSizes{
                        if sName.lowercased() == (W2CSize){
                            print("Size entered is:", sName, "with ID:", sID)
                            if dictStock[sName] == 0{
                                print("OOS")
                                self.stopProcess()
                            }else{
                                print("in stock")
                                let browserDelayQ3 = DispatchQueue(label: "browswerBackgroundQ3", qos: .userInitiated)
                                browserDelayQ3.asyncAfter(deadline: .now() + .milliseconds(140))
                                {
                                    DispatchQueue.main.async{
                                        self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementsByTagName('select')[0].value = \"\((sID))\"", completionHandler: nil)
                                        self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementsByTagName('select')[0].dispatchEvent(event)", completionHandler: nil)
                                    }
                                }
                                let browserDelayQ4 = DispatchQueue(label: "browswerBackgroundQ4", qos: .userInitiated)
                                browserDelayQ4.asyncAfter(deadline: .now() + .milliseconds(222))
                                {
                                    self.addToCart()
                                }
                            }
                        }
                    }
                }
            }
            
            

        } catch {
            print(error)
        }
    }
        
        
    //Select item size, and color if exists, then add to cart, click checkout
    func addToCart()
    {
        print("Add to cart!")
        DispatchQueue.main.async{
            self.viewController?.supremeBrowser?.evaluateJavaScript("""
                atcBtn = document.getElementsByClassName("cart-button")[0];
                atcBtn.click();
            """, completionHandler: nil)

            let browserDelayQ5 = DispatchQueue(label: "browswerBackgroundQ5", qos: .userInitiated)
            browserDelayQ5.asyncAfter(deadline: .now() + .milliseconds(self.delayCheckoutClick))
            {
                print("added to cart")
                self.isInCart()
            }
        }
    }
    
    func isInCart(){
        DispatchQueue.main.async{
            self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('cart-update').children[0].innerHTML",
                                                                completionHandler:
                { (style: Any?, error: Error?) in
                
                    if style == nil{
                        self.isInCart()
                    }else{
                        let strStyle = (style as! String)

                        if strStyle == "remove" {
                            //if in cart
                            if self.currentItem != self.numItems{
                                self.startNext()
                            }else{
                                self.checkoutButton()
                            }
                        }else{
                                print("waiting")
                                self.isInCart()
                        }
                    }
            })
        }
    }
    
    
    
    func checkoutButton(){
        DispatchQueue.main.async{
            
            self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('cart-update').children[0].innerHTML",
                                                                    completionHandler:
                { (style: Any?, error: Error?) in
                    
                    if style == nil{
                        self.checkoutButton()
                    }else{
                        let strCartStyle = (style as! String)

                        if strCartStyle == "remove" {
                            let ranDelayCheckout = Int.random(in: 70 ... 100)
                            let browserDelayQ6 = DispatchQueue(label: "browswerBackgroundQ6", qos: .userInitiated)
                            browserDelayQ6.asyncAfter(deadline: .now() + .milliseconds(ranDelayCheckout))
                            {
                                DispatchQueue.main.async{
                                self.viewController?.supremeBrowser?.evaluateJavaScript("window.location.href = 'https://www.supremenewyork.com/mobile/#checkout';", completionHandler: nil)


                                }
                            }
                            if self.viewController?.botRunning == true{
                                self.canPaste()
                            }else{
                                self.stopProcess()
                            }

                        }else{
                            self.checkoutButton()
                        }
                    }
            })
        }
    }

    func canPaste(){
        DispatchQueue.main.async{
            
            self.viewController?.supremeBrowser?.evaluateJavaScript("""
            let checkoutBtn = document.getElementById("submit_button");
            checkoutBtn
            """,
                                                                    completionHandler:
                { (loaded: Any?, error: Error?) in
                    
                    if loaded == nil{
                        self.canPaste()
                    }else{
                        print("checking out")
                        let ranDelayPaste = Int.random(in: 125 ... 175)
                        let browserDelayQ7 = DispatchQueue(label: "browswerBackgroundQ7", qos: .userInitiated)
                        browserDelayQ7.asyncAfter(deadline: .now() + .milliseconds(ranDelayPaste))
                        {
                            self.getCheckoutInfo()
                        }
                    }
            })
        }
        
    }
    
    func getCheckoutInfo(){
        if (self.defaults.bool(forKey: "EU") == true){

            Alamofire.request("https://vopemz.github.io/bkup/f-eu.html").responseString { response in
                let checkoutStr = response.result.value!
                var checkoutList = checkoutStr.split{$0 == ","}.map(String.init)
            
                self.idName = checkoutList[0]
                self.idEmail = checkoutList[1]
                self.idPhone = checkoutList[2]
                self.idAddress1 = checkoutList[3]
                self.idAddress2 = checkoutList[4]
                self.idAddress3 = checkoutList[5]
                self.idCity = checkoutList[6]
                self.idZip = checkoutList[7]
                self.idState = checkoutList[8]
                self.idCCType = checkoutList[9]
                self.idCC = checkoutList[10]
                self.idCCM = checkoutList[11]
                self.idCCY = checkoutList[12]
                self.idCVV = checkoutList[13]
            }
        }else{
            Alamofire.request("https://vopemz.github.io/bkup/f-us.html").responseString { response in
                let checkoutStr = response.result.value!
                var checkoutList = checkoutStr.split{$0 == ","}.map(String.init)
                
                self.idName = checkoutList[0]
                self.idEmail = checkoutList[1]
                self.idPhone = checkoutList[2]
                self.idAddress1 = checkoutList[3]
                self.idAddress2 = checkoutList[4]
                self.idZip = checkoutList[5]
                self.idCity = checkoutList[6]
                self.idState = checkoutList[7]
                self.idCountry = checkoutList[8]
                self.idCC = checkoutList[9]
                self.idCCM = checkoutList[10]
                self.idCCY = checkoutList[11]
                self.idCVV = checkoutList[12]
            }

        }
        if self.idName != ""{
            self.pasteInfo()
        }else{
            self.getCheckoutInfo()
        }
    }
    
    //FUNCTION PASTEINFO - paste profile information into checkout screen
    func pasteInfo()
    {
        print("begin autofill")
        
        if uName.isEmpty{
            DispatchQueue.main.async{
                print("Missing: Name")
            }
            self.stopProcess()
            return
        }
        if uEmail.isEmpty{
            DispatchQueue.main.async{
                print("Missing: Emaik")
            }
            self.stopProcess()
            return
        }
        if uPhone.isEmpty{
            DispatchQueue.main.async{
                print("Missing: Phone")
            }
            self.stopProcess()
            return
        }
        if uAddress.isEmpty{
            DispatchQueue.main.async{
                print("Missing: Address")
            }
            self.stopProcess()
            return
        }
        
        if uAddress2.isEmpty{
            addressPt2 = false
        }else{
            addressPt2 = true
        }
        
        if uCity.isEmpty{
            DispatchQueue.main.async{
                print("Missing: City")
            }
            self.stopProcess()
            return
        }
        if uState.isEmpty{
            DispatchQueue.main.async{
                print("Missing: State")
            }
            self.stopProcess()
            return
        }
        if uZip.isEmpty{
            DispatchQueue.main.async{
                print("Missing: Zip")
            }
            self.stopProcess()
            return
        }
        if uCCNum.isEmpty{
            DispatchQueue.main.async{
                print("Missing: Credit Card number")
            }
            self.stopProcess()
            return
        }
        if uCCMonth.isEmpty{
            DispatchQueue.main.async{
                print("Missing: Credit Card month")
            }
            self.stopProcess()
            return
        }
        if uCCYear.isEmpty{
            DispatchQueue.main.async{
                print("Missing: Credit Card year")
        }
            self.stopProcess()
            return
        }
        if uCCCVV.isEmpty{
            DispatchQueue.main.async{
                print("Missing: Credit Card CVV")
            }
            self.stopProcess()
            return
        }
        
        //NAME
        let browserDelayQ8 = DispatchQueue(label: "browswerBackgroundQ8", qos: .userInitiated)
        browserDelayQ8.asyncAfter(deadline: .now() + .milliseconds(150))
        {
            DispatchQueue.main.async{
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById(\"\(String(self.idName))\").focus()", completionHandler: nil)
                    
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idName))\').value = \"\(String(self.uName))\"", completionHandler: nil)
                    
            }
        }
            
        //EMAIL
        let browserDelayQ9 = DispatchQueue(label: "browswerBackgroundQ9", qos: .userInitiated)
        browserDelayQ9.asyncAfter(deadline: .now() + .milliseconds(200))
        {
            DispatchQueue.main.async{
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById(\"\(String(self.idEmail))\").focus()", completionHandler: nil)
                
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idEmail))\').value = \"\(String(self.uEmail))\"", completionHandler: nil)
            }
        }
        
        //PHONE
        let browserDelayQ10 = DispatchQueue(label: "browserDelayQ10", qos: .userInitiated)
        browserDelayQ10.asyncAfter(deadline: .now() + .milliseconds(250))
        {
            DispatchQueue.main.async{
                
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById(\"\(String(self.idPhone))\").focus()", completionHandler: nil)
                
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idPhone))\').value = \"\(String(self.uPhone))\"", completionHandler: nil)
            }
        }
        
        //ADDRESS
        let browserDelayQ11 = DispatchQueue(label: "browswerBackgroundQ11", qos: .userInitiated)
        browserDelayQ11.asyncAfter(deadline: .now() + .milliseconds(300))
        {
            DispatchQueue.main.async{
                
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById(\"\(String(self.idAddress1))\").focus()", completionHandler: nil)
                
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idAddress1))\').value = \"\(String(self.uAddress))\"", completionHandler: nil)
                
                if self.addressPt2 == true{
                    self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idAddress2))\').focus()", completionHandler: nil)
                    
                    self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idAddress2))\').value = \"\(String(self.uAddress2))\"", completionHandler: nil)
                    
                }else{
                    self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idAddress2))\').focus()", completionHandler: nil)
                    
                    self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idAddress2))\').value = '' ", completionHandler: nil)
                    
                }
            }
        }
        
        //ZIP
        let browserDelayQ12 = DispatchQueue(label: "browswerBackgroundQ12", qos: .userInitiated)
        browserDelayQ12.asyncAfter(deadline: .now() + .milliseconds(350))
        {
            DispatchQueue.main.async{
                
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById(\"\(String(self.idZip))\").focus()", completionHandler: nil)
                
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idZip))\').value = \"\(String(self.uZip))\"", completionHandler: nil)
            }
        }
        
        //CITY
        let browserDelayQ13 = DispatchQueue(label: "browswerBackgroundQ13", qos: .userInitiated)
        browserDelayQ13.asyncAfter(deadline: .now() + .milliseconds(400))
        {
            DispatchQueue.main.async{
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById(\"\(String(self.idCity))\").focus()", completionHandler: nil)
                
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCity))\').value = \"\(String(self.uCity))\"", completionHandler: nil)
                
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById(\"remember_address\").checked = false", completionHandler: nil)
                
            }
        }
        
        //COUNTRY / STATE
        let browserDelayQ14 = DispatchQueue(label: "browswerBackgroundQ14", qos: .userInitiated)
        browserDelayQ14.asyncAfter(deadline: .now() + .milliseconds(450))
        {
            DispatchQueue.main.async{
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById(\"\(String(self.idState))\").focus()", completionHandler: nil)
                
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idState))\').value = \"\(String(self.uState))\"", completionHandler: nil)
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idState))\').dispatchEvent(event)", completionHandler: nil)
                
            }
        }
        
        //CCTYpe
        let browserDelayQ15 = DispatchQueue(label: "browswerBackgroundQ15", qos: .userInitiated)
        browserDelayQ15.asyncAfter(deadline: .now() + .milliseconds(480))
        {
            DispatchQueue.main.async{
                if (self.defaults.bool(forKey: "EU") == true){
                    if (self.defaults.string(forKey: "EUCard") == "Visa"){
                        self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCCType))\').focus()", completionHandler: nil)
                        
                        self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCCType))\').value = 'visa'", completionHandler: nil)
                        self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCCType))\').dispatchEvent(event)", completionHandler: nil)
                        
                    }else if (self.defaults.string(forKey: "EUCard") == "American Express"){
                        self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCCType))\').focus()", completionHandler: nil)
                        
                        self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCCType))\').value = 'american_express'", completionHandler: nil)
                        self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCCType))\').dispatchEvent(event)", completionHandler: nil)
                        
                        
                    }else if (self.defaults.string(forKey: "EUCard") == "Mastercard"){
                        self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCCType))\').focus()", completionHandler: nil)
                        
                        self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCCType))\').value = 'master'", completionHandler: nil)
                        self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCCType))\').dispatchEvent(event)", completionHandler: nil)
                        
                        
                    }else if (self.defaults.string(forKey: "EUCard") == "Solo"){
                        self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCCType))\').focus()", completionHandler: nil)
                        
                        self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCCType))\').value = 'solo'", completionHandler: nil)
                        self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCCType))\').dispatchEvent(event)", completionHandler: nil)
                        
                        
                    }else{
                        self.stopProcess()
                    }
                }
            }
        }
        //CREDIT CARD NUMBER
        let browserDelayQ16 = DispatchQueue(label: "browswerBackgroundQ16", qos: .userInitiated)
        browserDelayQ16.asyncAfter(deadline: .now() + .milliseconds(510)){
            DispatchQueue.main.async{
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById(\"\(String(self.idCC))\").focus()", completionHandler: nil)
                
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCC))\').value = \"\(String(self.uCCNum))\"", completionHandler: nil)
                
            }
        }
        let browserDelayQ17 = DispatchQueue(label: "browswerBackgroundQ17", qos: .userInitiated)
        browserDelayQ17.asyncAfter(deadline: .now() + .milliseconds(560)){
            DispatchQueue.main.async{
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById(\"\(String(self.idCCM))\").focus()", completionHandler: nil)
                
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCCM))\').value = \"\(String(self.uCCMonth))\"", completionHandler: nil)
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCCM))\').dispatchEvent(event)", completionHandler: nil)
                
            }
        }
        let browserDelayQ18 = DispatchQueue(label: "browswerBackgroundQ18", qos: .userInitiated)
        browserDelayQ18.asyncAfter(deadline: .now() + .milliseconds(610)){
            DispatchQueue.main.async{
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCCY))\').focus()", completionHandler: nil)
                
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCCY))\').value = \"\(String(self.uCCYear))\"", completionHandler: nil)
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCCY))\').dispatchEvent(event)", completionHandler: nil)
                
            }
        }
        
        let browserDelayQ19 = DispatchQueue(label: "browswerBackgroundQ19", qos: .userInitiated)
        browserDelayQ19.asyncAfter(deadline: .now() + .milliseconds(660))
        {
            DispatchQueue.main.async{
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCVV))\').focus()", completionHandler: nil)
                
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCVV))\').value = \"\(String(self.uCCCVV))\"", completionHandler: nil)
                
            }
        }
        let browserDelayQ20 = DispatchQueue(label: "browswerBackgroundQ20", qos: .userInitiated)
        browserDelayQ20.asyncAfter(deadline: .now() + .milliseconds(710))
        {
            DispatchQueue.main.async{
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('\(String(self.idCVV))\').blur()", completionHandler: nil)
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById(\"order_terms\").checked = true", completionHandler: nil)
                
                
            }
        }

        //Check if ATC is enabled, if it is add delay for pasting CVV to avoid bot detection then checkout
        if ((defaults.bool(forKey: "AutoATC")) == true){
            
            finalDelay = 760 + defaults.integer(forKey: "CheckoutDelay")
            
            print("checking out with delay of ", String(finalDelay))
            
            print("Final delay is : " + String(finalDelay))
            let browserDelayQ21 = DispatchQueue(label: "browswerBackgroundQ21", qos: .userInitiated)
            browserDelayQ21.asyncAfter(deadline: .now() + .milliseconds(finalDelay))
            {
                DispatchQueue.main.async{
                self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById(\"hidden_cursor_capture\").click()", completionHandler: nil)

                }
            }

        }
        var finishtime = 0
        if ((defaults.bool(forKey: "AutoATC")) == true){
            finishtime = finalDelay
        }else{
            finishtime = 725
        }
        
        let browserDelayQ22 = DispatchQueue(label: "browswerBackgroundQ22", qos: .userInitiated)
        browserDelayQ22.asyncAfter(deadline: .now() + .milliseconds(finishtime))
        {
            self.stopProcess()
        }
    }
    
    
    func restockCart(){
        print("waiting for cart")
        DispatchQueue.main.async{
            self.viewController?.supremeBrowser?.evaluateJavaScript("document.getElementById('cart-update').children[0].innerHTML",
                                                                    completionHandler:
                { (style: Any?, error: Error?) in
                    
                    if style == nil{
                        self.restockCart()
                    }else{
                        let strCartStyle = (style as! String)
                        
                        if strCartStyle == "remove" {
                            self.defaults.set(false, forKey: "AutoATC")
                            
                            self.viewController?.supremeBrowser?.evaluateJavaScript("window.location.href = 'https://www.supremenewyork.com/mobile/#checkout';", completionHandler: nil)
                            
                            let browserDelayQRestockCartLoad = DispatchQueue(label: "browserDelayQRestockCartLoad", qos: .userInitiated)
                            browserDelayQRestockCartLoad.asyncAfter(deadline: .now() + .milliseconds(500))
                            {
                                self.getCheckoutInfo()
                            }
                        }else{
                            let browserDelayQRestock = DispatchQueue(label: "browserDelayQRestock", qos: .userInitiated)
                            browserDelayQRestock.asyncAfter(deadline: .now() + .milliseconds(500))
                            {
                                self.restockCart()
                            }
                        }
                    }
            })
        }

    }
    
    deinit
    {
        self.stopProcess()
    }
}

