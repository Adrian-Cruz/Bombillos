//
//  ViewController.swift
//  Bombillos
//
//  Created by Adrian on 05/04/20.
//  Copyright © 2020 AdrianCruz. All rights reserved.
//

import UIKit

//0 empty square
//1 wall
//2 bulb
//3 iluminated square
enum ArrayValue : Int{
    case empty = 0
    case wall = 1
    case bulb = 2
    case iluminated = 3
}

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonFile: UIButton!
    @IBOutlet weak var myScrollView: UIScrollView!
    
    
    var originalArray = [[Int]]()
    var arrSolution = [[Int]]()
    let widthImages = 70
    let heightImages = 70
    var globalPositionX = 100
    var globalPositionY = 150
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func clickOpenFile(_ sender: UIButton) {
        globalPositionX = 100
        globalPositionY = 150
        removeSubViews()
        openFileAndGetData()
        calculateScrollViewSize()
        
        let graph = Graph()
        graph.createGraphFromArray(originalArray)
        graph.callSetLightBulbs()
        arrSolution = graph.arrayOfNodesToArray()
        drawArray(array: originalArray, initialPositionX: globalPositionX, initialPositionY: globalPositionY)
        drawArray(array: arrSolution, initialPositionX: globalPositionX, initialPositionY: globalPositionY)
    }
    
    func removeSubViews(){
        let subViews = self.myScrollView.subviews
        for subview in subViews{
            if subview != buttonFile {
                subview.removeFromSuperview()
            }
        }
    }
    
    func calculateScrollViewSize(){
        let widthMatrix = originalArray[0].count * widthImages + 300
        let heightMatrix = originalArray.count * heightImages * 2 + 300
        //myScrollView.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        myScrollView.contentSize = CGSize(width: widthMatrix, height: heightMatrix)
        
    }
    
    func openFileAndGetData(){
        originalArray = [[Int]]()
        let filename = "matrix1"
        if let path = Bundle.main.path(forResource: filename, ofType: "txt") {
            do {
                let text = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
                print(text)
                convertTextToArray(text)
            } catch {
                print("Failed to read text from \(filename)")
            }
        } else {
            print("Failed to load file from app bundle \(filename)")
        }
    }
    
    func convertTextToArray(_ text : String){
        let lines = text.split { $0.isNewline }
        for line in lines {
            let intArray = line.compactMap{Int(String($0))}
            originalArray.append(intArray)
        }
    }
    
    

    func drawArray(array: [[Int]], initialPositionX: Int, initialPositionY: Int){
        var x = initialPositionX
        var y = initialPositionY
        for i in 0..<array.count{
            
            for j in 0..<array[i].count{
                let imageView = returnImageFromInt(value: ArrayValue(rawValue: array[i][j])!)
                imageView.frame = CGRect(x: x, y: y, width: widthImages, height: heightImages)
                myScrollView.addSubview(imageView)
                x += widthImages
            }
            x = initialPositionX
            y+=heightImages
        }
        globalPositionY = y + 100
    }
    
    func returnImageFromInt(value: ArrayValue)->UIImageView{
        var imageName = ""
        switch value {
        case ArrayValue.empty:
            imageName = "white.png"
        case ArrayValue.bulb:
            imageName = "bulb.png"
        case ArrayValue.wall:
            imageName = "wall.png"
        case ArrayValue.iluminated:
            imageName = "yellow.png"
        default:
            print("error invalid value")
        }
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.layer.borderWidth = 1.5
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    

}

