//
//  ReviewsViewController.swift
//  ITServiceWithAuth
//
//  Created by Admin on 16.06.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class ReviewsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func ReviewToCreate(sender: AnyObject) {
        self.performSegueWithIdentifier("ReviewToCreate", sender: self)
    }
    func createStars(label: UILabel!, rate: Double, cellView: ReviewsCollectionViewCell) {
        for index2 in 1...5 {
            if Double(index2) <= rate {
                var bgImage: UIImageView?
                let image: UIImage = UIImage(named: "ic_star")!
                bgImage = UIImageView(image: image)
                bgImage!.frame = CGRectMake(label.frame.origin.x + 110 + (CGFloat(index2) - 1) * 30, label.frame.origin.y, 24,24)
                cellView.addSubview(bgImage!)
            } else if Double(index2) <= (rate + 0.5) {
                var bgImage: UIImageView?
                let image: UIImage = UIImage(named: "ic_star_half")!
                bgImage = UIImageView(image: image)
                bgImage!.frame = CGRectMake(label.frame.origin.x + 110 + (CGFloat(index2) - 1) * 30, label.frame.origin.y, 24,24)
                cellView.addSubview(bgImage!)
            } else {
                var bgImage: UIImageView?
                let image: UIImage = UIImage(named: "ic_star_border")!
                bgImage = UIImageView(image: image)
                bgImage!.frame = CGRectMake(label.frame.origin.x + 110 + (CGFloat(index2) - 1) * 30, label.frame.origin.y, 24,24)
                cellView.addSubview(bgImage!)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ReviewsCollectionViewCell
        
        let review = reviews[indexPath.row]
        cell.author.text = review.authorFirst + " " + review.authorSecond
        cell.textFile.text = review.description
        
        let inFormatter = NSDateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "ru_RU")
        inFormatter.dateFormat = "M/d/yyyy HH:mm:ss a" //"12/8/2014 12:00:00 AM"
        
        let outFormatter = NSDateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "ru_RU")
        outFormatter.dateFormat = "dd MMMM HH:mm"
        
        let date = inFormatter.dateFromString(review.dateTimeShow)!
        cell.dateField.text = "Дата публикации: " + outFormatter.stringFromDate(date)
        
        for index in 1...4 {
         switch index {
            case 1:
                let rate = Double((review.speed))
                createStars(cell.speed, rate: rate!, cellView: cell)
                break
            case 2:
                let rate = Double((review.cost))
                createStars(cell.cost, rate: rate!, cellView: cell)
                break
            case 3:
                let rate = Double((review.court))
                createStars(cell.cort, rate: rate!, cellView: cell)
                break
            case 4:
                let rate = Double((review.quality))
                createStars(cell.quality, rate: rate!, cellView: cell)
                break
            default:
                break
            }
         }
        
        
        return cell
    }
}
