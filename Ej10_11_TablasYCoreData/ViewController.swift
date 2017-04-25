//
//  ViewController.swift
//  Ej10_11_TablasYCoreData
//
//  Created by user125877 on 25/4/17.
//  Copyright © 2017 user125877. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfGenero: UITextField!
    @IBOutlet weak var tfPais: UITextField!
    @IBOutlet weak var tfAno: UITextField!
    
    //Declaramos esta variable como array de los objetos/entidades creados en la BD
    var managedObjects:[NSManagedObject] = []
    var id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Vamos a recuperar cuantos grupos tenemos creados para que al añadir un grupo aumentemos en 1 el idGrupo
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
        
        id = managedObjects.count

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onClickLimpiar(_ sender: UIButton) {
        tfNombre.text = ""
        tfGenero.text = ""
        tfPais.text = ""
        tfAno.text = ""
    }
    
    
    @IBAction func onClickGuardar(_ sender: UIButton) {
        
        //Revisamos si los TextFields están vacíos
        if (tfNombre.text=="")
        { mostrarAlerta(titulo:"Faltan Datos", texto: "Falta de escribir el Nombre")
        } else {
            if (tfGenero.text=="")
            { mostrarAlerta(titulo:"Faltan Datos", texto: "Falta de escribir el Genero")
            } else {
                if (tfPais.text=="")
                { mostrarAlerta(titulo:"Faltan Datos", texto: "Falta de escribir el Pais")
                } else {
                    if (tfAno.text=="")
                    { mostrarAlerta(titulo:"Faltan Datos", texto: "Falta de escribir el Año")
                    } else {
                        guardarGrupo(nombre: tfNombre.text!, genero: tfGenero.text!, pais: tfPais.text!, ano: Int(tfAno.text!)!)
                    }
                }
            }
        }
    }
    
    func guardarGrupo (nombre: String, genero:String, pais:String, ano: Int){
        
        //Nos traemos las variables declaradas en el AppDelegate para el uso de la base de datos
        let appDeletegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDeletegate!.persistentContainer.viewContext
        
        //Creamos una variable entidad para la Entidad Palabra que tenemos en la BD
        let entity = NSEntityDescription.entity(forEntityName: "Grupo", in: managedContext)!
        
        //Creamos un objeto manejado del tipo entidad en nuestro contexto para la BD
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        
        //Asignamos el grupo a nuestro objeto manejado
        managedObject.setValue(nombre, forKeyPath: "nombre")
        managedObject.setValue(genero, forKeyPath: "genero")
        managedObject.setValue(pais, forKeyPath: "pais")
        managedObject.setValue(ano, forKeyPath: "ano")
        
        //Aumentamos en 1 el id y lo asignamos a idGrupo
        id = id + 1
        managedObject.setValue(id, forKeyPath: "idGrupo")
        
        //Con un try catch guardamos nuestro objeto en la BD
        do {
            try managedContext.save()
            performSegue(withIdentifier: "SegueFromFormToDisplay", sender: nil)
        } catch let error as NSError {
            print("No se pudo guardar, error \(error), \(error.userInfo)")
        }
        
    }
    
    @IBAction func onClickBorrar(_ sender: UIButton) {
        
        //Creamos una alerta en la que solicitaremos el id a borrar
        let alerta = UIAlertController(title: "ID a Borrar", message: "Introduce el ID a Borrar", preferredStyle: UIAlertControllerStyle.alert)
        
        //Añadimos botones a la alerta
        alerta.addAction(UIAlertAction(title: "Borrar", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            let textField =  alerta.textFields!.first       //recogemos el texto del textField
            self.Borrar(id: textField!.text!)  //Ejecutamos la funcion para borrar el registro solicitado
        }
        ))
        
        let cancelar = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default, handler: { alertAction in
            ()
            alerta.dismiss(animated: true, completion: nil)
        })
        
        //Añadimos un campo para introducir texto y recuperar el id a borrar
        alerta.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Introduce el id a Eliminar"}
        
        alerta.addAction(cancelar)
        
        //Mostramos la alerta en nuestra vista
        self.present(alerta, animated: true, completion: nil)
    }
    
    func Borrar (id: String){
        //Nos traemos las variables declaradas en el AppDelegate para el uso de la base de datos
        let appDeletegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDeletegate!.persistentContainer.viewContext
        
        //Creamos un request sobre la entidad Grpuo
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Grupo")
        //Configuramos el request para que solo nos devuelva los objetos con nuestro id
        fetchRequest.predicate = NSPredicate(format: "idGrupo == %@", id)
        
        do {
            let results = try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            if (results.count > 1) {
                
                print("Encontrado mas de 1 grupo, no podemos borrar")
            } else {
                if (results.count == 1) {
                    let managedObject = results.first as! Grupo
                    managedContext.delete(managedObject)
                    
                    do {
                        try managedContext.save()
                        mostrarAlerta(titulo: "Borrado el registro", texto: "Borrado el id \(id)")
                    } catch let error as NSError {
                        print("Error al eliminar: \(error)")
                    }
                    
                } else {
                    print("No hay personas.")
                }
            }
        } catch let error as NSError {
            print("Error al recuperar: \(error)")
        }
        
    }
    
    func mostrarAlerta (titulo:String, texto: String ){
        //Creamos una alerta
        let alerta = UIAlertController(title: titulo, message: texto, preferredStyle: UIAlertControllerStyle.alert)
        
        let volver = UIAlertAction(title: "Volver", style: UIAlertActionStyle.default, handler: { alertAction in
            ()
            alerta.dismiss(animated: true, completion: nil)
        })
        
        alerta.addAction(volver)
        
        //Mostramos la alerta en nuestra vista
        self.present(alerta, animated: true, completion: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}

