//
//  ViewController.swift
//  EpubReader
//
//  Created by Jetec-RD on 2019/3/6.
//  Copyright © 2019 JETEC ELETRONICS. All rights reserved.
//

import UIKit
import SSZipArchive

class ViewController: UIViewController {

    let fm = FileManager.default
    let home = NSHomeDirectory()
    let tmp = NSHomeDirectory() + "/tmp/"
    let fileName = "e-book-1"
    let fileType = "epub"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let path = home + "/tmp/" + getFileName(fileName, fileType)
        copyEpub(to: path)
        readEpub(from: path)
        do {
            guard let texts = try? fm.contentsOfDirectory(atPath: tmp + fileName + "/OEBPS/Text") else {return}
            for i in texts {
                print(i)
            }
            
            guard let images = try? fm.contentsOfDirectory(atPath: tmp + fileName + "/OEBPS/Images") else {return}
            for i in images {
                print(i)
            }
            guard let string = try? String(contentsOfFile: tmp + fileName + "/OEBPS/Text/Section0002.xhtml") else {return}
            print(string)
        }
    }
    
    func copyEpub(to path: String) {
        guard let file = Bundle.main.path(forResource: fileName, ofType: fileType) else {print("Epub not find"); return}
        guard !fm.fileExists(atPath: path) else {print("File already exist"); return}
        do {
            try fm.copyItem(at: URL(fileURLWithPath: file), to: URL(fileURLWithPath: path))
        }catch {
            print(error)
        }
    }
    
    func readEpub(from path: String) {
        let zipPath = home + "/tmp/" + fileName
        guard fm.fileExists(atPath: path), !fm.fileExists(atPath: zipPath) else {print("File not exist"); return}
        if SSZipArchive.unzipFile(atPath: tmp + getFileName(fileName, fileType), toDestination: tmp + fileName) {
            do {
                guard let files = try? fm.contentsOfDirectory(atPath: tmp + fileName + "/OEBPS") else {return}
                for i in files {
                    print(i)
                }
                
            }
        }
    }
    
    func getFileName(_ name: String, _ type: String) -> String {
        return name + "." + type
    }


}

