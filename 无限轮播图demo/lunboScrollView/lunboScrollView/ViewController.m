//
//  ViewController.m
//  lunboScrollView
//
//  Created by Fruit on 16/7/21.
//  Copyright © 2016年 chao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *myscrollView;

@property (nonatomic,strong)NSArray *colorsArray;
@property (nonatomic,strong)NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.myscrollView.delegate = self;
    
    NSArray *colorArray = @[[UIColor blueColor],[UIColor redColor],[UIColor yellowColor],[UIColor blueColor],[UIColor redColor]];
    self.colorsArray = [NSArray arrayWithArray:colorArray];
    /*
     假设  scrollview展示三个View  红 黄 蓝
     这里 最左边加个 蓝 右边加个红 用于循环
     
     
     */
    for (int i = 0; i < colorArray.count; i++) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = colorArray[i];
        view.frame = CGRectMake(i*CGRectGetWidth(self.view.frame), 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(_myscrollView.frame));
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        lable.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(_myscrollView.frame)/2 - 15);
        
        [lable setFont:[UIFont systemFontOfSize:21]];
        
        
        lable.textAlignment = NSTextAlignmentCenter;
        lable.text = [NSString stringWithFormat:@"%d",i];
        [view addSubview:lable];
        [_myscrollView addSubview:view];
    }
    
    _myscrollView.pagingEnabled = YES;
    _myscrollView.showsHorizontalScrollIndicator = NO;
    _myscrollView.contentSize = CGSizeMake(colorArray.count*CGRectGetWidth(self.view.frame), 0);
    _myscrollView.contentOffset = CGPointMake(CGRectGetWidth(self.view.frame), 0);
    _myscrollView.bounces = NO;
    
    
    
    [self addTimer];
    
    
}
/**
 *  开启定时器
 */
- (void)addTimer
{
    if (self.timer) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
/**
 *  销毁定时器
 */
- (void)invalidateTimer
{
    [self.timer invalidate];
    
    self.timer = nil;
}
- (void)runImage
{
    CGPoint apoint = self.myscrollView.contentOffset;
    
    [self.myscrollView setContentOffset:CGPointMake(apoint.x+CGRectGetWidth(self.view.frame), 0) animated:YES];
    
}
/**
 *  手动 拖拽scrollView 调用
 *
 *  @param scrollView <#scrollView description#>
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"end");
    
    if (scrollView.contentOffset.x==0) {//滑动到最左边
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame)*(self.colorsArray.count-2), 0)];
    }else if (scrollView.contentOffset.x==scrollView.contentSize.width-CGRectGetWidth(self.view.frame)){//最右边
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame), 0)];
    }
}
/**
 *  定时器 以动画形式改变scrollview的contentOffset 调用
 *
 *  @param scrollView <#scrollView description#>
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"endani");
    if (scrollView.contentOffset.x==0) {
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame)*(self.colorsArray.count-2), 0)];
    }else if (scrollView.contentOffset.x==scrollView.contentSize.width-CGRectGetWidth(self.view.frame)){
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.view.frame), 0)];
    }
}
/**
 *  开始拖拽
 *
 *  @param scrollView <#scrollView description#>
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self invalidateTimer];
}
/**
 *  结束拖拽
 *
 *  @param scrollView <#scrollView description#>
 *  @param decelerate <#decelerate description#>
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"enddra");
    [self addTimer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
