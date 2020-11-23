//
//  Favorites.swift
//  MyTvShows
//
//  Created by Jair on 20/11/20.
//

import UIKit
import CoreData
class Favorites: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var id:String = "0"
    var savedShows : [MyShows]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchFavs()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 95;
    }
    
    func fetchFavs()
    {
        do{
            self.savedShows = try context.fetch(MyShows.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }catch{}
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "fromFavorites")
        {
            let displayVC = segue.destination as! Details
            displayVC.id = self.id
        }
    }
}
extension Favorites: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedShows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell") as! FavCell
        let fav = self.savedShows![indexPath.row]
        cell.setFavorite(show: fav)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let fav = self.savedShows![indexPath.row]
        self.id = fav.id ?? ""
        self.performSegue(withIdentifier: "fromFavorites", sender: self)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            handleDelete(id: indexPath)   
        }
    }
    
    private func handleDelete(id:IndexPath)
    {
        
        let remove = self.savedShows![id.row]
        
        let alert = UIAlertController(
            title: "Estás seguro?",
            message: "Deseas remover \(remove.title ?? "") de tus favoritos",
            preferredStyle:.alert)
        
        alert.addAction(UIAlertAction(title: "Si", style: .default, handler:{
            action in
            self.context.delete(remove)
            do{try self.context.save()}
            catch
            {
                let error = UIAlertController(
                    title: "Oops,¡Algo salió mal!",
                    message: "No se pudo eliminar \(remove.title ?? "") de tus favoritos, ¿Quieres intentar nuevamente?",
                    preferredStyle:.alert)
                error.addAction(UIAlertAction(title: "ok", style: .default, handler:{
                    action in
                    self.handleDelete(id: id)
                }))
                self.present(alert,animated: true)
            }
            self.fetchFavs()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
        
    }
    
}
