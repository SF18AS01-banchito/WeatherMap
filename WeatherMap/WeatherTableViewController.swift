//
//  WeatherTableViewController.swift
//  WeatherMap
//
//  Created by Esteban Ordonez on 3/13/19.
//  Copyright © 2019 Esteban Ordonez. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController {
    
    var days: [Day] = [Day](); //this is the model, initially empty
     let formatter: DateFormatter = DateFormatter();
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.formatter.dateStyle = .full;
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let string: String = "https://api.openweathermap.org/data/2.5/forecast/daily";
        
        guard let baseURL: URL = URL(string: string) else {
            fatalError("could not create URL from string \"\(string)\"");
        }
        print("baseURL = \(baseURL)");
        
        let query: [String: String] = [
            "q":     "10003,US", //New York City
            "cnt":   "7",        //number of days
            "units": "imperial", //fahrenheit, not celsius
            "mode":  "json",     //vs. xml or html
            "APPID": "532d313d6a9ec4ea93eb89696983e369"
        ];
        
        guard let url: URL = baseURL.withQueries(query) else {
            fatalError("could not add queries to base URL");
        }
        print("    url = \(url)");
        
        let task: URLSessionDataTask = URLSession.shared.dataTask(with: url) {(data: Data?, response: URLResponse?, error: Error?) in
            
            if let error: Error = error {
                print("error = \(error)");
            }
            
            if let data: Data = data {
                let dictionary: [String: Any];
                do {
                    try dictionary = JSONSerialization.jsonObject(with: data) as! [String: Any];
                } catch {
                    fatalError("could not create dictionary: \(error)");
                }
                
               
               
                
                let week: [[String: Any]] = dictionary["list"] as! [[String: Any]]; //an array of dictionaries
                
                for day in week {   //day is a [String: Any]
                    let dt: Int = day["dt"] as! Int;
                    let date: Date = Date(timeIntervalSince1970: TimeInterval(dt));
                    let dateString: String = self.formatter.string(from: date);
                    let temp: [String: NSNumber] = day["temp"] as! [String: NSNumber];
                    let max: NSNumber = temp["max"]!;
                    let weathers: [[String: Any]] = day["weather"] as! [[String: Any]];
                    let weather: [String: Any] = weathers[0];
                    let icon: String = weather["icon"]! as!String;
                     print("\(dateString) \(max.floatValue)° F \(icon)");
                    self.days.append(Day(date: date , temperature: max.floatValue, icon: icon))
                }
            }
            
                DispatchQueue.main.async{
                 self.tableView.reloadData()
                }
        }
        
        task.resume();
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return days.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)

        // Configure the cell...
        let day: Day = days[indexPath.row];
        cell.textLabel!.text = formatter.string(from: day.date)
        cell.detailTextLabel!.text = "\(day.temperature)℉"
        cell.imageView!.image = UIImage(named: day.icon)!;
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
