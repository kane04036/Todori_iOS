//
//  Color.swift
//  TODORI
//
//  Created by Dasol on 2023/05/29.
//

import UIKit

class ColorManager {
    static let shared = ColorManager()
    
    let mainColor = UIColor(red: 1, green: 0.704, blue: 0.704, alpha: 1)
    let colorSet = ["red-circle", "yellow-circle", "green-circle", "blue-circle", "pink-circle", "purple-circle"]
        
    private init() {}
}

class Color {
    
    static let shared = Color()
    
    var UIColorArray:[UIColor] = [UIColor(red: 1, green: 0.704, blue: 0.704, alpha: 1),UIColor(red: 1, green: 0.863, blue: 0.658, alpha: 1),UIColor(red: 0.696, green: 0.879, blue: 0.813, alpha: 1),UIColor(red: 0.718, green: 0.845, blue: 0.962, alpha: 1),UIColor(red: 1, green: 0.721, blue: 0.922, alpha: 1),UIColor(red: 0.712, green: 0.694, blue: 0.925, alpha: 1)]
    
    func getColor(colorNum:Int) -> UIColor{
        var color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        switch(colorNum){
        case 1: color = UIColor(red: 1, green: 0.704, blue: 0.704, alpha: 1)
        case 2: color = UIColor(red: 1, green: 0.863, blue: 0.658, alpha: 1)
        case 3: color = UIColor(red: 0.696, green: 0.879, blue: 0.813, alpha: 1)
        case 4: color = UIColor(red: 0.718, green: 0.845, blue: 0.962, alpha: 1)
        case 5: color = UIColor(red: 1, green: 0.721, blue: 0.922, alpha: 1)
        case 6: color = UIColor(red: 0.712, green: 0.694, blue: 0.925, alpha: 1)
        default: break
        }
        return color
    }
    
    func getColor(colorNumString:Character) -> UIColor{
        var color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        switch(colorNumString){
        case "1": color = UIColor(red: 1, green: 0.704, blue: 0.704, alpha: 1)
        case "2": color = UIColor(red: 1, green: 0.863, blue: 0.658, alpha: 1)
        case "3": color = UIColor(red: 0.696, green: 0.879, blue: 0.813, alpha: 1)
        case "4": color = UIColor(red: 0.718, green: 0.845, blue: 0.962, alpha: 1)
        case "5": color = UIColor(red: 1, green: 0.721, blue: 0.922, alpha: 1)
        case "6": color = UIColor(red: 0.712, green: 0.694, blue: 0.925, alpha: 1)
        default: break
        }
        return color
    }
    
    func getCheckBoxImage(colorNum:Int) -> UIImage? {
        var image = UIImage(named: "checkbox")
        switch(colorNum){
        case 1: image = UIImage(named: "checkbox-red")
        case 2: image = UIImage(named: "checkbox-yellow")
        case 3: image = UIImage(named: "checkbox-green")
        case 4: image = UIImage(named: "checkbox-blue")
        case 5: image = UIImage(named: "checkbox-pink")
        case 6: image = UIImage(named: "checkbox-purple")
        default:break
        }
        return image
    }
    
    func getSeletedCircleImage(colorNum:Int) -> UIImage? {
        var image = UIImage(named: "red-circle-selected")
        switch(colorNum){
        case 1: image = UIImage(named: "red-circle-selected")
        case 2: image = UIImage(named: "yellow-circle-selected")
        case 3: image = UIImage(named: "green-circle-selected")
        case 4: image = UIImage(named: "blue-circle-selected")
        case 5: image = UIImage(named: "pink-circle-selected")
        case 6: image = UIImage(named: "purple-circle-selected")
        default:break
        }
        
        return image
    }
    
}
