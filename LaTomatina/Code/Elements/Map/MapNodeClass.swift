import Foundation
import QuartzCore
import SceneKit
import SpriteKit
import UIKit
var buildingData:[[(Int,Float)]] = []
var buildingsCenterPosition = SCNVector3()
var buildingFocusPosition = SCNVector3()
var mapNodes:[MapNodeClass] = []
var roughBuildingModels:[[SCNNode]] = []
var roughBuildingModelsUsing:[SCNNode] = []
class MapNodeClass {
    var modelNeedToRealize:Bool = false
    var model = SCNNode()
    var type:Int = -1
    var position = SCNVector3()
    var rotation:Float = 0
    var currentBuildingObject:BuildingClass?
    var buildingWaitingToAppear:BuildingClass?
    var wantToPromote:Bool = false
    var itemPositions:[SCNVector3] = []
    var itemPointers:[ItemClass] = []
    func setItemPositions() {
        itemPositions.removeAll()
        for i in itemPointers {
            i.hide()
        }
        itemPointers.removeAll()
        for x in (-6)...(6) {
            for y in (-6)...(6) {
                var location = self.position
                location.y = 0
                location.x += Float(x)*2
                location.z += Float(y)*2
                if(abs(location.x-self.position.x)<11)&&(abs(location.z-self.position.z)<11) {
                    continue
                }
                itemPositions.append(location)
            }
        }
    }
    func realizeRoughModel() {
        for m in roughBuildingModels[type-1] {
            var isUsing:Bool = false
            for modelUsing in roughBuildingModelsUsing {
                if(m == modelUsing) {
                    isUsing = true
                    break
                }
            }
            if(isUsing == false) {
                self.model = m
                self.modelNeedToRealize = true
                roughBuildingModelsUsing.append(self.model)
                break
            }
        }
    }
    func clear() {
        modelNeedToRealize = false
        self.position.x = Float(Int(self.position.x))
        self.position.y = 0
        self.position.z = Float(Int(self.position.z))
        setItemPositions()
        type = -1
        if let b = self.currentBuildingObject {
            b.disappear()
            self.currentBuildingObject = nil
        }
        for i in 0..<roughBuildingModelsUsing.count {
            if(model == roughBuildingModelsUsing[i]) {
                roughBuildingModelsUsing[i].isHidden = false
                roughBuildingModelsUsing[i].position.y = -200
                roughBuildingModelsUsing.remove(at: i)
                break
            }
        }
    }
    func existenceCheck()->(Bool) {
        if let building = currentBuildingObject {
            if(isPositionEqualII(building.targetNode.position,
                                 self.position) == true)&&(building.type == self.type)&&(building.showing == true) {
                building.isUsing = true
                return(true)
            }
        }
        return(false)
    }
    func firstPromotion()->(Bool) {
        for b in buildings {
            if(b.type == self.type)&&(b.isUsing == false) {
                for p in b.positions {
                    if(isPositionEqualII(p, self.position) == true) {
                        self.currentBuildingObject = b
                        b.isUsing = true
                        buildingWaitingToAppear = b
                        return(true)
                    }
                }
            }
        }
        return(false)
    }
    func secondPromotion() {
        for b in buildings {
            if(b.type == self.type)&&(b.isUsing == false) {
                self.currentBuildingObject = b
                b.isUsing = true
                buildingWaitingToAppear = b
                return
            }
        }
    }
    func unpromote() {
        self.model.isHidden = false
        if let _ = self.buildingWaitingToAppear {
            self.buildingWaitingToAppear = nil
        }
        if let b = self.currentBuildingObject {
            b.disappear()
            self.currentBuildingObject = nil
        }
    }
}
func updateAndCheckBuildingData() {
    for node in mapNodes {
        if(node.position.x - buildingsCenterPosition.x > 100) {
            node.position.x -= 240
            node.clear()
        }else if(buildingsCenterPosition.x - node.position.x > 100) {
            node.position.x += 240
            node.clear()
        }
        if(node.position.z - buildingsCenterPosition.z > 100) {
            node.position.z -= 240
            node.clear()
        }else if(buildingsCenterPosition.z - node.position.z > 100) {
            node.position.z += 240
            node.clear()
        }
    }
    for y in 3...8 {
        for x in 3...8 {
            var number:Int = 0
            var rotation:Float = 0
            (number, rotation) = buildingData[y][x]
            var destination = buildingsCenterPosition
            destination.x -= 100
            destination.x += Float(x-3)*40
            destination.z -= 100
            destination.z += Float(y-3)*40
            for node in mapNodes {
                if(isPositionEqualII(node.position,
                                     destination) == true){
                    if(node.type == number) {
                        break
                    }
                    node.type = number
                    node.position = destination
                    node.rotation = rotation
                    node.realizeRoughModel()
                }
            }
        }
    }
}
func updatePromotion() {
    var promotingList:[MapNodeClass] = []
    for node in mapNodes {
        if(abs(node.position.x - buildingFocusPosition.x) < 50)&&(abs(node.position.z - buildingFocusPosition.z) < 50) {
            promotingList.append(node)
        }else{
            node.unpromote()
        }
    }
    for b in buildings {
        b.isUsing = false
    }
    var i:Int = 0
    while(i < promotingList.count) {
        if(promotingList[i].existenceCheck() == false) {
            i += 1
        }else{
            promotingList.remove(at: i)
        }
    }
    i = 0
    while(i < promotingList.count) {
        if(promotingList[i].firstPromotion() == false) {
            i += 1
        }else{
            promotingList.remove(at: i)
        }
    }
    for n in promotingList {
        n.secondPromotion()
    }
}





