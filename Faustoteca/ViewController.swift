//
//  ViewController.swift
//  Faustoteca
//
//  Created by Augusto Boranga on 24/06/16.
//  Copyright © 2016 Augusto Boranga. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var sounds = NSMutableArray()
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.allowsMultipleSelection = true
        
        let json = readJson()
        fillSoundsArray(json)
    }

    //MARK: UICollectionView
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sounds.count
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        (sounds[indexPath.row] as! Sound).play()
        print(indexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        (sounds[indexPath.row] as! Sound).play()
        print(indexPath.row)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("buttonCell", forIndexPath: indexPath) as! CustomCell
        cell.titleLabel.text = (sounds[indexPath.row]).title
        
        return cell
    }
    
    //MARK: IBAction
    @IBAction func buttonPressed(sender: AnyObject) {
        print("button pressed")
        
        let position = sender.convertPoint(CGPointZero, toView: self.collectionView)
        var indexpath = NSIndexPath()
        indexpath = self.collectionView.indexPathForItemAtPoint(position)!
        
        let theSound = sounds[indexpath.row] as! Sound
        
        if theSound.player.playing {
            theSound.player.pause()
        }
        
        theSound.player.currentTime = 0
        theSound.play()
    }
    
    //MARK: Other
    func fillSoundsArray(dict: NSDictionary) {
        let urls = dict.allKeys
        
        for index in 0...dict.count - 1 {
            let key = urls[index] as! String
            let newSound = Sound(title: dict.objectForKey(key) as! String, filePath: key)
            self.sounds.addObject(newSound)
        }
    }
    
    func readJson() -> NSDictionary {
        var json = NSDictionary()
        
        let path = NSBundle.mainBundle().pathForResource("faustoteca", ofType: "json")
        let jsonData = NSData(contentsOfFile: path!)
        
        do {
            json = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions()) as! NSDictionary
        } catch {
            print(error)
        }
        
        return json
    }
}

