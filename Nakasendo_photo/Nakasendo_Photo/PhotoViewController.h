//
//  PhotoViewController.h
//  Nakasendo_Photo
//
//  Created by マサヒロ　パソナPC on 13/10/03.
//  Copyright (c) 2013年 pasonatech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController
- (IBAction)tapBackButton:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;

@end
