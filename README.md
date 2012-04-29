
I worked on a project with a requirement to lock the boundaries of MKMapView. As there is no out-of-the-box solution provided by apple we are left subclassing MKMapView.  This is pretty easy and gives you access to the UIScrollView that lives in the map and other fun objects in the MKMapView.

Want to look at the code now?  It's available here

Locking the boundaries of the a MKMapView invokes two general steps.  First is to lock the zoom level to a min and max. Second is to prevent the user from scrolling outside the foundry you create.  Lets walk through these by looking at the delegates we need to override

1. Zoom Level
----------------
This is pretty straight forward.  The goal is the check the zoom level as the user zooms and again when the user stops zooming.

     -(void)scrollViewDidZoom:(UIScrollView *)scrollView;
     -(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale;

2. Scrolling boundaries
----------------
This is a bit more complex.  As the user scrolls around the map in the UIScrollView we want to make sure they do not go outside the boundaries and if they do we want to stop them.  We can achieve this by repositioning the map to the boundary when we see the user go outside the boundary.  This happens fast enough where the users feels like they've hit a wall rather than the map jerking around.  Here are the delegates we need to watch for:

     -(void)scrollViewDidScroll:(UIScrollView *)scrollView;
     -(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;


3. Copy & Paste
----------------
Feel free to copy and paste the custom MKMapView below. In the UIViewController that show the map the custom map view needs the boundaries set

ViewController.m
----------------

		//Set map boundaries
		mapView.showsUserLocation = YES;
		[mapViewsetZoomMax:0.015551];
		[mapViewsetZoomMin: 0.346360];
		mapView.top = 37.773498;
		mapView.bottom = 37.745130;
		mapView.left = -122.430365;
		mapView.right = -122.401623;

GeoMapView.h
----------------

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

GeoMapView.m
----------------

	#import "GeoMapView.h"

	@implementation GeoMapView
	@synthesize  left, right, top, bottom,zoomMax,zoomMin;

	- (id)initWithFrame:(CGRect)frame
	{
		self = [superinitWithFrame:frame];
		if (self) {

		}
		returnself;
	}

	-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
		[selfcheckZoom];    
	}


	-(void)checkZoom{
		UIScrollView * scroll = [[[[selfsubviews] objectAtIndex:0] subviews] objectAtIndex:0];

		if (scroll.zoomScale < zoomMax) {
			NSLog(@"Reached Max Zoom");
			[scroll setZoomScale:zoomMaxanimated:NO];
		}

		if (scroll.zoomScale >= zoomMin) {
			NSLog(@"Reached Min Zoom");
			[scroll setZoomScale:zoomMinanimated:NO];

		}
	}

	-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
	{
		UIScrollView * scroll = [[[[selfsubviews] objectAtIndex:0] subviews] objectAtIndex:0];

		if (scroll.zoomScale > zoomMin) {
			[scroll setZoomScale:zoomMinanimated:NO];
		}   
	}

	-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

		[selfcheckScroll];

	}

	-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
		[selfcheckScroll];
	}

	-(void)checkScroll{
		@try{
			cordRegion = self.region;

			CLLocationCoordinate2D center = self.region.center;
			CLLocationCoordinate2D northWestCorner, southEastCorner;
			northWestCorner.latitude  = center.latitude  + (self.region.span.latitudeDelta  / 2.0);
			northWestCorner.longitude = center.longitude - (self.region.span.longitudeDelta / 2.0);
			southEastCorner.latitude  = center.latitude  - (self.region.span.latitudeDelta  / 2.0);
			southEastCorner.longitude = center.longitude + (self.region.span.longitudeDelta / 2.0);

			CLLocationCoordinate2D newcenter;
			newcenter.latitude = self.region.center.latitude;
			newcenter.longitude = self.region.center.longitude;

			//LEFT
			CLLocationDegrees farLeft = left;
			CLLocationDegrees snapToLeft = farLeft + (self.region.span.longitudeDelta  / 2.0);
			if (northWestCorner.longitude < farLeft)
			{
				newcenter.longitude = snapToLeft;
				cordRegion = self.region;
			}

			//RIGHT
			CLLocationDegrees r = (self.region.span.longitudeDelta / 2.0);
			CLLocationDegrees farRight = right;
			CLLocationDegrees snapToRight = farRight - r;
			if (southEastCorner.longitude > farRight)
			{
				newcenter.longitude = snapToRight;
			}

			//TOP
			CLLocationDegrees farTop = top;
			CLLocationDegrees snapToTop = top - (self.region.span.latitudeDelta  / 2.0);
			if (northWestCorner.latitude > farTop)
			{
				newcenter.latitude = snapToTop;
			}

			//BOTTOM
			CLLocationDegrees farBottom = bottom;
			CLLocationDegrees rr = (self.region.span.latitudeDelta  / 2.0);
			CLLocationDegrees snapToBottom = bottom + rr;
			if (southEastCorner.latitude < farBottom)
			{            
				newcenter.latitude = snapToBottom;
			}

			[selfsetCenterCoordinate:newcenter  animated:NO];

		}
		@catch (NSException *e) {
		}
		@finally {}
	}


	@end


Ideas
----------------
There's a lot of cool stuff going on in geofencing right now. Some ideas:

- Enter an address and lock  the map to that address
- Geofencing with map overlays
- Physical games that unlock areas of the map as the user actually visits those physical places.