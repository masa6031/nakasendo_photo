//
//  PhotoViewController.m
//  Nakasendo_Photo
//
//  Created by マサヒロ　パソナPC on 13/10/03.
//  Copyright (c) 2013年 pasonatech. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoTable.h"
#import "PhotoData.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController
@synthesize photoData = _photoData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    NSMutableArray *array = [PhotoTable selectWithPhotoId:@"1"];
//    PhotoData *data = array[0];
    _imageView.image = [UIImage imageWithData:self.photoData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapBackButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dealloc {
    [_imageView release];
    [_photoData release], _photoData = nil;
    [super dealloc];
}
@end
