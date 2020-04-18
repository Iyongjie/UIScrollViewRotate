//
//  ViewController.m
//  UIScrollViewRotate
//
//  Created by 李永杰 on 2020/4/18.
//  Copyright © 2020 NewPath. All rights reserved.
//

#import "ViewController.h"
#import "SDCycleScrollView.h"

#define kScreenWidth self.view.frame.size.width
#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

@interface ViewController ()

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, copy)   NSArray           *imageNames;
@property (nonatomic, assign) NSInteger         currentIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageNames = @[@"h1.jpg", @"h2.jpg", @"h3.jpg", @"h4.jpg"];
    [self configUI];
}

- (void)configUI {
    __weak typeof(self) weakSelf = self;
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenWidth/2.0) shouldInfiniteLoop:YES imageNamesGroup:self.imageNames];
    self.cycleScrollView.itemDidScrollOperationBlock = ^(NSInteger currentIndex) {
        NSLog(@"%ld-----",currentIndex);
        weakSelf.currentIndex = currentIndex;
    };
    [self.view addSubview:self.cycleScrollView];
}
- (void)orientChange {
    //需要重新设置contentSize，contentOffset
    UIScrollView *scrollView;
    for (UIView *view in self.cycleScrollView.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView *)view;
        }
    }
    scrollView.contentOffset = CGPointMake(kScreenWidth*self.currentIndex, 0);
    scrollView.contentSize = CGSizeMake(self.imageNames.count*kScreenWidth, 0);
}
// 旋转触发，重新布局
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.cycleScrollView.frame = CGRectMake(0, 100, kScreenWidth, kScreenWidth/2.0);
    [self orientChange];
}

#pragma mark 横竖屏切换
- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (kIs_iphone) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
@end
