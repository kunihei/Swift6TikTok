//
//  MusicModel.swift
//  Swift6TikTok
//
//  Created by 祥平 on 2021/01/26.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol MusicProtocol {
    func catchData(count:Int)
}

class MusicModel{
    
    //    var artistName:String?
    //    var tracCensoreName:String?
    //    var preViewUrl:String?
    //    var artworkUrl100:String?
    
    var artistNameArray = [String]()
    var tracCensoreNameArray = [String]()
    var preViewUrlArray = [String]()
    var artworkUrl100Array = [String]()
    var musicDelegate:MusicProtocol?
    
    func setData(resultCount:Int, encodeUrlString:String){
        
        AF.request(encodeUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            self.artistNameArray.removeAll()
            self.tracCensoreNameArray.removeAll()
            self.preViewUrlArray.removeAll()
            self.artworkUrl100Array.removeAll()
            
            print(response)
            
            switch response.result{
            case .success:
                
                do {
                    let json:JSON = try JSON(data: response.data!)
                    
                    for i in 0...resultCount - 1{
                        
                        if json["results"][i]["artistName"].string == nil{
                            print("ヒットしませんでした")
                            return
                        }
                        
                        self.artistNameArray.append(json["results"][i]["artistName"].string!)
                        self.tracCensoreNameArray.append(json["results"][i]["trackCensoredName"].string!)
                        self.preViewUrlArray.append(json["results"][i]["previewUrl"].string!)
                        self.artworkUrl100Array.append(json["results"][i]["artworkUrl100"].string!)
                        
                    }
                    
                    self.musicDelegate?.catchData(count: 1)
                    
                } catch  {
                    
                }
                
                break
                
            case .failure(_):
                break
            }
            
        }
        
    }
    
}
