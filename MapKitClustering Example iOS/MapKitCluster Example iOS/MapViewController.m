//
//  ViewController.m
//  CCHMapClusterController Example iOS
//
//  Created by Hoefele, Claus(choefele) on 27.11.13.
//  Copyright (c) 2013 Claus Höfele. All rights reserved.
//

#import "MapViewController.h"

#import <MapKit/MapKit.h>

#import "DataReader.h"
#import "DataReaderDelegate.h"
#import "ClusterAnnotationView.h"
#import "SettingsViewController.h"
#import "Settings.h"
#import "SimpleMarkerView.h"

@interface MapViewController()<DataReaderDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) DataReader *dataReader;
@property (nonatomic) Settings *settings;
@property (nonatomic) NSUInteger count;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Early out when running unit tests
    BOOL runningTests = NSClassFromString(@"XCTestCase") != nil;
    if (runningTests) {
        return;
    }
    
    // Read annotations
    self.dataReader = [[DataReader alloc] init];
    self.dataReader.delegate = self;

    // Settings
    [self resetSettings];
    
    [self.mapView registerClass:SimpleMarkerView.class forAnnotationViewWithReuseIdentifier:MKMapViewDefaultAnnotationViewReuseIdentifier];
}

- (IBAction)resetSettings
{
    self.count = 0;
    Settings *settings = [[Settings alloc] init];
    [self updateWithSettings:settings];
}

- (void)updateWithSettings:(Settings *)settings
{
    self.settings = settings;
    
    // Restart data reader
    self.count = 0;
    [self.dataReader stopReadingData];

    MKCoordinateRegion region;
    if (self.settings.dataSet == SettingsDataSetBerlin) {
        // 5000+ items near Berlin
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(52.516221, 13.377829);
        region = MKCoordinateRegionMakeWithDistance(location, 45000, 45000);
        [self.dataReader startReadingBerlinData];
    } else {
        // 80000+ items in the US
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(39.833333, -98.583333);
        region = MKCoordinateRegionMakeWithDistance(location, 7000000, 7000000);
        [self.dataReader startReadingUSData];
    }
    self.mapView.region = region;
    
    // Remove all current items from the map
    for (id<MKOverlay> overlay in self.mapView.overlays) {
        [self.mapView removeOverlay:overlay];
    }
}

- (void)dataReader:(DataReader *)dataReader addAnnotations:(NSArray *)annotations
{
    [self.mapView addAnnotations:annotations];
}

#pragma mark - MKMapViewDelegate

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"mapToSettings"]) {
        UINavigationController *navigationViewController = (UINavigationController *)segue.destinationViewController;
        SettingsViewController *settingsViewController = (SettingsViewController *)navigationViewController.topViewController;
        settingsViewController.settings = self.settings;
        settingsViewController.completionBlock = ^(Settings *settings) {
            [self updateWithSettings:settings];
        };
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:MKClusterAnnotation.class]) {
        MKClusterAnnotation *annotation = view.annotation;
        [mapView showAnnotations:annotation.memberAnnotations animated:YES];
    }
    [mapView deselectAnnotation:view.annotation animated:YES];
}
@end
