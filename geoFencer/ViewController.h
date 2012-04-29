//  Created by James Graham on 4/29/12

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GeoMapView.h"

@interface ViewController : UIViewController <MKMapViewDelegate>
{
    IBOutlet GeoMapView *mapView;
}

@property (nonatomic, retain) IBOutlet GeoMapView *mapView;

@end
