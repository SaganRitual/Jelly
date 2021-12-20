// We are a way for the cosmos to know itself. -- C. Sagan

import SwiftUI

struct TumblerStrokeView: View {
    @ObservedObject var tumbler: Tumbler
    @ObservedObject var vertexor: Vertexor

    let rect: CGRect
//    let frameSize: CGSize
//
    func vertex(_ index: Int) -> CGPoint {
        vertexor.theVertices[index]
    }

    func path() -> Path {
        switch vertexor.shapeClass {
        case .ellipse(0): return pathEllipse()
        case .ellipse(1): return pathCapsule()
        case .ngon(0):    return pathLine()
        case .ngon:       return pathNgon()
        default:          fatalError()
        }
    }

    func pathCapsule() -> Path {
        let translate = CGPoint(x: rect.midX, y: rect.midY)

        var path = Path()

        path.move(to: vertex(0) * rect.size.radius + translate)

        if vertex(0) != CGPoint(x: 1.0, y: 0.0) {
            path.addLine(to: vertex(0) * CGPoint.yFlip * rect.size.radius + translate)
        }

        path.addArc(
            center: (CGPoint.zero * rect.size.radius) + translate,
            radius: rect.size.radius,
            startAngle: .radians(-vertex(0).theta), endAngle: .radians(-(.pi - vertex(0).theta)), clockwise: false
        )

        if vertex(0) != CGPoint(x: 1.0, y: 0.0) {
            path.addLine(to: vertex(0) * CGPoint.xFlip * rect.size.radius + translate)
        }

        path.addArc(
            center: (CGPoint.zero * rect.size.radius) + translate,
            radius: rect.size.radius,
            startAngle: .radians(-vertex(0).theta) + .radians(.pi), endAngle: .radians(-(.pi - vertex(0).theta)) + .radians(.pi), clockwise: false
        )

        return path // Don't draw the pen axis yet; want to work on tumbling first
    }

    func pathEllipse() -> Path {
        var path = Path()

        path.addEllipse(in: rect)

        return path// pathPenAxis(path: &path)
    }

    func pathLine() -> Path {
        let translate = CGPoint(x: rect.midX, y: rect.midY)

        var path = Path()

        path.move(to: CGPoint(radius: 1, theta: .tau / 4) * rect.size.radius + translate)
        path.addLine(to: CGPoint(radius: 1, theta: -.tau / 4) * rect.size.radius + translate)

        return path
    }

    func pathNgon() -> Path {
        let translate = CGPoint(x: rect.midX, y: rect.midY)

        var path = Path()

        path.move(to: vertex(0) * rect.size.radius + translate)

        (1..<vertexor.theVertices.count).forEach {
            path.addLine(to: vertex($0) * rect.size.radius + translate)
        }

        path.addLine(to: vertex(0) * rect.size.radius + translate)

        return path // Don't draw the pen axis yet; want to work on tumbling first
//        return pathPenAxis(path: &path)
    }
//
//    func pathPenAxis(path: inout Path) -> Path {
//        let translate = CGPoint(x: rect.midX, y: rect.midY)
//        let rotationalCenterNormal = tumblerModel.rotationalCenter.asPoint()
//
//        let penTrackTerminusNormal: CGPoint
//        if rotationalCenterNormal == .zero {
//            penTrackTerminusNormal = CGPoint(x: 1.0, y: 0.0)
//        } else {
//            penTrackTerminusNormal = CGPoint(
//                radius: 1.0, theta: .tau / 2.0 - rotationalCenterNormal.theta
//            )
//        }
//
//        let rotationalCenter =
//            (rotationalCenterNormal * frameSize.asPoint() * 2.0) + translate.asPoint()
//
//        let penTrackTerminus =
//            (penTrackTerminusNormal.asSize() * frameSize + translate.asSize()).asPoint()
//
//        path.move(to: rotationalCenter)
//        path.addLine(to: penTrackTerminus)
//
//        return path
//    }

    var body: some View {
        path().stroke(Color.shizzabrick, lineWidth: 2.0)
    }
}
