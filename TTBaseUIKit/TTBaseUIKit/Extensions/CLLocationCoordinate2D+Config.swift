//
//  CLLocationCoordinate2D+Config.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 2/18/21.
//  Copyright © 2021 Truong Quang Tuan. All rights reserved.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {

    public func shift(byTimeRequest time:Double, speed:Double, heading: Double) -> CLLocationCoordinate2D {
        let distanceMeters = time * (speed * 1000/7200)
        return self.locationWithBearing(bearing: heading, distanceMeters: distanceMeters, origin: self)
    }
    
    /// Get coordinate moved from current to `distanceMeters` meters with azimuth `azimuth` [0, Double.pi)
    ///
    /// - Parameters:
    ///   - distanceMeters: the distance in meters
    ///   - azimuth: the azimuth (bearing)
    /// - Returns: new coordinate
    public func shift(byDistance distanceMeters: Double, azimuth: Double) -> CLLocationCoordinate2D {
        let bearing = azimuth
        let origin = self
        let distRadians = distanceMeters / (6372797.6) // earth radius in meters

        let lat1 = origin.latitude * Double.pi / 180
        let lon1 = origin.longitude * Double.pi / 180

        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        return CLLocationCoordinate2D(latitude: lat2 * 180 / Double.pi, longitude: lon2 * 180 / Double.pi)
    }
    
    
    public func locationWithBearing(bearing:Double, distanceMeters:Double, origin:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let distRadians = distanceMeters / (6372797.6)

        let rbearing = bearing * Double.pi / 180.0

        let lat1 = origin.latitude * Double.pi / 180
        let lon1 = origin.longitude * Double.pi / 180

        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(rbearing))
        let lon2 = lon1 + atan2(sin(rbearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))

        return CLLocationCoordinate2D(latitude: lat2 * 180 / Double.pi, longitude: lon2 * 180 / Double.pi)
    }
    
}

//MARK:// MKCoordinateRegion
extension MKCoordinateRegion {

    public var boundingBoxCoordinates: [CLLocationCoordinate2D] {
        let halfLatDelta = self.span.latitudeDelta / 2
        let halfLngDelta = self.span.longitudeDelta / 2

        let topLeftCoord = CLLocationCoordinate2D(
            latitude: self.center.latitude + halfLatDelta,
            longitude: self.center.longitude - halfLngDelta
        )
        let bottomRightCoord = CLLocationCoordinate2D(
            latitude: self.center.latitude - halfLatDelta,
            longitude: self.center.longitude + halfLngDelta
        )
        let bottomLeftCoord = CLLocationCoordinate2D(
            latitude: self.center.latitude - halfLatDelta,
            longitude: self.center.longitude - halfLngDelta
        )
        let topRightCoord = CLLocationCoordinate2D(
            latitude: self.center.latitude + halfLatDelta,
            longitude: self.center.longitude + halfLngDelta
        )

        return [topLeftCoord, topRightCoord, bottomRightCoord, bottomLeftCoord]
    }

}


//MARK:// MKMapView
extension MKMapView {
    
    public func getZoom() -> Double {
      // function returns current zoom of the map
      var angleCamera = self.camera.heading
      if angleCamera > 270 {
          angleCamera = 360 - angleCamera
      } else if angleCamera > 90 {
          angleCamera = fabs(angleCamera - 180)
      }
      let angleRad = Double.pi * angleCamera / 180 // camera heading in radians
      let width = Double(self.frame.size.width)
      let height = Double(self.frame.size.height)
      let heightOffset : Double = 20 // the offset (status bar height) which is taken by MapKit into consideration to calculate visible area height
      // calculating Longitude span corresponding to normal (non-rotated) width
      let spanStraight = width * self.region.span.longitudeDelta / (width * cos(angleRad) + (height - heightOffset) * sin(angleRad))
      return log2(360 * ((width / 256) / spanStraight)) + 1;
    }
    
}
