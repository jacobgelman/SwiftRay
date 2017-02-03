//
//  SphereArrayScene.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 02/02/2017.
//  Copyright © 2017 Céroce. All rights reserved.
//

struct SphereArrayScene {
    let camera: Camera
    let hitables: [Hitable]
    
    init(aspectRatio: Float) {
        let startTime: Float = 0.0
        let endTime: Float = 1.0
        self.camera = Camera(lookFrom: Vec3(15, 5, 12), lookAt: Vec3(0, 0, 0), up: Vec3(0, 1, 0), yFov: 20, aspectRatio: aspectRatio, aperture: 0.1, focusDistance: length(Vec3(15, 5, 12)), startTime: startTime, endTime: endTime)
        
        var mutHitables: [Hitable] = []
        
        let mini = -2
        let maxi = 2
        
        for z in mini...maxi {
            for y in mini...maxi {
                for x in mini...maxi {
                    let center = Vec3(Float(x), Float(y), Float(z))
                    mutHitables.append(Sphere(center: center, radius: 0.2, material: Lambertian(albedo: Vec3(random01(), random01(), random01()) )))
                }
            }
        }
        
        let boundingNode = BoundingNode(hitables: mutHitables, startTime: startTime, endTime: endTime)
        let bounds = boundingNode.boundingBox
        
        let redRect = XZRectangle(x0: bounds.minPoint.x, x1: bounds.maxPoint.x, z0: bounds.minPoint.z, z1: bounds.maxPoint.z, k: bounds.minPoint.y, material: Lambertian(albedo: Vec3(1, 0, 0)))
        
        let blueRect = XYRectangle(x0: bounds.minPoint.x, x1: bounds.maxPoint.x, y0: bounds.minPoint.y, y1: bounds.maxPoint.y, k: bounds.minPoint.z, material: Lambertian(albedo: Vec3(0, 0, 1)))
        
        mutHitables.append(redRect)
        mutHitables.append(blueRect)
        let node2 = BoundingNode(hitables: mutHitables, startTime: startTime, endTime: endTime)
        hitables = [node2]
 
        

 /*       var objects: [Hitable] = []
        objects.append(contentsOf: spheres)
        
        let boundingNode = BoundingNode(hitables: spheres, startTime: startTime, endTime: endTime)
        let bounds = boundingNode.boundingBox
        objects.append(boundingNode)
        
        let redRect = XZRectangle(x0: bounds.minPoint.x, x1: bounds.maxPoint.x, z0: bounds.minPoint.z, z1: bounds.maxPoint.z, k: bounds.minPoint.y, material: Lambertian(albedo: Vec3(1, 0, 0)))
        objects.append(redRect)
        
        let blueRect = XYRectangle(x0: bounds.minPoint.x, x1: bounds.maxPoint.x, y0: bounds.minPoint.y, y1: bounds.maxPoint.y, k: bounds.minPoint.z, material: Lambertian(albedo: Vec3(0, 0, 1)))
        objects.append(blueRect)
        
        hitables = objects
*/
    }
}
