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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sounds.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (sounds[indexPath.row] as! Sound).play()
        print(indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        (sounds[indexPath.row] as! Sound).play()
        print(indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "buttonCell", for: indexPath) as! CustomCell
        cell.titleLabel.text = ((sounds[indexPath.row]) as AnyObject).title
        cell.button.tag = indexPath.row
        return cell
    }

    // MARK: IBAction
    @IBAction func buttonPressed(_ sender: AnyObject) {

        let theSound = sounds[sender.tag] as! Sound

        if theSound.player.isPlaying {
            theSound.player.pause()
        }

        theSound.player.currentTime = 0
        theSound.play()
    }

    // MARK: Other
    func fillSoundsArray(_ dict: NSDictionary) {
        let urls = dict.allKeys

        for index in 0...dict.count - 1 {
            let key = urls[index] as! String
            
            let newSound = Sound(title: dict.object(forKey: key) as! String, filePath: key)
            self.sounds.add(newSound)
        }
    }

    func readJson() -> NSDictionary {
        var json = NSDictionary()

        let path = Bundle.main.path(forResource: "faustoteca", ofType: "json")
        let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path!))

        do {
            json = try JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions()) as! NSDictionary
        } catch {
            print(error)
        }

        return json
    }

}

#if os(tvOS)
    extension ViewController {

        override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
            guard let faustoButton = context.nextFocusedView, let previousFausto = context.previouslyFocusedView else { return }
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

