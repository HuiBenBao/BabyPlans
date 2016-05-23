//
//  EditImageController.m
//  BabyPlans
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "EditImageController.h"
#import "MyCollectionViewCell.h"

@interface EditImageController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>

@property(nonatomic,retain)UICollectionView *collectionView;
@property(nonatomic,retain)NSMutableArray *dataArr;
@property(nonatomic,retain)UILongPressGestureRecognizer *longPress;
@property(nonatomic,retain)UIPanGestureRecognizer *panGes;
@property(nonatomic,retain)UIImageView *snapshotImg;

@property(nonatomic,retain)NSIndexPath *presentIndex;
@property(nonatomic,retain)NSIndexPath *currentIndex;
@property (nonatomic, assign) CGPoint panTranslation;

@property(nonatomic,assign)int dx;
@property(nonatomic,assign)int dy;

@end

@implementation EditImageController

- (void)viewDidLoad{

    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTopView];
}

- (void)createTopView{

    UIImageView * topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    
    topView.image = [UIImage imageNamed:@"NagavitionBarImg"];
    
    [self.view addSubview:topView];
    
    NSArray * titleArr = @[@"取消",@"完成"];
    for (int i = 0; i < titleArr.count; i++) {
        
        UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat btnW = 60;
        CGFloat btnX = i==0 ? 0 : KScreenWidth - btnW;
        backBtn.frame = CGRectMake(btnX, 20, btnW, 40);
        
        [backBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        backBtn.tag = i;
        
        [backBtn addTarget:self action:@selector(backViewContorller:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.view addSubview:backBtn];
    }
    
    
    
}
- (void)backViewContorller:(UIButton *)sender{

    if (sender.tag==0) {//点击取消
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{//点击完成
        
        NSMutableArray * tempArr = [NSMutableArray array];
        for (int i = 0; i < _imageArr.count; i++) {
            
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            
            MyCollectionViewCell *cell = (MyCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            
            NSInteger tag = cell.imageView.tag;
            
            for (UIImageView * imgV in _imageArr) {
                if (imgV.tag == tag) {
                    
                    [tempArr insertObject:imgV atIndex:0];
                }
            }
        }
        
        _imageArr = tempArr;
        
        if ([self.delegate respondsToSelector:@selector(reloadImageWithArr:)]) {
            [self.delegate reloadImageWithArr:_imageArr];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }
}

- (void)setImageArr:(NSArray *)imageArr{

    _imageArr = imageArr;
    
    [self addCollectionView];
}
- (void)addCollectionView{

    self.snapshotImg = [[UIImageView alloc]init];
    self.snapshotImg.bounds = CGRectMake(0, 0, 100, 100);
    self.snapshotImg.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(100, 100);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, KNavBarHeight + 10, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    UILongPressGestureRecognizer *  longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    longPressGesture.delegate = self;
    panGesture.delegate = self;
    [self.collectionView addGestureRecognizer:longPressGesture];
    [self.collectionView addGestureRecognizer:panGesture];
    self.longPress = longPressGesture;
    self.panGes = panGesture;

}

-(void)handleLongPressGesture:(UILongPressGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.collectionView.userInteractionEnabled = NO;
            
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
            _currentIndex = [NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section];
            _presentIndex = [NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section];
            self.collectionView.scrollsToTop = NO;
            MyCollectionViewCell *cell = (MyCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            _snapshotImg.center = cell.center;
            
            _snapshotImg.image = cell.imageView.image;
            [self.collectionView addSubview:_snapshotImg];
            
            
            //////////
            _dx = cell.center.x-[sender locationInView:self.collectionView].x;
            _dy = cell.center.y-[sender locationInView:self.collectionView].y;
            
            CGRect fakeViewRect = cell.frame;
            fakeViewRect.size = CGSizeMake(120, 120);
            [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                _snapshotImg.frame = fakeViewRect;
                _snapshotImg.center = cell.center;
                _snapshotImg.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
            } completion:^(BOOL finished) {
                cell.hidden = YES;
            }];
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            self.collectionView.userInteractionEnabled = YES;
            
            self.collectionView.scrollsToTop = NO;
            
            CGPoint point = [sender locationInView:self.collectionView];
            point = CGPointMake(point.x+_dx ,point.y+_dy);
            
            MyCollectionViewCell *cell = (MyCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:_currentIndex];
            
            CGRect fakeViewRect = cell.frame;
            fakeViewRect.size = CGSizeMake(100, 100);
            [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                _snapshotImg.frame = fakeViewRect;
                _snapshotImg.center = cell.center;
                _snapshotImg.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
            } completion:^(BOOL finished) {
                cell.hidden = NO;
                [_snapshotImg removeFromSuperview];
                
            }];
        }
            break;
        default:
            break;
    }
}
-(void)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateChanged:
        {
            _panTranslation = [sender locationInView:self.collectionView];
            _snapshotImg.center = CGPointMake(_panTranslation.x+_dx, _panTranslation.y+_dy);
            
            NSIndexPath *index = [self.collectionView indexPathForItemAtPoint:_snapshotImg.center];
            
            if (index) {
                _currentIndex = [NSIndexPath indexPathForItem:index.item inSection:index.section];
                if (_currentIndex.item == _presentIndex.item) {
                    
                    return;
                }
                
                [self.collectionView moveItemAtIndexPath:_presentIndex toIndexPath:_currentIndex];
            }
            
            NSObject *obj = _dataArr[_presentIndex.item];
            [_dataArr removeObjectAtIndex:_presentIndex.item];
            [_dataArr insertObject:obj atIndex:_currentIndex.item];
            
            _presentIndex = [NSIndexPath indexPathForItem:_currentIndex.item inSection:_currentIndex.section];
        }
            
            break;
        case UIGestureRecognizerStateEnded:{
            NSLog(@"结束移动");

            break;
        }
        default:
            break;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self.panGes isEqual:gestureRecognizer]) {
        if (self.longPress.state == 0 || self.longPress.state == 5) {
            return NO;
        }
    }else if ([self.longPress isEqual:gestureRecognizer]) {
        if (self.collectionView.panGestureRecognizer.state != 0 && self.collectionView.panGestureRecognizer.state != 5) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([self.panGes isEqual:gestureRecognizer]) {
        if (self.longPress.state != 0 && self.longPress.state != 5) {
            if ([self.longPress isEqual:otherGestureRecognizer]) {
                return YES;
            }
            return NO;
        }
    }else if ([self.longPress isEqual:gestureRecognizer]) {
        if ([self.longPress isEqual:otherGestureRecognizer]) {
            return YES;
        }
    }else if ([self.collectionView.panGestureRecognizer isEqual:gestureRecognizer]) {
        if (self.longPress.state == 0 || self.longPress.state == 5) {
            return NO;
        }
    }
    return YES;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArr.count;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (_imageArr.count>0) {
        NSInteger index = _imageArr.count-indexPath.row-1;
        UIImageView * imgV = (UIImageView *)_imageArr[index];
        
        cell.imageView.image = imgV.image;
        cell.imageView.tag = imgV.tag;
    }
    
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    [self reloadImageArr];
    
    NSString * text = [NSString stringWithFormat:@"确定要将第%ld张图删除？",indexPath.row+1];
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提醒" message:text preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        MyCollectionViewCell *cell = (MyCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        NSMutableArray * tempArr = [NSMutableArray arrayWithArray:_imageArr];
        for (UIImageView * imgV in _imageArr) {
            if (imgV.tag == cell.imageView.tag) {
                [tempArr removeObject:imgV];
            }
        }
        _imageArr = tempArr;
        
        [self.collectionView reloadData];
    }];
    
    [alertVC addAction:cancle];
    [alertVC addAction:sure];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)reloadImageArr{

    NSMutableArray * tempArr = [NSMutableArray array];
    for (int i = 0; i < _imageArr.count; i++) {
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        MyCollectionViewCell *cell = (MyCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        NSInteger tag = cell.imageView.tag;
        
        for (UIImageView * imgV in _imageArr) {
            if (imgV.tag == tag) {
                
                [tempArr insertObject:imgV atIndex:0];
            }
        }
    }
    
    _imageArr = tempArr;
    
    [self.collectionView reloadData];
}
@end
