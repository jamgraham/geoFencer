//  Created by James Graham on 4/29/12

#import <MapKit/MapKit.h>

@interface GeoMapView : MKMapView
{
    MKCoordinateRegion cordRegion;
    CLLocationCoordinate2D oldcenter;
    double left;
    double right;
    double top;
    double bottom;
    double zoomMax;
    double zoomMin;
}

-(void)checkZoom;
-(void)checkScroll;

@property (nonatomic) double left;
@property (nonatomic) double right;
@property (nonatomic) double top;
@property (nonatomic) double bottom;
@property (nonatomic) double zoomMax;
@property (nonatomic) double zoomMin;

@end
