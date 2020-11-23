//
//  Details.swift
//  MyTvShows
//
//  Created by Jair on 20/11/20.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreData
import Kingfisher
class Details: UIViewController
{
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var summarylabel: UILabel!
    @IBOutlet weak var imbdButton: UIButton!
    @IBOutlet weak var fabButton: UIBarButtonItem!
    @IBOutlet weak var statusLabel : UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var id : String?
    var img : String?
    var name : String?
    var imdb : String?
    
    var isFab : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        getDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkShow()
    }
    
    func checkShow()
    {
        do{
            let query = MyShows.fetchRequest() as NSFetchRequest<MyShows>
            let pred = NSPredicate(format: "id == %@", self.id ?? "0")
            query.predicate = pred
            let fav = try self.context.fetch(query)
            if(fav.count>0)
            {
                isFab = true
                self.fabButton.image = UIImage(imageLiteralResourceName: "fav")
                    .withRenderingMode(.alwaysOriginal)
            }else
            {
                isFab = false
                self.fabButton.image = UIImage(imageLiteralResourceName: "unfav")
                    .withRenderingMode(.alwaysOriginal)
            }
        }
        catch
        {
            isFab = false
            
        }
    }
    func getDetails()
    {
        let request = AF.request("\(urlshows)\(self.id ?? "0")").validate()
        request.responseJSON
        {
            response in
            switch response.result
            {
                case .success(let value):
                    let json = JSON(value)
                    self.poster.kf.setImage(with: URL(string: json["image"]["original"].string ?? ""))
                    self.img = json["image"]["original"].string ?? ""
                    self.rateLabel.text = "\(json["rating"]["average"].float ?? 0)"
                    self.title = json["name"].string ?? ""
                    self.name = json["name"].string ?? ""
                    
                    self.statusLabel.text = json["status"].string ?? ""
                    self.summarylabel.text = (json["summary"].string ?? "").htmlToString
                    var genres : String = ""
                    for (_,sub):(String, JSON) in json["genres"]
                    {
                        genres = "\(genres),\(sub)"
                    }
                    self.genresLabel.text = genres
                    
                    if let ext = json["externals"]["imdb"].string
                    {
                        self.imdb = ext
                        self.imbdButton.isHidden = false
                        self.imbdButton.addTarget(self, action:#selector(self.goIMDB), for: .touchUpInside)
                    }
                
                case .failure(let error):
                    print(error)
                    let alert = UIAlertController(
                        title: "Estás seguro?",
                        message: "Ocurrió un error al consultar el servicio. ¿Quieres intentar nuevamente?",
                        preferredStyle:.alert)
                    alert.addAction(UIAlertAction(title: "SI", style: .default, handler: {action in self.getDetails()}))
                    alert.addAction(UIAlertAction(title: "no", style: .cancel, handler: {action in
                        self.navigationController?.popToRootViewController(animated: true)
                    }))
                    self.present(alert,animated: true)
            }
        }
    }
   
    @objc func goIMDB()
    {
        if let url = URL(string: "https://www.imdb.com/title/\(self.imdb ?? "")") {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func makeMeFan(_ sender: Any)
    {
        if isFab
        {
            delete()
        }else
        {
            save()
        }
        checkShow()
    }
    
    func save()
    {
        let show = MyShows(context: self.context)
        show.id = id
        show.title = name
        show.img = img
        do
        {
            try self.context.save()
        }
        catch
        {
            
        }
    }
    
    func delete()
    {
        do
        {
            let request = MyShows.fetchRequest() as NSFetchRequest<MyShows>
            let pred = NSPredicate(format: "id == %@", self.id ?? "0")
            request.predicate = pred
            let remove = try self.context.fetch(request)
            if(remove.count>0)
            {
                self.context.delete(remove[0])
                try self.context.save()
            }
        }
        catch{}
    }
    
}
extension String {
    var htmlToNiceString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToNiceString?.string ?? ""
    }
}
