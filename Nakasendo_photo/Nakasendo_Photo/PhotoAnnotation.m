//
//  PhotoAnnotation.m
//  Nakasendo_Photo
//
//  Created by マサヒロ　パソナPC on 13/09/30.
//  Copyright (c) 2013年 pasonatech. All rights reserved.
//

#import "PhotoAnnotation.h"

@implementation PhotoAnnotation

@synthesize coordinate;
@synthesize title;

- (id)initWithCoordinate:(CLLocationCoordinate2D)co
{
    coordinate = co;
    return self;
}

@end
