//
//  PhotoData.m
//  Nakasendo_Photo
//
//  Created by マサヒロ　パソナPC on 13/10/02.
//  Copyright (c) 2013年 pasonatech. All rights reserved.
//

#import "PhotoData.h"

@implementation PhotoData
@synthesize photoId;
@synthesize photoLatitude;
@synthesize photoLongitude;
@synthesize photoSize;
@synthesize photoBlobData;
@synthesize albumId;
@synthesize thumbnailSize;
@synthesize thumbnailData;

- (id)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    return self;
}

- (void)dealloc
{
    [photoId release], photoId = nil;
    [photoLatitude release], photoLatitude = nil;
    [photoLongitude release], photoLongitude = nil;
    [photoSize release], photoSize =  nil;
    [photoBlobData release], photoBlobData = nil;
    [albumId release], albumId = nil;
    [thumbnailSize release], thumbnailSize = nil;
    [thumbnailData release], thumbnailData = nil;
    [super dealloc];
}

@end
