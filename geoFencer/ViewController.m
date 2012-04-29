//  Created by James Graham on 4/29/12

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //Set map boundaries
    mapView.showsUserLocation = YES;
    [mapView setZoomMax:0.015551];
    [mapView setZoomMin: 0.346360];
    mapView.top = 37.773498;
    mapView.bottom = 37.745130;
    mapView.left = -122.430365;
    mapView.right = -122.401623;
    

    //load map to default zoom and center when app opens
    CLLocationCoordinate2D center;
    center.latitude = 37.764217;
    center.longitude = -122.420141;
    [mapView setCenterCoordinate:center animated:YES];

    UIScrollView * scroll = [[[[mapView subviews] objectAtIndex:0] subviews] objectAtIndex:0];
    [scroll setZoomScale:0.020551 animated:NO];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.mapView.centerCoordinate = userLocation.location.coordinate;
} 

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)dealloc
{
    [mapView release];
    [super dealloc];
}

@end
