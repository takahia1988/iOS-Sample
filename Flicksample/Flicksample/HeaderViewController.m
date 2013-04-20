//
//  ViewController.m
//  Flicksample
//
//  Created by hiasa on 13/03/24.
//  Copyright (c) 2013年 hiasa. All rights reserved.
//

#import "HeaderViewController.h"
#import "FlickViewController.h"

@interface HeaderViewController ()

@end

@implementation HeaderViewController

- (void)viewDidLoad
{
    
    
//    NSString* path = [[NSBundle mainBundle] resourcePath];
	NSMutableArray* array = [NSMutableArray array];
	for (int i=0; i < 6; i++) {
		[array addObject:[NSString stringWithFormat:@"image%02d.jpg", i+1]];
        //		NSLog(@"%@", [NSString stringWithFormat:@"%@/image%02d.jpg", path, i+1]);
	}
    
    FlickViewController *controller = [[FlickViewController alloc] initWithNibName:@"FlickViewController" bundle:nil];
    controller.imageFiles = array;
    [self.view addSubview:controller.view];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
