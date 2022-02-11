//
//  ViewController.swift
//  MidasTest
//
//  Created by Vincent on 11/02/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UITextView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discPriceLabel: UILabel!

    var dictPayload = Payload()

    override func viewDidLoad(){
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = "http://midas-be-task.herokuapp.com/midas/config/v1/foodDelivery/dataContent?version=1"
        getData(from: url) { payload in
            DispatchQueue.main.async {
                self.titleLabel.text = payload.payload?[0].shop[0].Menus[0].title
                self.descLabel.text = payload.payload?[0].shop[0].Menus[0].ind
                self.priceLabel.text = "Price: Rp\(payload.payload?[0].shop[0].Menus[0].discPrice ?? 0)"
                self.discPriceLabel.text = "NOW ONLY: Rp\(payload.payload?[0].shop[0].Menus[0].price ?? 0)"
            }
        }
    } 
    
    private func getData(from url: String, completion: @escaping (Payload) -> Void){
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let data = data, error == nil else{
                print(error?.localizedDescription)
                return
            }
            var result: Payload?
            do{
                result = try JSONDecoder().decode(Payload.self, from: data)
            }catch{
                print(error.localizedDescription)
            }
            
            guard let json = result else{
                return
            }
            completion(json)
        }).resume()
    }
}

struct Payload: Codable{
    var payload: [Shop]?
}

struct Shop: Codable{
    let shop: [ShopDetail]
}

struct ShopDetail: Codable{
    let code: Int
    let shopName: String
    let Menus: [MenuDetail]
}

struct MenuDetail: Codable{
    let title: String
    let ind: String
    let price: Int
    let discPrice: Int
}

