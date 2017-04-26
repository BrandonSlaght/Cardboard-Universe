//
//  GameControllerSwift.swift
//  VRBoilerplate
//
//  Created by Andrian Budantsov on 5/21/16.
//  Copyright © 2016 Andrian Budantsov. All rights reserved.
//

import Foundation
import SceneKit;

@objc(VRControllerSwift)
class VRControllerSwift : NSObject, VRControllerProtocol {
    
    let scene = SCNScene()
    
    let Mercury = Planet(texture: "mercurymap.jpg",
                         model: nil,
                         normalmap: nil,
                         ringmap: nil,
                         ring_transparencymap: nil,
                         ring_inner_ratio: nil,
                         ring_outer_ratio: nil,
                         day_length: nil,
                         equator_tilt: nil)
    
    let Venus = Planet(texture: "venusmap.jpg",
                       model: nil,
                       normalmap: "venusnormalmap.jpg",
                       ringmap: nil,
                       ring_transparencymap: nil,
                       ring_inner_ratio: nil,
                       ring_outer_ratio: nil,
                       day_length: nil,
                       equator_tilt: nil)
    
    let Earth = Planet(texture: "earthmap.jpg",
                       model: nil,
                       normalmap: "earthnormalmap.jpg",
                       ringmap: nil,
                       ring_transparencymap: nil,
                       ring_inner_ratio: nil,
                       ring_outer_ratio: nil,
                       day_length: 24,
                       equator_tilt: 23.44)
    
    let Mars = Planet(texture: "marsmap.jpg",
                      model: nil,
                      normalmap: "marsnormalmap.jpg",
                      ringmap: nil,
                      ring_transparencymap: nil,
                      ring_inner_ratio: nil,
                      ring_outer_ratio: nil,
                      day_length: 24.6597,
                      equator_tilt: 25.19)
    
    let Jupiter = Planet(texture: "jupitermap.jpg",
                         model: nil,
                         normalmap: nil,
                         ringmap: nil,
                         ring_transparencymap: nil,
                         ring_inner_ratio: 1.72,
                         ring_outer_ratio: 3.92,
                         day_length: 9.9259,
                         equator_tilt: 3.13)
    
    let Saturn = Planet(texture: "saturnmap.jpg",
                        model: nil,
                        normalmap: nil,
                        ringmap: "saturnrings.jpg",
                        ring_transparencymap: "saturnringtransparency.jpg",
                        ring_inner_ratio: 1.239,
                        ring_outer_ratio: 2.270,
                        day_length: 10.656,
                        equator_tilt: 26.73)
    
    let Uranus = Planet(texture: "uranusmap.jpg",
                        model: nil,
                        normalmap: nil,
                        ringmap: "uranusrings.png",
                        ring_transparencymap: "uranusringtransparency.png",
                        ring_inner_ratio: 1.750,
                        ring_outer_ratio: 2.006,
                        day_length: 17.24,
                        equator_tilt: 82.23)
    
    let Neptune = Planet(texture: "neptunemap.jpg",
                         model: nil,
                         normalmap: nil,
                         ringmap: nil,
                         ring_transparencymap: nil,
                         ring_inner_ratio: nil,
                         ring_outer_ratio: nil,
                         day_length: 16.11,
                         equator_tilt: 28.32)
    
    var planets = [Planet]()
    var index = 0
    var indexChanged = false
    var planetNode: SCNNode
    
    // MARK: Game Controller
    
    required override init() {
        
        planets.append(Mercury)
        planets.append(Venus)
        planets.append(Earth)
        planets.append(Mars)
        planets.append(Jupiter)
        planets.append(Saturn)
        planets.append(Uranus)
        planets.append(Neptune)
        
        let current = planets[index]
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.11, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        let planet = SCNSphere(radius: 1.0)
        planet.segmentCount = 80
        
        if let let_texture = current.texture {
            
            let material = SCNMaterial()
                material.diffuse.contents = UIImage(named: let_texture)!
            material.diffuse.mipFilter = SCNFilterMode.linear

            if let let_normalmap = current.normalmap {
                material.normal.contents = UIImage(named: let_normalmap)!
            }

            planet.materials = [material]
            let planetNode = SCNNode(geometry: planet)
            planetNode.name = "planet"
            planetNode.position = SCNVector3(0, 0, -2)
            planetNode.isHidden = true
            self.planetNode = planetNode

            let rotationNode = SCNNode()
            rotationNode.addChildNode(planetNode)
            scene.rootNode.addChildNode(rotationNode)
            
//            let spin = CABasicAnimation(keyPath: "rotation")
//            spin.fromValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: 0))
//            spin.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float(2 * Double.pi)))
//            
//            if let let_day_length = current.day_length {
//                spin.duration = let_day_length*60*60/24
//            } else {
//                spin.duration = 60
//            }
//            
//            spin.repeatCount = .infinity
//            
//            planetNode.addAnimation(spin, forKey: "spin around")
            
            if let let_ringsmap = current.ringmap {
                let rings = SCNTorus(ringRadius: 2, pipeRadius: 0.5)
                //print("here")
                
                if let let_ring_inner_ratio = current.ring_inner_ratio, let let_ring_outer_ratio = current.ring_outer_ratio {
                    //print("hereeeeee")
                    rings.pipeRadius = CGFloat((let_ring_outer_ratio - let_ring_inner_ratio) / 2)
                    rings.ringRadius = CGFloat(let_ring_outer_ratio - 0.5) //+ let_ring_inner_ratio) / 2) //CGFloat(let_ring_outer_ratio / )
                }
                
                rings.ringSegmentCount = 176
                
                let material = SCNMaterial()
                material.isDoubleSided = true
                material.diffuse.contents = UIImage(named: let_ringsmap)!
                material.diffuse.mipFilter = SCNFilterMode.linear
                material.diffuse.wrapT = SCNWrapMode.repeat
                material.transparencyMode = .rgbZero
                
                if let let_ring_transparencymap = current.ring_transparencymap {
                    material.transparent.contents = UIImage(named: let_ring_transparencymap)!
                    material.transparent.mipFilter = SCNFilterMode.linear
                    material.transparent.wrapT = SCNWrapMode.repeat
                }
                
                rings.materials = [material]
                
                let ringNode = SCNNode(geometry: rings)
                
                ringNode.scale = SCNVector3(x: 1, y: 0.01, z: 1)
                
                planetNode.addChildNode(ringNode)
                
            }
            
            if let let_equator_inclination = current.equator_tilt {
            
                if current.ringmap != nil {
                    //rotationNode.rotation = SCNVector4(x: 0.5, y: 0, z: 1, w: Float(let_equator_inclination * (Double.pi / 180.0)))
                } else {
                    //rotationNode.rotation = SCNVector4(x: 0, y: 0, z: 1, w: Float(let_equator_inclination * (Double.pi/180.0)))
                }
            }
        } else {
            self.planetNode = SCNNode(geometry: SCNSphere(radius: 1.0))
        }
        
        let skyBox = SCNSphere(radius: 15)
        skyBox.segmentCount = 80
        
        let sky = SCNMaterial()
        sky.diffuse.contents = UIImage(named: "sky.jpg")!
        sky.diffuse.mipFilter = SCNFilterMode.linear
        sky.isDoubleSided = true
        
        skyBox.materials = [sky]
        let skyNode = SCNNode(geometry: skyBox)
        skyNode.name = "skyBox"
        skyNode.position = SCNVector3(0, 0, 0)
        scene.rootNode.addChildNode(skyNode)
        
        //scene.background.contents = UIImage(named: "sky.jpg")
        
//        scene.background.contents = UIColor.lightGray
//        
//        for i in -3 ..< 13 {
//            for j in 7 ..< 12 {
//                let boxNode: SCNNode = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
//                boxNode.geometry?.materials = [greyMaterial]
//                boxNode.position = SCNVector3((Double(i) - 5.0) * 1.2, (Double(j) - 5.0) * 1.2, -10)
//                boxNode.physicsBody = SCNPhysicsBody.static()
//                boxes.addChildNode(boxNode)
//            }
//        }
//        
//        world.addChildNode(boxes)
//        
//        
//        let floor = SCNFloor()
//        floor.reflectivity = 0; // does not work in Cardboard SDK
//        let floorNode = SCNNode.init(geometry: floor)
//        floorNode.position = SCNVector3(0, -20, 0);
//        world.addChildNode(floorNode);
//        
//        
//        let backSphere = SCNNode.init(geometry: SCNSphere.init(radius: 120))
//        backSphere.position = SCNVector3(0, 0, 180)
//        world.addChildNode(backSphere)
//        
//        
//        let light = SCNLight()
//        let lightNode = SCNNode()
//        lightNode.light = light
//        lightNode.position = SCNVector3(2,2,2)
//        world.addChildNode(lightNode)
//        
//        cursor.geometry = SCNSphere(radius: 0.2)
//        cursor.physicsBody = nil
//        
//        scene.rootNode.addChildNode(cursor)
//        scene.rootNode.addChildNode(world)
    }
    
    func prepareFrame(with headTransform: GVRHeadTransform) {
        
        planetNode.position = headTransform.rotateVector(SCNVector3(0, -2/3, -2))
        print(headTransform.rotateVector(SCNVector3(1, 0, 0)))
        
        if !indexChanged {
            print("false")
            planetNode.isHidden = false
            return
        } else {
            print("true")
            indexChanged = false
        }
        
        scene.rootNode.enumerateChildNodes { (node, stop) -> Void in
            node.removeFromParentNode()
        }
        
        let current = planets[index]
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor(white: 0.11, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLightNode)
        
        let planet = SCNSphere(radius: 1.0)
        planet.segmentCount = 80
        
        if let let_texture = current.texture {
            
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(named: let_texture)!
            material.diffuse.mipFilter = SCNFilterMode.linear
            
            if let let_normalmap = current.normalmap {
                material.normal.contents = UIImage(named: let_normalmap)!
            }
            
            planet.materials = [material]
            let planetNode = SCNNode(geometry: planet)
            planetNode.name = "planet"
            planetNode.position = SCNVector3(0, 0, -2)
            planetNode.isHidden = true
            self.planetNode = planetNode
            
            let rotationNode = SCNNode()
            rotationNode.addChildNode(planetNode)
            scene.rootNode.addChildNode(rotationNode)
            
//            let spin = CABasicAnimation(keyPath: "rotation")
//            spin.fromValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: 0))
//            spin.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: Float(2 * Double.pi)))
//            
//            if let let_day_length = current.day_length {
//                spin.duration = let_day_length*60*60/24
//            } else {
//                spin.duration = 60
//            }
//            
//            spin.repeatCount = .infinity
//            
//            planetNode.addAnimation(spin, forKey: "spin around")
            
            if let let_ringsmap = current.ringmap {
                let rings = SCNTorus(ringRadius: 2, pipeRadius: 0.5)
                //print("here")
                
                if let let_ring_inner_ratio = current.ring_inner_ratio, let let_ring_outer_ratio = current.ring_outer_ratio {
                    //print("hereeeeee")
                    rings.pipeRadius = CGFloat((let_ring_outer_ratio - let_ring_inner_ratio) / 2)
                    rings.ringRadius = CGFloat(let_ring_outer_ratio - 0.5) //+ let_ring_inner_ratio) / 2) //CGFloat(let_ring_outer_ratio / )
                }
                
                rings.ringSegmentCount = 176
                
                let material = SCNMaterial()
                material.isDoubleSided = true
                material.diffuse.contents = UIImage(named: let_ringsmap)!
                material.diffuse.mipFilter = SCNFilterMode.linear
                material.diffuse.wrapT = SCNWrapMode.repeat
                material.transparencyMode = .rgbZero
                
                if let let_ring_transparencymap = current.ring_transparencymap {
                    material.transparent.contents = UIImage(named: let_ring_transparencymap)!
                    material.transparent.mipFilter = SCNFilterMode.linear
                    material.transparent.wrapT = SCNWrapMode.repeat
                }
                
                rings.materials = [material]
                
                let ringNode = SCNNode(geometry: rings)
                
                ringNode.scale = SCNVector3(x: 1, y: 0.01, z: 1)
                
                planetNode.addChildNode(ringNode)
                
            }
            
            if let let_equator_inclination = current.equator_tilt {
                
                if current.ringmap != nil {
                    //rotationNode.rotation = SCNVector4(x: 0.5, y: 0, z: 1, w: Float(let_equator_inclination * (Double.pi / 180.0)))
                } else {
                    //rotationNode.rotation = SCNVector4(x: 0, y: 0, z: 1, w: Float(let_equator_inclination * (Double.pi/180.0)))
                }
            }
        }
        
        let skyBox = SCNSphere(radius: 15)
        skyBox.segmentCount = 80
        
        let sky = SCNMaterial()
        sky.diffuse.contents = UIImage(named: "sky.jpg")!
        sky.diffuse.mipFilter = SCNFilterMode.linear
        sky.isDoubleSided = true
        
        skyBox.materials = [sky]
        let skyNode = SCNNode(geometry: skyBox)
        skyNode.name = "skyBox"
        skyNode.position = SCNVector3(0, 0, 0)
        scene.rootNode.addChildNode(skyNode)

//
//        // let's create long ray (100 meters) that goes the same way 
//        // cursor.position is directed 
//        
//        let p2 =
//            SCNVector3FromGLKVector3(
//                GLKVector3MultiplyScalar(
//                    GLKVector3Normalize(
//                        SCNVector3ToGLKVector3(cursor.position)
//                    ),
//                    100
//                )
//            );
//        
//        let hits = boxes.hitTestWithSegment(from: SCNVector3Zero, to: p2, options: [SCNHitTestOption.firstFoundOnly.rawValue: true]);
//        
//        if let hit = hits.first {
//            focusedNode = hit.node;
//        }
//        else {
//            focusedNode = nil;
//        }
//        
//        boxes.enumerateChildNodes { (node, end) in
//            node.geometry?.materials = [self.greyMaterial];
//        };
//        
//        focusedNode?.geometry?.materials = [purpleMaterial];
    }
    
    func eventTriggered() {
        //focusedNode?.removeFromParentNode();
        index = index + 1
        index = index%8
        indexChanged = true
        print("here");
    }
    
}


