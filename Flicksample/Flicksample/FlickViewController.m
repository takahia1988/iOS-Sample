//
//  FlickViewController.m
//  Flicksample
//
//  Created by hiasa on 13/03/24.
//  Copyright (c) 2013年 hiasa. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FlickViewController.h"
#import "InnerScrollView.h"

#define SMALL_IMAGE_VIEW_SIZE 50
#define CHOOSE_VIEW_EXTRA_SIZE 2

@implementation FlickViewController

@synthesize imageFiles = _imageFiles;
@synthesize mainFlickView = _mainFlickView;
@synthesize chooseView = _chooseView;

#pragma mark -
#pragma mark UIViewController life cycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

    //small imageの実装
    int smallImageArrayFactorMaxNum = 6;
    UIImageView *smallImageView[smallImageArrayFactorMaxNum];
    int smallImageInterval = 2;
    int smallImageXPosition = (self.view.frame.size.width - smallImageArrayFactorMaxNum * SMALL_IMAGE_VIEW_SIZE - (smallImageArrayFactorMaxNum - 1) * smallImageInterval)/2;
    int smallImageYPosition = self.mainFlickView.frame.origin.x + self.mainFlickView.frame.size.height + 5;
    for(int i=0; i<smallImageArrayFactorMaxNum; i++) {
        smallImageView[i] = [[UIImageView alloc]initWithFrame:CGRectMake(smallImageXPosition+ i * (SMALL_IMAGE_VIEW_SIZE + smallImageInterval), smallImageYPosition , SMALL_IMAGE_VIEW_SIZE, SMALL_IMAGE_VIEW_SIZE)];
        smallImageView[i].image = [UIImage imageNamed:[self.imageFiles objectAtIndex:i]];
        smallImageView[i].userInteractionEnabled = YES;
        [self.view addSubview:smallImageView[i]];
        NSLog(@"frame[i]:%@", NSStringFromCGRect(smallImageView[i].frame));
    }
    
    //枠有のview
    self.chooseView = [[[UIView alloc]initWithFrame:CGRectMake(smallImageView[0].frame.origin.x - CHOOSE_VIEW_EXTRA_SIZE, smallImageView[0].frame.origin.y - CHOOSE_VIEW_EXTRA_SIZE, SMALL_IMAGE_VIEW_SIZE + 2 * CHOOSE_VIEW_EXTRA_SIZE, SMALL_IMAGE_VIEW_SIZE + 2 * CHOOSE_VIEW_EXTRA_SIZE)]autorelease];
    [_chooseView.layer setBorderColor:[UIColor redColor].CGColor];
    [_chooseView.layer setBorderWidth:2.0];
    [self.view addSubview:_chooseView];

    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.imageFiles = nil;
}


#pragma mark -
#pragma mark MainFlickViewDelegate
-(NSInteger)numberImagesInGallery:(MainFlickView*)galleryView
{
	return [self.imageFiles count];
}

-(UIImage*)galleryImage:(MainFlickView*)galleryView filenameAtIndex:(NSUInteger)index
{
    NSLog(@"image index:%d", index);
	return [UIImage imageNamed:[self.imageFiles objectAtIndex:index]];
}

-(void)galleryDidStopSlideShow:(MainFlickView*)galleryView
{
	NSLog(@"didStopSlideShow:");
}

-(void)nextImageChangeAction{
    NSLog(@"frame size old:%@", NSStringFromCGRect(self.chooseView.frame));
    CGRect frame = self.chooseView.frame;
    frame.origin.x = frame.origin.x + (frame.size.width - CHOOSE_VIEW_EXTRA_SIZE);
    NSLog(@"frame size new:%@", NSStringFromCGRect(frame));
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(scrollViewWillBeginDragging:)];
    [UIView setAnimationDidStopSelector:@selector(scrollViewDidEndDecelerating:)];
    self.chooseView.frame = frame;
    [UIView commitAnimations];
}
-(void)previousImageChangeAction{
    CGRect frame = self.chooseView.frame;
    frame.origin.x = frame.origin.x - (frame.size.width - CHOOSE_VIEW_EXTRA_SIZE);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationWillStartSelector:@selector(scrollViewWillBeginDragging:)];
    [UIView setAnimationDidStopSelector:@selector(scrollViewDidEndDecelerating:)];
    self.chooseView.frame = frame;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark Event
//- (IBAction)playSlideShow:(id)sender
//{
//	[self.galleryView startSlideShow];
//}

- (void)dealloc {
    [_mainScrollView release];
    [super dealloc];
}

#pragma mark - small image view touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    printf("smallView touchesBegan\n");
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self.view];
//	NSLog(@"x座標:%f y座標:%f",location.x,location.y);
    if (location.y > (self.mainFlickView.frame.origin.x +self.mainFlickView.frame.size.height + 5) && location.y < (self.mainFlickView.frame.origin.x +self.mainFlickView.frame.size.height + SMALL_IMAGE_VIEW_SIZE + 5)){
        printf("smallView touchesEnded\n");
        int index = 0;
        index = location.x/SMALL_IMAGE_VIEW_SIZE;
        NSLog(@"index:%d", index);
        [self.mainFlickView changeView:index];
    }
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    printf("smallView touchesMoved\n");
}


@end
