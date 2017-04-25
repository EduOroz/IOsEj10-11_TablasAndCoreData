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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        { mostrarAlerta(texto: "Falta de escribir el Nombre")
        } else {
            if (tfGenero.text=="")
            { mostrarAlerta(texto: "Falta de escribir el Genero")
            } else {
                if (tfPais.text=="")
                { mostrarAlerta(texto: "Falta de escribir el Pais")
                } else {
                    if (tfAno.text=="")
                    { mostrarAlerta(texto: "Falta de escribir el Año")
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
        managedObject.setValue(0, forKeyPath: "idGrupo")
        
        //Con un try catch guardamos nuestro objeto en la BD
        do {
            try managedContext.save()
            performSegue(withIdentifier: "SegueFromFormToDisplay", sender: nil)
        } catch let error as NSError {
            print("No se pudo guardar, error \(error), \(error.userInfo)")
        }
        
    }
    
    func mostrarAlerta (texto: String ){
        //Creamos una alerta
        let alerta = UIAlertController(title: "Faltan datos", message: texto, preferredStyle: UIAlertControllerStyle.alert)
        
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

