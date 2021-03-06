//
//  Dielectric.swift
//  SwiftRay
//
//  Created by Renaud Pradenc on 24/11/2016.
//  Copyright © 2016 Céroce. All rights reserved.
//

import Darwin   // For maths

enum RefractionIndex: Float {
    case Void = 1.0
    case Air = 1.000_272
    case Water = 1.333
    case Cornea = 1.38
    case CrownGlass = 1.52
    case Cristal = 1.524
    case Amber = 1.55
    case Glass = 1.57
    case FlintGlass = 1.62
    case Diamond = 2.42
}

struct Dielectric: Material {
    let refractionIndex: Float
    
    func scatteredRay(ray: Ray, intersection: HitIntersection) -> (Ray, Vec3)? {
        let attenuation = Vec3(1.0) // No attenuation
        
        var outwardNormal: Vec3
        var niOverNt: Float
        var cosine: Float
        if dot(ray.direction, intersection.normal) > 0 {
            outwardNormal = -1.0 * intersection.normal
            niOverNt = refractionIndex
            cosine = refractionIndex * dot(ray.direction, intersection.normal) / length(ray.direction)
        } else {
            outwardNormal = intersection.normal
            niOverNt = RefractionIndex.Air.rawValue/refractionIndex
            cosine = -dot(ray.direction, intersection.normal) / length(ray.direction)
        }
    
        let reflected = reflect(v: ray.direction, normal: intersection.normal)
        if let refracted = refract(v: ray.direction, normal: outwardNormal, niOverNt: niOverNt) {
            let reflectProb = schlick(cosine: cosine, refrIndex: refractionIndex)
            if random01() < reflectProb {
                return (Ray(origin: intersection.position, direction: reflected, time: ray.time), attenuation)
            } else {
                return (Ray(origin: intersection.position, direction: refracted, time: ray.time), attenuation)
            }
        } else {
            return (Ray(origin: intersection.position, direction: reflected, time: ray.time), attenuation)
        }
    }
    
    private func reflect(v: Vec3, normal: Vec3) -> Vec3 {
        return v - 2.0 * dot(v, normal) * normal
    }
    
    // Simulate that the reflectivity varies with angle
    private func schlick(cosine: Float, refrIndex: Float) -> Float {
        let r = (1-refrIndex) / (1+refrIndex)
        let r2 = r * r
        return r2 + (1-r2)*powf((1-cosine), 5.0)
    }
    
    private func refract(v: Vec3, normal: Vec3, niOverNt: Float) -> Vec3? {
        let v1 = normalize(v)
        let dt = dot(v1, normal)
        let discr = 1 - niOverNt*niOverNt*(1-dt*dt)
        if discr > 0 {
            return niOverNt*(v1 - normal*dt) - normal*sqrtf(discr)
        } else {
            return nil
        }
    }
}
