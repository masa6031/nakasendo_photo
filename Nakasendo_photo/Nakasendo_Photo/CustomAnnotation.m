//
//  PhotoAnnotation.m
//  Nakasendo_Photo
//
//  Created by マサヒロ　パソナPC on 13/09/30.
//  Copyright (c) 2013年 pasonatech. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize photoID;

- (id)initWithCoordinate:(CLLocationCoordinate2D)co
{
    coordinate = co;
    return self;
}

@end
