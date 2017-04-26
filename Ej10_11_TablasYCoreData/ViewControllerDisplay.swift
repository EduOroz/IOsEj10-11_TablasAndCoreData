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
    
    var nombreToDialog: String = ""
    var anoToDialog: Int = 0
    var generoToDialog: String = ""
    var paisToDialog: String = ""
    var idGrupoToDialog: Int = 0
    
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
        
        //Recuperamos los contenidos de la entidad/tabla Grupo con un try/catch
        do {
            managedObjects = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("No pude recuperar los datos guardados. El error fue \(error), \(error.userInfo)")
        }
        
        //En caso de que no tengamos registros en la BD los recuperaremos del fichero DatosIniciales.plist
        
        if (managedObjects.count==0){
            print("No hay objetos en la BD vamos a crearlos desde el fichero de Datos Iniciales")
            //Creamos una ruta al fichero con los datos iniciales
            let pathPlist = Bundle.main.path(forResource: "DatosIniciales", ofType: "plist")
            //Cogemos los contenidos del fichero
            let datosPlist = NSArray(contentsOfFile: pathPlist!)!
            
            for diccionarioDatosPlist in datosPlist {
                
                //Insertaremos los contenidos en la BD
                let entity = NSEntityDescription.entity(forEntityName: "Grupo", in: managedContext)

                //Creamos un objeto manejado del tipo entidad en nuestro contexto para la BD
                let managedObject = NSManagedObject(entity: entity!, insertInto: managedContext)
                
                let diccionarioGrupo = diccionarioDatosPlist as! [String: AnyObject]
                
                //Asignamos el grupo a nuestro objeto manejado
                print("nombre registro en fichero a insertar \(diccionarioGrupo["nombre"])")
                managedObject.setValue(diccionarioGrupo["nombre"], forKeyPath: "nombre")
                managedObject.setValue(diccionarioGrupo["genero"], forKeyPath: "genero")
                managedObject.setValue(diccionarioGrupo["pais"], forKeyPath: "pais")
                managedObject.setValue(diccionarioGrupo["ano"], forKeyPath: "ano")
                managedObject.setValue(diccionarioGrupo["idGrupo"], forKeyPath: "idGrupo")
                
                //Con un try catch guardamos nuestro objeto en la BD
                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("No se pudo guardar, error \(error), \(error.userInfo)")
                }
            }

        }
        
        //Volvemos a recuperar los contenidos de la entidad/tabla Grupo
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Creamos un objeto a partir del array recuperado de BD
        let managedObject = managedObjects[indexPath.row]
        //Asignamos a la celda el value de la "columna" valor de nuestro objeto
        nombreToDialog = (managedObject.value(forKey: "nombre") as? String)!
        paisToDialog = (managedObject.value(forKey: "pais") as? String)!
        anoToDialog = (managedObject.value(forKey: "ano") as? Int)!
        generoToDialog = (managedObject.value(forKey: "genero") as? String)!
        idGrupoToDialog = (managedObject.value(forKey: "idGrupo") as? Int)!
        
        performSegue(withIdentifier: "SegueToDialog", sender: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        
        if (segue.identifier=="SegueToDialog"){
        let controller = segue.destination as! ModalViewController
        
        // Pass the selected object to the new view controller.
        controller.ano = anoToDialog
        controller.nombre = nombreToDialog
        controller.genero = generoToDialog
        controller.pais = paisToDialog
        controller.idGrupo = idGrupoToDialog
        
        }
    }
    

}
