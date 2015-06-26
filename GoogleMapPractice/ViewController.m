//
//  ViewController.m
//  GoogleMapPractice
//
//  Created by Manish Kumar on 06/05/15.
//  Copyright (c) 2015 Innofied Solutions Pvt. Ltd. All rights reserved.
//

#import "ViewController.h"
#import<GoogleMaps/GoogleMaps.h>

@interface ViewController ()<GMSMapViewDelegate>
{
    GMSMapView *mapView_;
    UIView *viewForSlider;
    UILabel *labelToShowCurrentRadiusValue;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:22.595769
                                                            longitude:88.263639
                                                                 zoom:12];
    
    //plotting the google map
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) camera:camera];
    mapView_.delegate=self;
    mapView_.settings.myLocationButton = YES;
    mapView_.myLocationEnabled = YES;
    [self.view addSubview:mapView_];
    
    
    //Creates a marker at kolkata location.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(22.595769, 88.263639);
    marker.title = @"Howrah";
    marker.snippet = @"Kolkata";
    marker.map = mapView_;
    
    
    //view for slider
    viewForSlider = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 62.0 , self.view.frame.size.width, 62.0)];
    viewForSlider.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
    //viewForSlider.hidden = YES;
    [self.view addSubview:viewForSlider];
    
    
    //label to show Current Radius Value
    labelToShowCurrentRadiusValue =[[UILabel alloc]initWithFrame:CGRectMake(0, 8.0, viewForSlider.frame.size.width, 20.0)];
    labelToShowCurrentRadiusValue.backgroundColor=[UIColor clearColor];
    [labelToShowCurrentRadiusValue setFont:[UIFont systemFontOfSize:15.0]];
    labelToShowCurrentRadiusValue.textAlignment=NSTextAlignmentCenter;
    labelToShowCurrentRadiusValue.textColor=[UIColor colorWithRed:84.0/255.0 green:84.0/255.0 blue:84.0/255.0 alpha:1.0];
    [viewForSlider addSubview:labelToShowCurrentRadiusValue];
    
    
    [self startUserTracking];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - startUserTracking
/**
 *  function to track user on map
 */
-(void)startUserTracking
{
    // Listen to the myLocation property of GMSMapView.
    if (mapView_.observationInfo == nil)
    {
        [mapView_ addObserver:self
                  forKeyPath:@"myLocation"
                     options:NSKeyValueObservingOptionNew
                     context:NULL];
        
        // Ask for My Location data after the map has already been added to the UI.
        dispatch_async(dispatch_get_main_queue(), ^{
            mapView_.myLocationEnabled = YES;
        });
    }
}

/**
 *  KVO pattern functio to observe change in user location
 *
 *  @param keyPath NSString
 *  @param object  id
 *  @param change  NSDictionary
 *  @param context context description
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    
    CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
    
    mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                    zoom:18];
    
    labelToShowCurrentRadiusValue.text = [NSString stringWithFormat:@"%f , %f", location.coordinate.latitude, location.coordinate.longitude];
}
@end
