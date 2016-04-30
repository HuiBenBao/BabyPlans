//
//  CreateMyPictureController.m
//  BabyPlans
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CreateMyPictureController.h"
#import "AddPicScrollView.h"
#import "PhotoViewController.h"
#import "MyTextView.h"

@interface CreateMyPictureController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,AddPicScrollViewDelegate,PhotoViewControllerDelegate,UITextViewDelegate>

//选择相片后存储在沙盒中的完整路径
@property (nonatomic,strong) NSString * filePath;

@property (nonatomic,strong) AddPicScrollView * addPicView;

@property (nonatomic,strong) MyTextView * textView;

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
    
    self.textView = [[MyTextView alloc] initWithFrame:CGRectMake(10, _addPicView.bottom+10, KScreenWidth-20, 150*SCREEN_WIDTH_RATIO55)];
    
    self.textView.backgroundColor = ViewBackColor;
    _textView.delegate = self;
    [self.view addSubview:_textView];
    
    UIButton * publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    publishBtn.frame = CGRectMake(20, _textView.bottom+30*SCREEN_WIDTH_RATIO55, KScreenWidth-40, 50*SCREEN_WIDTH_RATIO55);
    
    publishBtn.layer.cornerRadius = 8*SCREEN_WIDTH_RATIO55;
    publishBtn.clipsToBounds = YES;
    [publishBtn setTitle:@"发布" forState:UIControlStateNormal];
    [publishBtn setTitleColor:ColorI(0xffffff) forState:UIControlStateNormal];
    publishBtn.backgroundColor = [UIColor orangeColor];
    
    [publishBtn addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:publishBtn];
    
    [self.view addTarget:self action:@selector(packUpKeyborad)];
}
/**
 *  发布按钮点击
 */
- (void)publishClick{

    NSMutableArray * tempArr = [NSMutableArray array];
    
    int count = (int)self.addPicView.imageViewArr.count;
    for (int i = count-1; i >=0 ; i--) {
        UIImageView * imgV = [_addPicView.imageViewArr objectAtIndex:i];
        
        if (imgV.tag > 0) {
            [tempArr addObject:@(imgV.tag)];
        }
    }
    
    [CloudLogin publishContent:self.textView.text type:_type ImgIDArr:tempArr Success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        
        int status = [responseObject[@"status"] intValue];
        
        if (status==0) {
            
            UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"上传成功，请耐心等待审核" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];

            
            [alertCtrl addAction:cancelAction];
            [self presentViewController:alertCtrl animated:YES completion:nil];
            
        }else{
        
            [self.view poptips:responseObject[@"error"]];
        }
    } failure:^(NSError *errorMessage) {
        [self.view poptips:@"网络异常"];
    }];
}
#pragma ----mark-----UITextVIewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{

    _textView.placeholderLabel.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView{

    if ([_textView.text trim].length<=0) {
        _textView.placeholderLabel.hidden = NO;
    }
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
        picker.allowsEditing = NO;
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
            VC.delegate = self;
            
            [self presentViewController:VC animated:YES completion:nil];
            
        }];
        
        
        
    }
    
}
#pragma ----mark------PhotoViewControllerDelegate
- (void)updateImgID:(NSString *)imgID image:(UIImage *)image{

    [self.addPicView addPicture:image imgID:imgID];
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

#pragma ----mark-----点击空白处收起键盘
- (void)packUpKeyborad{

    [self.textView resignFirstResponder];
}
@end
