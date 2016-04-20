//
//  CreateMyPictureController.m
//  BabyPlans
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CreateMyPictureController.h"
#import "DJCameraViewController.h"
#import "AddPicScrollView.h"
#import "PhotoViewController.h"

@interface CreateMyPictureController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,AddPicScrollViewDelegate>

//选择相片后存储在沙盒中的完整路径
@property (nonatomic,strong) NSString * filePath;

@property (nonatomic,strong) AddPicScrollView * addPicView;

@end


@implementation CreateMyPictureController


- (void)viewDidLoad{

    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.addPicView = [[AddPicScrollView alloc] initWithFrame:CGRectMake(0, KNavBarHeight, KScreenWidth, 100*SCREEN_WIDTH_RATIO55)];
    self.addPicView.backgroundColor = ViewBackColor;
    
    self.addPicView.picDelegate = self;
    
    [self.view addSubview:_addPicView];
}

#pragma ------mark-----AddPicScrollViewDelegate

- (void)addPictureBtnClick{

    [self openMenu];
}

#pragma ------mark------点击头像调用方法打开相机
/**
 *  选择菜单
 */
-(void)openMenu{
    //在这里呼出下方菜单按钮项
    UIActionSheet * photoMenuSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles: @"拍照", @"从相册选择",nil];
    
    [photoMenuSheet showInView:self.view];
    
}
/**
 *  点击菜单后的相应事件
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //呼出的菜单按钮点击后的响应
    switch (buttonIndex){
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
            
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}
/**
 *  打开相机
 */
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    [picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"NagavitionBarImg"] forBarMetrics:UIBarMetricsDefault];
    
    [picker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FONTBOLD_ADAPTED_WIDTH(21)}];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = NO;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
}
/**
 * 当选择一张图片后进入这里
 */
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]){
        
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //图片压缩，因为原图都是很大的，不必要传原图
        UIImage *scaleImage = [self scaleImage:image toScale:0.3];
        
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp)
        {
            // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
            // 以下为调整图片角度的部分
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // 调整图片角度完毕
        }
        NSData *data;
        
        if (UIImagePNGRepresentation(scaleImage) == nil){
            data = UIImageJPEGRepresentation(scaleImage, 1.0);
        }
        else{
            data = UIImagePNGRepresentation(scaleImage);
        }
        
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.jpg
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        _filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:NO completion:^{
            
            PhotoViewController * VC = [[PhotoViewController alloc] init];
            
            VC.image = [UIImage imageWithContentsOfFile:_filePath];
            [self presentViewController:VC animated:YES completion:nil];
            
        }];
        
        
        
    }
    
}
#pragma mark- 缩放图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
