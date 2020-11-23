//
//  FavCell.swift
//  MyTvShows
//
//  Created by Jair on 20/11/20.
//

import UIKit
import Kingfisher
class FavCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var poster: UIImageView!
    
    func setFavorite(show : MyShows)
    {
        self.title.text = show.title ?? ""
        self.poster.kf.setImage(with: URL(string: show.img ?? ""))
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
