//
//  ViewController.swift
//  Transparency
//
//  Created by Rafael Takahashi on 26/05/23.
//

import UIKit
import Flutter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openModal(_ sender: UIButton) {
        showFlutter(pageName: "modal")
    }
    
    @IBAction func openCard(_ sender: UIButton) {
        showFlutter(pageName: "card")
    }
    
    @objc func showFlutter(pageName: String) {
        let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        
        // Prefira usar um interop navigator. Esta navegação está improvisada.
        let channel = FlutterMethodChannel(name: "method-channel", binaryMessenger: flutterViewController.binaryMessenger)
        channel.invokeMethod("navigate", arguments: pageName)
        
        // Minhas observações sobre quais estilos funcionam para mostrar modais Flutter:
        //
        // .fullScreen - Não funciona, oculta a view atrás.
        // .pageSheet - Funciona, encolhe a view atrás e mostra a view Flutter por cima. A view Flutter pode ser deslizada para baixo. Note que em iPads, a view atrás não encolhe e um pouco de espaço é deixado dos lados da tela Flutter.
        // .formSheet - Funciona, igual ao .pageSheet mas deixa mais espaço nos lados em telas grandes.
        // .currentContext - Não funciona; desliza um modal para cima, mas não mostra a view atrás.
        // .custom - Funciona; sem usar configurações adicionais é idêntico ao .overFullScreen.
        // .overFullScreen - Funciona, desliza a view Flutter por cima sem alterar a view atrás. O usuário não consegue deslizar a view Flutter como no .pageSheet, o pop precisa ocorrer manualmente pois o gesto de voltar uma página também não funciona (pois a página flutter desliza para cima). NOTE que o modal Flutter que está sendo usado aqui como exemplo tem seu próprio listener de toque que chama um pop() quando o usuário toca fora da janela. A view Flutter cobre o máximo de espaço possível na tela, usando uma cor transparente fora da janela.
        // .overCurrentContext - Funciona, siilar ao .overFullScreen mas se a tela atual for um modal, a tela Flutter aparece dentro do modal ao invés de cobrir a tela toda. Não há diferença neste exemplo.
        // .popover - Mesmo que o .formSheet no iOS 13, e mesmo que o .fullScreen no iOS 12.
        // .blurOverFullScreen - Não use, disponível somente no tvOS 11+.
        // .none - Não use, causa crash. Este valor não serve para mostrar views.
        // .automatic (Somente iOS 13+) - Pode variar dependendo do view controller; aqui, é o mesmo que .pageSheet.
        flutterViewController.modalPresentationStyle = .overFullScreen
        // Pede para o Flutter criar uma view transparente.
        flutterViewController.isViewOpaque = false
        
        present(flutterViewController, animated: true, completion: nil)
    }

}

