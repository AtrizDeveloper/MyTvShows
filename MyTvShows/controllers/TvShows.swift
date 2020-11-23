//
//  TvShows.swift
//  MyTvShows
//
//  Created by Jair on 20/11/20.

import UIKit
import CoreData
class TvShows: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var id:String = "0"
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 95;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func fetchFavs(id : Int) -> Bool
    {
        var savedShows : [MyShows]?
        do{
            
            let request = MyShows.fetchRequest() as NSFetchRequest<MyShows>
            let pred = NSPredicate(format: "id == %@", "\(id)")
            request.predicate = pred
            savedShows = try context.fetch(request)
            return (savedShows?.count ?? 0) > 0
        }catch
        {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "fromTVList")
        {
            let displayVC = segue.destination as! Details
            displayVC.id = self.id
        }
    }
    
}
extension TvShows: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // Debido a que la API no cuenta con un EndPoint que devuelva la lista completa de
        // series, solicito solo las primeras 20 series del catalogo
        return 19
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Para no saturar esta sección, la configuración de la celda se hace dentro de la misma
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVShowCell") as! TVCell
        cell.setTVSwhow(index: indexPath.row+1)
        return cell
    }
        // canalizamos las acciones al lado derecho de la celda.
    func tableView(_ tableView: UITableView,editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{return .none}
    
    func tableView(_ tableView: UITableView,trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Handler para favoritos
        let favorite = UIContextualAction(style: .normal,title: "Favorite")
        { [weak self] (action, view, completionHandler) in
            self?.handleMarkAsFavorite(id:indexPath)
            completionHandler(true)
        }
        favorite.backgroundColor = .systemGreen

        // Handler para retirar de los favoritos
        let trash = UIContextualAction(style: .destructive,title: "Delete")
        { [weak self] (action, view, completionHandler) in
            self?.handleDelete(id:indexPath)
            completionHandler(true)
        }
        trash.backgroundColor = .systemRed
        
        // Revisamos si el elemento seleccionado se encuentra en los favoritos
        if fetchFavs(id: indexPath.row+1)
        {
            return UISwipeActionsConfiguration(actions: [trash])
        }
        else
        {
            return UISwipeActionsConfiguration(actions: [favorite])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // Abrimos detalles
        self.id = "\(indexPath.row+1)"
        self.performSegue(withIdentifier: "fromTVList", sender: self)
    }
    
    private func handleMarkAsFavorite(id: IndexPath) {
        let newShow = MyShows(context: self.context)
        let info = (tableView.cellForRow(at: id) as! TVCell).show
        newShow.id = info?.id
        newShow.img = info?.img
        newShow.title = info?.title
        do
        {
            try self.context.save()
        }
        catch
        {
            let alert = UIAlertController(
                title: "Oops,¡Algo salió mal!",
                message: "No se pudo guardar en favoritos, ¿Quieres intentar nuevamente?",
                preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler:{
                action in
                self.handleMarkAsFavorite(id: id)
            }))
            alert .addAction(UIAlertAction(title:"cancel",style: .cancel,handler: nil))
            self.present(alert,animated: true)
        }
    }
    
    private func handleDelete(id:IndexPath)
    {
        let info = (self.tableView.cellForRow(at: id) as! TVCell).show
        let alert = UIAlertController(
            title: "Estás seguro?",
            message: "Deseas remover \(info?.title ?? "") de tus favoritos",
            preferredStyle:.alert)

        alert.addAction(UIAlertAction(title: "Si", style: .default, handler:{
            action in
            do{
                let request = MyShows.fetchRequest() as NSFetchRequest<MyShows>
                let pred = NSPredicate(format: "id == %@", info?.id ?? "0")
                request.predicate = pred
                let remove = try self.context.fetch(request)
                if(remove.count>0)
                {
                    self.context.delete(remove[0])
                    try self.context.save()
                }else{ self.showError(message: "parece que no hay nada que eliminar")}
            }catch
            {
                let alert = UIAlertController(
                    title: "Oops,¡Algo salió mal!",
                    message: "No se pudo eliminar \(info?.title ?? "") de tus favoritos, ¿Quieres intentar nuevamente?",
                    preferredStyle:.alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler:{
                    action in
                    self.handleDelete(id: id)
                }))
                self.present(alert,animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showError(message:String)
    {
        let alert = UIAlertController(
            title: "Oops,¡Algo salió mal!",
            message: message,
            preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        self.present(alert,animated: true)
    }
}
