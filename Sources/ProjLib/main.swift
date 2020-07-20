let DEG_TO_RAD = Double.pi / 180
fileprivate let WGS84_EPSG_CODE : Int32 = 4326
fileprivate let UTM_ZONE_1N_CODE : Int32 = 32601 // = WGS 84 / UTM zone 1N //16001 = UTM Zone 1N
fileprivate let UTM_ZONE_1S_CODE : Int32 = 32701 // = WGS 84 / UTM zone 1S //16101 = UTM Zone 1S

let projWGS84 = try! Projection(parameters: "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
let projUTM = try! Projection(parameters: "+proj=utm +zone=1 +south +ellps=WGS84 +datum=WGS84 +units=m +no_defs")

let point =
    Point3D(
        x: Double(-122),
        y: Double(37),
        z: 0
    )

let resultPoints = projWGS84.transform(point, toProjection: projUTM)
print(resultPoints)


extension Double {
    func degreeToRad() -> Double{
        self * Double.pi / 180
    }
}
