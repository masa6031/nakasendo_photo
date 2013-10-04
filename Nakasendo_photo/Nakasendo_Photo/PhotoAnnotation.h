//
//  PhotoAnnotation.h
//  Nakasendo_Photo
//
//  Created by マサヒロ　パソナPC on 13/09/30.
//  Copyright (c) 2013年 pasonatech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PhotoAnnotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
}

@property (nonatomic)CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;

-(id)initWithCoordinate:(CLLocationCoordinate2D)co;

@end
