import Foundation

enum PositionKeys: String, CodingKey {
    case xPos = "x"
    case yPos = "y"
}

class Position: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true

    let xPos: Double
    let yPos: Double

    init(xPos: Double, yPos: Double) {
        self.xPos = xPos
        self.yPos = yPos
    }

    required convenience init?(coder: NSCoder) {
        let xPos = coder.decodeDouble(forKey: PositionKeys.xPos.rawValue)
        let yPos = coder.decodeDouble(forKey: PositionKeys.yPos.rawValue)

        self.init(xPos: xPos, yPos: yPos)
    }

    func encode(with coder: NSCoder) {
        coder.encode(xPos, forKey: PositionKeys.xPos.rawValue)
        coder.encode(yPos, forKey: PositionKeys.yPos.rawValue)
    }
}
