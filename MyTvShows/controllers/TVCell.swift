//
//  TVCell.swift
//  MyTvShows
//
//  Created by Jair on 20/11/20.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON
class TVCell: UITableViewCell {

    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var title: UILabel!
    var show : Show?
    func setTVSwhow(index: Int)
    {
        let request = AF.request("\(urlshows)\(index)").validate()
        request.responseJSON
        {
            response in
            switch response.result
            {
                case .success(let value):
                    let json = JSON(value)
                    self.title.text = json["name"].string ?? ""
                    let url = URL(string: json["image"]["medium"].string ?? "")
                    self.poster.kf.setImage(with: url)
                    
                    self.show = Show(id: "\(json["id"].int ?? 0)",
                                title: json["name"].string ?? "",
                                img: json["image"]["medium"].string ?? "")
                    
                case .failure(let error):print(error)
            }
        }
    }
}
