//
//  DetailViewController.h
//  NSZombieTest
//
//  Created by yuanrui on 14-12-16.
//  Copyright (c) 2014年 KudoCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

