//
//  ViewControllerDisplay.swift
//  Ej10_11_TablasYCoreData
//
//  Created by user125877 on 25/4/17.
//  Copyright © 2017 user125877. All rights reserved.
//

import UIKit
import CoreData

class ViewControllerDisplay: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tablaDisplay: UITableView!
    //Declaramos esta variable como array de los objetos/entidades creados en la BD
    var managedObjects:[NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaDisplay.delegate = self
        tablaDisplay.dataSource = self
        // Do any additional setup after loading the view.
        
        //Nos traemos las variables declaradas en el AppDelegate para el uso de la base de datos
        let appDeletegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDeletegate!.persistentContainer.viewContext
        
        //Creamos un request sobre la entidad Grpuo
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Grupo")
        
        //Recuperamos la entidad Grupo con un try/catch
        do {
            managedObjects = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("No pude recuperar los datos guardados. El error fue \(error), \(error.userInfo)")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return managedObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "CellDetail", for: indexPath)
        
        //Creamos un objeto a partir del array recuperado de BD
        let managedObject = managedObjects[indexPath.row]
        //Asignamos a la celda el value de la "columna" valor de nuestro objeto
        celda.textLabel?.text = managedObject.value(forKey: "nombre") as? String
        
        return celda
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
