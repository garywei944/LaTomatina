import Foundation
import QuartzCore
import SceneKit
import SpriteKit
import UIKit
func initializeBuildingData() {
    for _ in 1...12 {
        var array:[(Int,Float)] = []
        for _ in 1...12 {
            array.append((0,0))
        }
        buildingData.append(array)
    }
    for y in 0..<buildingData.count {
        for x in 0..<buildingData[y].count {
            assignBuildingDataUnit(x,y)
        }
    }
    buildingsCenterPosition = SCNVector3(x:0, y:0, z:0)
    buildingFocusPosition = SCNVector3(x:-20, y:0, z:-20)
}
func realizeBuildingFromData() {
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
            let mapNode = MapNodeClass()
            mapNode.type = number
            mapNode.position = destination
            mapNode.rotation = rotation
            mapNode.realizeRoughModel()
            mapNodes.append(mapNode)
            mapNode.setItemPositions()
        }
    }
    updateAndCheckBuildingData()
    updatePromotion()
}
func assignBuildingDataUnit(_ x:Int, _ y:Int) {
    var minX:Int = x-1
    var minY:Int = y-1
    var maxX:Int = x+1
    var maxY:Int = y+1
    if(minX < 0) {
        minX = 0
    }
    if(minY < 0) {
        minY = 0
    }
    if(maxX > buildingData[0].count-1) {
        maxX = buildingData[0].count-1
    }
    if(maxY > buildingData.count-1) {
        maxY = buildingData.count-1
    }
    var array:[Int] = [1,2,3,4,5]
    for yi in minY...maxY {
        for xi in minX...maxX {
            for i in 0..<array.count {
                var type:Int = 0
                (type, _) = buildingData[yi][xi]
                if(type == array[i]) {
                    array.remove(at: i)
                    break
                }
            }
        }
    }
    let number:Int = array[KEInt(array.count)]
    let rotation:Float = KEFloat(4)*Float.pi/2.0
    buildingData[y][x] = (number, rotation)
}
func updateAndCheckBuildingDataRenderer() {
    if let character = mainCharacter {
        let characterPosition = character.presentation.position
        var modelRealized:Bool = false
        var buildingRealized:Bool = false
        for node in mapNodes {
            for c in characters {
                if(abs(c.presentation.position.x - node.position.x) <= 40.0)&&(abs(c.presentation.position.z - node.position.z) <= 40.0) {
                    c.currentMapNodes.append(node)
                }
            }
            for i in 0..<node.itemPointers.count {
                if(node.itemPointers[i].state != 1) {
                    continue
                }
                if(calculate(characterPosition, node.itemPointers[i].position) < 1.5) {
                    node.itemPointers[i].obtain(character)
                    node.itemPointers.remove(at: i)
                    break
                }
                var found:Bool = false
                for c in characters {
                    if(calculate(c.presentation.position,
                                 node.itemPointers[i].position) < 1.5) {
                        node.itemPointers[i].obtain(c)
                        node.itemPointers.remove(at: i)
                        found = true
                        break
                    }
                }
                if(found == true) {
                    break
                }
            }
            if(buildingRealized == true)||(modelRealized == true) {
                continue
            }
            if(node.modelNeedToRealize == true)&&(modelRealized == false) {
                node.model.position = node.position
                node.model.eulerAngles.y = node.rotation
                node.modelNeedToRealize = false
                modelRealized = true
                return
            }
            if(buildingRealized == true)||(modelRealized == true) {
                continue
            }
            if let b = node.buildingWaitingToAppear {
                node.model.isHidden = true
                b.appear(node.position, node.rotation)
                node.buildingWaitingToAppear = nil
                buildingRealized = true
                return
            }
        }
        if(buildingRealized == true)||(modelRealized == true) {
            return
        }
        if(characterPosition.x - (buildingsCenterPosition.x-5) > 20) {
            buildingsCenterPosition.x += 40
            for y in 0..<buildingData.count {
                buildingData[y].remove(at: 0)
                buildingData[y].append((0,0))
                assignBuildingDataUnit(buildingData[y].count-1, y)
            }
            updateAndCheckBuildingData()
            return
        }
        if((buildingsCenterPosition.x-5) - characterPosition.x > 20) {
            buildingsCenterPosition.x -= 40
            for y in 0..<buildingData.count {
                buildingData[y].remove(at: buildingData[y].count-1)
                buildingData[y].insert((0,0), at: 0)
                assignBuildingDataUnit(0, y)
            }
            updateAndCheckBuildingData()
            return
        }
        if(characterPosition.z - (buildingsCenterPosition.z-5) > 20) {
            buildingsCenterPosition.z += 40
            buildingData.remove(at: 0)
            var element:[(Int,Float)] = []
            for _ in 0..<buildingData[0].count {
                element.append((0,0))
            }
            buildingData.append(element)
            for x in 0..<buildingData[buildingData.count-1].count {
                assignBuildingDataUnit(x, buildingData.count-1)
            }
            updateAndCheckBuildingData()
            return
        }
        if((buildingsCenterPosition.z-5) - characterPosition.z > 20) {
            buildingsCenterPosition.z -= 40
            buildingData.remove(at: buildingData.count-1)
            var element:[(Int,Float)] = []
            for _ in 0..<buildingData[0].count {
                element.append((0,0))
            }
            buildingData.insert(element, at: 0)
            for x in 0..<buildingData[buildingData.count-1].count {
                assignBuildingDataUnit(x, 0)
            }
            updateAndCheckBuildingData()
            return
        }
        var focusChanged:Bool = false
        if(characterPosition.x - buildingFocusPosition.x > 20) {
            buildingFocusPosition.x += 40
            focusChanged = true
        }
        if(buildingFocusPosition.x - characterPosition.x > 20) {
            buildingFocusPosition.x -= 40
            focusChanged = true
        }
        if(characterPosition.z - buildingFocusPosition.z > 20) {
            buildingFocusPosition.z += 40
            focusChanged = true
        }
        if(buildingFocusPosition.z - characterPosition.z > 20) {
            buildingFocusPosition.z -= 40
            focusChanged = true
        }
        if(focusChanged == true) {
            updatePromotion()
            return
        }
        updateItemAtIndex()
    }
}
