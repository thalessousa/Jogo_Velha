//
//  ViewController.swift
//  TicTacToe
//
//  Created by Skip Wilson on 6/5/14.
//  Copyright (c) 2014 Bisonkick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum Jogador: Int {
        case ComputadorJogador = 0, UsuarioJogador = 1
    }
    
    //MARK: Variaveis
    @IBOutlet var JogoVelhaImagem1: UIImageView!
    @IBOutlet var JogoVelhaImagem2: UIImageView!
    @IBOutlet var JogoVelhaImagem3: UIImageView!
    @IBOutlet var JogoVelhaImagem4: UIImageView!
    @IBOutlet var JogoVelhaImagem5: UIImageView!
    @IBOutlet var JogoVelhaImagem6: UIImageView!
    @IBOutlet var JogoVelhaImagem7: UIImageView!
    @IBOutlet var JogoVelhaImagem8: UIImageView!
    @IBOutlet var JogoVelhaImagem9: UIImageView!

    
    @IBOutlet var resetBtn : UIButton!
    @IBOutlet var userMessage : UILabel!
    
    var jogadas = [Int:Int]()
    var pronto = false
    
    var aiPensando = false
    
    var JogoVelhaImagens = [UIImageView]()
    
    override func viewCarregou() {
        super.viewCarregou()
        // Do any additional setup after loading the view, typically from a nib.
        
        ticTacImages = [ticTacImage1, ticTacImage2, ticTacImage3, ticTacImage4, ticTacImage5, ticTacImage6, ticTacImage7 ,ticTacImage8 ,ticTacImage9]
        
        for imageView in ticTacImages {
            
            imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "imageClicked:"))
            
        }
    }
    
    //Gesture Reocgnizer method
    func imageClicked(reco: UITapGestureRecognizer) {
        
        var imageViewTapped = reco.view as UIImageView
        
        println(jogadas[imageViewTapped.tag])
        println(aiPensando)
        println(pronto)
        
        if jogadas[imageViewTapped.tag] == nil && !aiPensando && !pronto {
            setPosicaoImagem(imageViewTapped.tag, player:.UserPlayer)
        }
        
        checarVitoria()
        aiTurno()
        
    }
    
    @IBAction func resetBtnClicked(sender : UIButton) {
        pronto = false
        resetBtn.hidden = true
        userMessage.hidden = true
        reset()
    }
    
    func setPosicaoImagem(posicao:Int,player:Player){
        var playerMark = player == .UserPlayer ? "x" : "o"
        println("Configurando posição \(player.toRaw()) posicao \(posicao)")
        plays[posicao] = player.toRaw()
        
        JogoVelhaImagens[posicao].image = UIImage(named: playerMark)

    }
    
    func checarVitoria(){
        var JogadorVenceu = 1
        var ComputadorVenceu = 0
        var Ganhador = ["Eu":0,"venci":1]
        for (key,value) in Ganhador {
            if ((jogadas[6] == value && jogadas[7] == value && jogadas[8] == value) || //Checa o fundo
            (jogadas[3] == value && jogadas[4] == value && jogadas[5] == value) || //Chega o meio
            (jogadas[0] == value && jogadas[1] == value && jogadas[2] == value) || //Checa o topo
            (jogadas[6] == value && jogadas[3] == value && jogadas[0] == value) || //Checa o lado esquerdo
            (jogadas[7] == value && jogadas[4] == value && jogadas[1] == value) || //Checa o meio para o fundo
            (jogadas[8] == value && jogadas[5] == value && jogadas[2] == value) || //Checa o lado direito
            (jogadas[6] == value && jogadas[4] == value && jogadas[2] == value) || //Checa diagonal da esquerda pra direita
                (jogadas[8] == value && jogadas[4] == value && jogadas[0] == value)){//Checa diagonal da direita pra esquerda
                    userMessage.hidden = false
                    userMessage.text = "Parece que o \(key) venceu!"
                    resetBtn.hidden = false;
                    pronto = true;
            }
        }
    }
    
    func reset() {
        jogadas = [:]
        JogoVelhaImagem1.image = nil
        JogoVelhaImagem2.image = nil
        JogoVelhaImagem3.image = nil
        JogoVelhaImagem4.image = nil
        JogoVelhaImagem5.image = nil
        JogoVelhaImagem6.image = nil
        JogoVelhaImagem7.image = nil
        JogoVelhaImagem8.image = nil
        JogoVelhaImagem9.image = nil
    }
    
    func checarFundo(#value:Int) -> [String]{
        return ["Fundo",checkFor(value, inList: [6,7,8])]
    }
    func checarMeio(#value:Int) -> [String]{
        return ["Meio",checkFor(value, inList: [3,4,5])]
    }
    func checarTopo(#value:Int) -> [String]{
        return ["Topo",checkFor(value, inList: [0,1,2])]
    }
    func checarEsquerda(#value:Int) -> [String]{
        return ["Esquerda",checkFor(value, inList: [0,3,6])]
    }
    func checarMeioAbaixo(#value:Int) -> [String]{
        return ["MeioAbaixo",checkFor(value, inList: [1,4,7])]
    }
    func checarDireito(#value:Int) ->  [String]{
        return ["Direito",checkFor(value, inList: [2,5,8])]
    }
    func checarDiagonalEsquerdaDireita(#value:Int) ->  [String]{
        return ["DiagonalEsquerdaDireita",checkFor(value, inList: [2,4,6])]
    }
    func checarDiagonalDireitaEsquerda(#value:Int) ->  [String]{
        return ["DiagonalDireitaEsquerda",checkFor(value, inList: [0,4,8])]
    }
    
    func checkFor(value:Int, inList:[Int]) -> String {
        var conclusao = ""
        for celula in inList {
            if jogadas[celula] == value {
                conclusao += "1"
            }else{
                conclusao += "0"
            }
        }
        return conclusao
    }
    
    func checkThis(#value:Int) -> [String]{
        return ["right","0"]
    }
    
    func rowCheck(#value:Int) -> [String]?{
        var acceptableFinds = ["011","110","101"]
        var findFuncs = [self.checkThis]
        var algorthmResults = findFuncs[0](value: value)
        for algorthm in findFuncs {
            var algorthmResults = algorthm(value: value)
            var findPattern = find(acceptableFinds,algorthmResults[1])
            if findPattern != nil {
                return algorthmResults
            }
        }
        return nil
    }
    
    func estaOcupado(posicao:Int) -> Bool {
        println("Ocupado\(posicao)")
        if jogadas[posicao] != nil {
            return true
        }
        return false
    }
    
    func aiJogada(lugar:String,pattern:String) -> Int {
        var padraoEsquerdo = "011"
        var padraoDireito = "110"
        var padraoMeio = "101"
        switch lugar {
            case "topo":
                if pattern == padraoEsquerdo {
                    return 0
                }else if pattern == padraoDireito{
                    return 2
                }else{
                    return 1
                }
            case "fundo":
                if pattern == padraoEsquerdo {
                    return 6
                }else if pattern == padraoDireito{
                    return 8
                }else{
                    return 7
                }
            case "esquerda":
                if pattern == padraoEsquerdo {
                    return 0
                }else if pattern == padraoDireito{
                    return 6
                }else{
                    return 3
                }
            case "direito":
                if pattern == padraoEsquerdo {
                    return 2
                }else if pattern == padraoDireito{
                    return 8
                }else{
                    return 5
                }
            case "meioVertical":
                if pattern == padraoEsquerdo {
                    return 1
                }else if pattern == padraoDireito{
                    return 7
                }else{
                    return 4
                }
            case "meioHorizontal":
                if pattern == padraoEsquerdo {
                    return 3
                }else if pattern == padraoDireito{
                    return 5
                }else{
                    return 4
                }
            case "diagonalEsquerdaDireita":
                if pattern == padraoEsquerdo {
                    return 0
                }else if pattern == padraoDireito{
                    return 8
                }else{
                    return 4
                }
            case "diagonalDireitaEsquerda":
                if pattern == padraoEsquerdo {
                    return 2
                }else if pattern == padraoDireito{
                    return 6
                }else{
                    return 4
                }
            
            default:
            return 4
        }
    }
    
    func primeiraDisponivel(#eCanto:Bool) -> Int? {
        var posicoes = eCanto ? [0,2,6,8] : [1,3,5,7]
        for posicoes in posicoes {
            println("checando \(posicao)")
            if !estaOcupado(posicao) {
                println("não ocupado \(posicao)")
                return posicao
            }
        }
        return nil
    }
    
    
    
    func aiTurno() {
        if pronto {
            return
        }
        aiPensando = true
        //O computador tem 2 jogadas seguidas
        if let result = rowCheck(value: 0){
            println("Computador tem duas jogadas seguidas")
            var aondeJogar = aondeJogar(result[0], pattern: result[1])
            if !isOccupied(aondeJogarResultado) {
                setImagemParaPosicao(aondeJogarResultado, player: .ComputadorJogador)
                aiPensando = false
                checarVitoria()
                return
            }
        }
        //O jogador tem 2 jogadas seguidas
        if let result = rowCheck(value: 1) {
            var aondeJogarResultado = aondeJogar(result[0], pattern: result[1])
            if !estaOcupado(aondeJogarResultado) {
                setImagemParaPosicao(aondeJogarResultado, player: .ComputadorJogador)
                aiPensando = false
                checarVitoria()
                return
            }

        //O centro tá livre?
        }
        if !estaOcupado(4) {
            setImagemParaPosicao(4, player: .ComputadorJogador)
            aiPensando = false
            checarVitoria()
            return
        }
        if let cantoDisponivel = primeiraDisponivel(eCanto: true){
            setImagemParaPosicao(cantoDisponivel, player: .ComputadorJogador)
            aiPensando = false
            checarVitoria()
            return
        }
        if let ladoDisponivel = primeiraDisponivel(eCanto: false){
            setImagemParaPosicao(ladoDisponivel, player: .ComputadorJogador)
            aiPensando = false
            checarVitoria()
            return
        }
        
        userMessage.hidden = false
        userMessage.text = "Parece que foi um empate!"
        
        reset()
        
        println(rowCheck(value: 0))
//        Duas jogadas seguidas
        println(rowCheck(value: 1))
        
        
        aiPensando = false
    }
    
    
    
//    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
//        println("Touch begins \(event)")
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

