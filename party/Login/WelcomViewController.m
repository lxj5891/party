//
//  WelcomViewController.m
//  scrol
//
//  Created by lly on 13-3-1.
//  Copyright (c) 2013年 李 萌萌. All rights reserved.
//

#import "WelcomViewController.h"
 #import <QuartzCore/QuartzCore.h>
@interface WelcomViewController ()

@end

@implementation WelcomViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hideTabBar:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self hideTabBar:YES];
	// Do any additional setup after loading the view.

    self.view.backgroundColor=[UIColor greenColor];
    scrollview =[[UIScrollView alloc] initWithFrame:CGRectMake(10, 0, 300, 400)];
    scrollview.contentSize=CGSizeMake(300, 1000);
    scrollview.contentOffset=CGPointMake(0.0, 600);
    scrollview.backgroundColor=[UIColor orangeColor];
    //scrollview.pagingEnabled=YES;//是否自己动适应
    UIView* sview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
    sview.backgroundColor=[UIColor blueColor];
    [scrollview addSubview:sview];
    [sview release];
    [self.view addSubview:scrollview];
    scrollview.delegate=self;
    //canCancelContentTouches:YES-移动手指足够长度触发滚动事件,NO-scrollView 发送 tracking events 后，就算用户移动手指，scrollView 也不会滚动。
    scrollview.canCancelContentTouches=NO;
    
    //当值是 YES 的时候，用户触碰开始.要延迟一会，看看是否用户有意图滚动。假如滚动了，那么捕捉 touch-down 事件，否则就不捕捉。假如值是NO，当用户触碰， scroll view 会立即触发
    scrollview.delaysContentTouches=YES;
    [scrollview release];

}
//只要滚动了就会触发
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    //    NSLog(@" scrollViewDidScroll");
    NSLog(@"ContentOffset  x is  %f,yis %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    if (scrollview.contentOffset.y<=0) {
        
        [self removeScro];
        //         
        //        CATransition *animation = [CATransition animation];
        //        [animation setDuration:3.3];
        //        [animation setType:kCATransitionPush];
        //        [animation setSubtype:kCATransitionFromBottom];
        //        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        //
        //        [self.navigationController pushViewController:wel animated:NO];
        //        [self.navigationController.view.layer addAnimation:animation forKey:nil];
    }
}

-(void)removeScro
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:2.0];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromBottom];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    
    [[self.view.superview.superview layer]addAnimation:animation forKey:nil ];
    [self.view.superview removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) hideTabBar:(BOOL) hidden {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    
    for(UIView *view in self.tabBarController.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, mainscreenhight, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, (mainscreenhight-36), view.frame.size.width, view.frame.size.height)];
            }
        }
        else
        {
            if (hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, mainscreenhight)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,mainscreenhight-36)];//(mainscreenhight-49)*mainscreenhight/460.0)
            }
        }
    }
    
    [UIView commitAnimations];
}

-(void)dealloc
{
    [scrollview release];
    [super dealloc];
}
@end
