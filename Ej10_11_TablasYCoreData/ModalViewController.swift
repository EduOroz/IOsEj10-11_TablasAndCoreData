//
//  ModalViewController.swift
//  Ej10_11_TablasYCoreData
//
//  Created by user125877 on 25/4/17.
//  Copyright © 2017 user125877. All rights reserved.
//

import UIKit

class ModalViewController: UIViewController {

    var nombre: String = ""
    var genero: String = ""
    var pais: String = ""
    var ano: Int = 0
    var idGrupo: Int = 0
    
    @IBOutlet weak var tfPaisDialog: UITextField!
    @IBOutlet weak var tfNombreDialog: UITextField!
    
    @IBOutlet weak var tfGeneroDialog: UITextField!
    
    @IBOutlet weak var tfAnoDialog: UITextField!
    
    @IBOutlet weak var tfIdGrupo: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tfNombreDialog.text = nombre
        tfGeneroDialog.text = genero
        tfPaisDialog.text = pais
        tfAnoDialog.text = "\(ano)"
        tfIdGrupo.text = "ID: \(idGrupo)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickOK(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }

    @IBAction func clickX(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
