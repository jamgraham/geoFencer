//  Created by James Graham on 4/29/12


#import "GeoMapView.h"

@implementation GeoMapView
@synthesize  left, right, top, bottom,zoomMax,zoomMin;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self checkZoom];    
}


-(void)checkZoom{
    UIScrollView * scroll = [[[[self subviews] objectAtIndex:0] subviews] objectAtIndex:0];
    
    if (scroll.zoomScale < zoomMax) {
        NSLog(@"Reached Max Zoom");
        [scroll setZoomScale:zoomMax animated:NO];
    }
    
    if (scroll.zoomScale >= zoomMin) {
        NSLog(@"Reached Min Zoom");
        [scroll setZoomScale:zoomMin animated:NO];
        
    }
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    UIScrollView * scroll = [[[[self subviews] objectAtIndex:0] subviews] objectAtIndex:0];
   
    if (scroll.zoomScale > zoomMin) {
        [scroll setZoomScale:zoomMin animated:NO];
    }   
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self checkScroll];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self checkScroll];
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
        
        [self setCenterCoordinate:newcenter  animated:NO];
        
    }
    @catch (NSException *e) {
    }
    @finally {}
}


@end