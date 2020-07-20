import Proj
import Foundation

public enum ProjError: Error {
    case InitFailed
}


// Based on https://github.com/fangpenlin/Proj4Swift/blob/master/Proj4/Projection.swift but changed for latest proj
public class Projection {
    public let parameters: String
    
    private let proj: OpaquePointer?
    private let ctx: OpaquePointer
    
    public init(parameters: String) throws {
        self.parameters = parameters
        ctx = proj_context_create()
        proj = proj_create(ctx, parameters)
        if proj == nil {
            throw ProjError.InitFailed
        }
    }
    
    deinit {
        proj_context_destroy(ctx)
    }
    
    // Transforms between coordinate systems based on a pair of projections
    public func transform(_ coord: Point3D, toProjection projection: Projection) -> Point3D {
        let area = proj_area_create()
        proj_area_set_bbox(area, -180, -90, 180, 90)
        let transformCtx = proj_context_create()
        let crsTransform = proj_create_crs_to_crs(ctx, parameters, projection.parameters, area)
        
        let projectedCoord = proj_trans(crsTransform,
                                        PJ_FWD,
                                        PJ_COORD(xyz: PJ_XYZ(x: coord.x,
                                                             y: coord.y,
                                                             z: coord.z)))
        
        
        proj_context_destroy(transformCtx)
        proj_destroy(crsTransform)
        proj_area_destroy(area)
        
        return Point3D(pjXYZ: projectedCoord.xyz)
    }
        
}


public struct Point3D {
    public let x: Double
    public let y: Double
    public let z: Double
    
    public init(pjXYZ: PJ_XYZ) {
        self.x = pjXYZ.x
        self.y = pjXYZ.y
        self.z = pjXYZ.z
    }
    
    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public func toList() -> [Double] {
        return [x, y, z]
    }
}
