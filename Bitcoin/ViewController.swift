//
//  ViewController.swift
//  Bitcoin
//
//  Created by Gustavo Mendonca on 31/05/23.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var precoBitCoin: UILabel!
    
    @IBOutlet weak var btnAtualizar: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.RecuperarPrecoBitCoin()
    }
    
    func formatarPreco(preco: NSNumber) -> String{
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale(identifier: "pt-BR")
        
        if let precoFinal = nf.string(from: preco){
            return precoFinal
        }
        
        return "0,00"
    }
    
    
    func RecuperarPrecoBitCoin(){
        
        // quando for carregar o preco, o botao mudara o texto
        self.btnAtualizar.setTitle("Atualizando...", for: .normal)
        
        if let url = URL(string: "https://blockchain.info/ticker"){
            let tarefa = URLSession.shared.dataTask(with: url) { dados, requisicao, erro in
                
                if erro == nil{
                    
                    if let dadosRetorno = dados{
                        do {
                            if let objetoJson = try JSONSerialization.jsonObject(with: dadosRetorno, options: [])
                                as? [String: Any]{
                                
                                
                                if let brl = objetoJson["BRL"] as? [String: Any]{
                                    if let preco = brl["buy"] as? Double{
                                        let precoFormatado = self.formatarPreco(preco: NSNumber(value: preco))
                                        
                                        DispatchQueue.main.async(execute: {
                                            self.precoBitCoin.text = "R$ " + precoFormatado
                                            self.btnAtualizar.setTitle("Atualizar", for: .normal)
                                        })
                                    }
                                }
                            }
                        } catch{
                            print("erro")
                        }
                    }
                }else{
                    print("Erro")
                }
                
            }
            tarefa.resume()
        }
    }
    
    
    @IBAction func atualizarPreco(_ sender: Any) {
        
        self.RecuperarPrecoBitCoin()
    }
    
    
    

}

