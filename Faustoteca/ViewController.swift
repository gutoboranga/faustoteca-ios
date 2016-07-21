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

    // MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.allowsMultipleSelection = true

        let json = readJson()
        fillSoundsArray(json)
    }

    // MARK: UICollectionView
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
        cell.button.tag = indexPath.row
        return cell
    }

    // MARK: IBAction
    @IBAction func buttonPressed(sender: AnyObject) {

        let theSound = sounds[sender.tag] as! Sound

        if theSound.player.playing {
            theSound.player.pause()
        }

        theSound.player.currentTime = 0
        theSound.play()
    }

    // MARK: Other
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

#if os(tvOS)
    extension ViewController {

        override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
            guard let faustoButton = context.nextFocusedView, previousFausto = context.previouslyFocusedView else { return }
            UIView.animateWithDuration(0.2) {
                previousFausto.transform = CGAffineTransformMakeScale(1, 1)
                faustoButton.transform = CGAffineTransformMakeScale(1.4, 1.4)
            }
        }

        func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
            return false
        }
    }
#endif

