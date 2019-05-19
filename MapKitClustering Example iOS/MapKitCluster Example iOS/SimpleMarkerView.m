//
//  SimpleMarkerView.m
//  CCHMapClusterController Example iOS
//
//  Created by Hal Mueller on 5/19/19.
//  Copyright © 2019 Claus Höfele. All rights reserved.
//

#import "SimpleMarkerView.h"

@implementation SimpleMarkerView
NSString *clusteringIdentifier = @"SimpleMarkerView";

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.clusteringIdentifier = clusteringIdentifier;
    }
    return self;
}

@end
