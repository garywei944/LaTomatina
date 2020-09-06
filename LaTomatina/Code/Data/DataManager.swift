import Foundation
import SpriteKit
var player = playerData()
func read() {
    let iCloudData = iCloudReadData()
    let localData = readDataLocally()
    if(iCloudData != nil)&&(localData != nil) {
        if(localData!.saveTime > iCloudData!.saveTime) {
            player = localData!
            iCloudWriteData()
        }else{
            player = iCloudData!
            writeDataLocally()
        }
    }
    if(localData != nil) {
        player = localData!
        iCloudWriteData()
    }
}
func write() {
    let date = Date()
    let timeInterval = date.timeIntervalSince1970
    let dateInt = Int(timeInterval)
    player.saveTime = dateInt
    iCloudWriteData()
    writeDataLocally()
}
func iCloudReadData()->(playerData?) {
    if(NSUbiquitousKeyValueStore.default.object(forKey: "playerData") != nil) {
        let something1 = NSUbiquitousKeyValueStore.default.object(forKey: "playerData") as? Data
        if let something2 = something1 {
            do {
                let data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(something2)! as! playerData
                return(data)
            }catch{
            }
        }
    }
    return(nil)
}
func iCloudWriteData() {
    do {
        let something1 = try NSKeyedArchiver.archivedData(withRootObject: player, requiringSecureCoding: false)
        NSUbiquitousKeyValueStore.default.set(something1, forKey: "playerData")
    }catch{
    }
}
func readDataLocally()->(playerData?) {
    if(UserDefaults.standard.object(forKey: "playerData") != nil) {
        let something1 = UserDefaults.standard.object(forKey: "playerData") as? Data
        if let something2 = something1 {
            do {
                let data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(something2)! as! playerData
                return(data)
            }catch{
            }
        }
    }
    return(nil)
}
func writeDataLocally() {
    do {
        let something1 = try NSKeyedArchiver.archivedData(withRootObject: player, requiringSecureCoding: false)
        UserDefaults.standard.set(something1, forKey: "playerData")
    }catch{
    }
}
class playerData: NSObject,NSCoding {
    var saveTime:Int = 0
    var name:String = "--"
    var needUpdateName:Bool = false
    var character:[Int] = []
    // sex: 0 = male | face | hair | top | bottom | skin
    let sensitivity:Float = 1
    var ant:Bool = true
    var lit:Bool = true
    var son:Bool = true
    var spa:Bool = true
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(character, forKey: "character")
        aCoder.encode(ant, forKey: "ant")
        aCoder.encode(lit, forKey: "lit")
        aCoder.encode(son, forKey: "son")
        aCoder.encode(spa, forKey: "spa")
    }
    override init() {
    }
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.character = aDecoder.decodeObject(forKey: "character") as! [Int]
        self.ant = aDecoder.decodeBool(forKey: "ant")
        self.lit = aDecoder.decodeBool(forKey: "lit")
        self.son = aDecoder.decodeBool(forKey: "son")
        self.spa = aDecoder.decodeBool(forKey: "spa")
    }
}
