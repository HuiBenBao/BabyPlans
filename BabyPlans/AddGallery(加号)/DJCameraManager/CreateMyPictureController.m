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
#import "EditImageController.h"
#import "UploadViewController.h"

@interface CreateMyPictureController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,AddPicScrollViewDelegate,PhotoViewControllerDelegate,UITextViewDelegate,EditImageDelegate>

//选择相片后存储在沙盒中的完整路径
@property (nonatomic,strong) NSString * filePath;

@property (nonatomic,strong) AddPicScrollView * addPicView;

@property (nonatomic,strong) MyTextView * textView;

@property (nonatomic,strong) UIView * btnView;

@end


@implementation CreateMyPictureController


- (void)viewDidLoad{

    [super viewDidLoad];

    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.view = scrollView;
    
    self.navigationController.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.addPicView = [[AddPicScrollView alloc] initWithFrame:CGRectMake(0, KNavBarHeight, KScreenWidth, imageRadius + margic*2)];
    self.addPicView.backgroundColor = ViewBackColor;
    
    self.addPicView.picDelegate = self;
    
    [self.view addSubview:_addPicView];
    
    self.textView = [[MyTextView alloc] initWithFrame:CGRectMake(10, _addPicView.bottom+margic, KScreenWidth-20, 130*SCREEN_WIDTH_RATIO55)];
    
    self.textView.backgroundColor = ViewBackColor;
    self.textView.placeholderLabel.hidden = NO;
    _textView.delegate = self;
    [self.view addSubview:_textView];
    
    
    self.btnView = [[UIView alloc] init];
    self.btnView.frame = CGRectMake(0, _textView.bottom+margic*2, KScreenWidth, 50*SCREEN_WIDTH_RATIO55);
    [self.view addSubview:_btnView];
    
    NSArray * titleArr = @[@"发布",@"修改"];
    
    for (int i = 0; i < titleArr.count; i++) {
        
        UIButton * publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat margicX = 20*SCREEN_WIDTH_RATIO55;
        CGFloat btnW = (KScreenWidth - margicX*(titleArr.count+1))/(titleArr.count);
        CGFloat btnX = margicX + (margicX + btnW)*i;
        CGFloat btnH = _btnView.height;
        publishBtn.frame = CGRectMake(btnX, 0, btnW, btnH);
        
        publishBtn.layer.cornerRadius = 8*SCREEN_WIDTH_RATIO55;
        publishBtn.clipsToBounds = YES;
        [publishBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [publishBtn setTitleColor:ColorI(0xffffff) forState:UIControlStateNormal];
        publishBtn.backgroundColor = [UIColor orangeColor];
        
        if (i==0) {//点击发布
            [publishBtn addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==1){//点击修改
            [publishBtn addTarget:self action:@selector(editImage) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        [self.btnView addSubview:publishBtn];
        
        [self.view addTarget:self action:@selector(packUpKeyborad)];
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  返 回"style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonPress:)];
    
}
/**
 *  返回按钮点击方法
 */
-(void)leftDrawerButtonPress:(id)sender{
    
    int count = (int)self.addPicView.imageViewArr.count;
    
    if (count == 0) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提醒" message:@"返回后已录入的数据将无法保存，确认返回？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            //返回
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alertVC addAction:cancel];
        [alertVC addAction:sure];
        
        [self presentViewController:alertVC animated:YES completion:nil];
        
        
    }
    
    
    
}

/**
 *  发布按钮点击
 */
- (void)publishClick{

    if (self.addPicView.imageViewArr.count == 0) {
        [self.view poptips:@"图片不能为空"];
        
        return;
    }
    if ([self.textView.text trim].length == 0) {
        [self.view poptips:@"内容简介不能为空"];
        
        return;
    }
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"请添加一个标题" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"标题";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField * textFild = alertVC.textFields.firstObject;
        
        [self updateGalleryWithTitle:[textFild.text trim]];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        
    }];

    okAction.enabled = NO;
    
    [alertVC addAction:cancle];
    [alertVC addAction:okAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
    
}
/**
 *  上传绘本
 */
- (void)updateGalleryWithTitle:(NSString *)title{

    NSMutableArray * tempArr = [NSMutableArray array];

    int count = (int)self.addPicView.imageViewArr.count;
    for (int i = 0; i < count ; i++) {
        UIImageView * imgV = [_addPicView.imageViewArr objectAtIndex:i];
        
        if (imgV.tag > 0) {
            [tempArr addObject:@(imgV.tag)];
        }
    }
    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.dimBackground = YES;
    
    [CloudLogin publishContent:self.textView.text title:(NSString *)title type:_type ImgIDArr:tempArr Success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        
        hud.hidden = YES;
        [hud removeFromSuperview];
        
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
        
        hud.hidden = YES;
        [hud removeFromSuperview];
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"亲，网络好像不给力" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDestructive handler:nil];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self updateGalleryWithTitle:title];
        }];
        
        [alertVC addAction:okAction];
        [alertVC addAction:cancelAction];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }];

}

- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *titleTextField = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = [titleTextField.text trim].length > 0;
    }
}
/**
 *  修改按钮点击
 */
- (void)editImage{

    int count = (int)self.addPicView.imageViewArr.count;
    
    if (count == 0) {
        [self.view poptips:@"未上传图片"];
        
        return;
    }

    EditImageController * VC = [[EditImageController alloc] init];

    VC.delegate = self;
    VC.imageArr = self.addPicView.imageViewArr;
    
    [self presentViewController:VC animated:YES completion:nil];
    
}

#pragma ----mark----EditImageDelegate
- (void)reloadImageWithArr:(NSArray *)imageArr{

    
    if (self.addPicView.imageViewArr.count != imageArr.count) {
        
        for (int i = 0; i < self.addPicView.imageViewArr.count; i++) {
            UIImageView * imgV = self.addPicView.imageViewArr[i];
            
            if ([imageArr indexOfObject:imgV] == NSNotFound) {
                
                [self.addPicView removeImageViewWithTag:imgV.tag];
            }
            
        }
    }
    self.addPicView.imageViewArr = nil;
    self.addPicView.imageViewArr = [NSMutableArray arrayWithArray:imageArr];
    
    [self.addPicView setNeedsLayout];

}

#pragma ----mark-----UITextVIewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{

    if ([_textView.text trim].length<=0) {
        _textView.placeholderLabel.hidden = NO;
    }else{
        _textView.placeholderLabel.hidden = YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView{

    if ([_textView.text trim].length<=0) {
        _textView.placeholderLabel.hidden = NO;
    }else{
        _textView.placeholderLabel.hidden = YES;
    }
}
#pragma ------mark-----AddPicScrollViewDelegate

- (void)addPictureBtnClick{

    [self packUpKeyborad];
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
        picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }else{
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"NagavitionBarImg"] forBarMetrics:UIBarMetricsDefault];
    
    [picker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FONTBOLD_ADAPTED_WIDTH(21)}];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
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
    
    //更新addPicView的frame
    NSInteger count = self.addPicView.imageViewArr.count;
    
    CGFloat picViewH = margic + (count/ImgNumOnOneline + 1) * (imageRadius + margic);
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        CGRect picF = self.addPicView.frame;
        picF.size.height = picViewH;
        self.addPicView.frame = picF;
        
        CGRect textF = self.textView.frame;
        textF.origin.y = CGRectGetMaxY(picF) + margic;
        
        self.textView.frame = textF;
        
        CGRect btnF = self.btnView.frame;
        btnF.origin.y = CGRectGetMaxY(self.textView.frame) + margic*2;
        
        self.btnView.frame = btnF;
        
        UIScrollView * scrollV = (UIScrollView *)self.view;
        scrollV.contentSize = CGSizeMake(KScreenWidth, self.btnView.bottom + margic);
        
        [self.view setNeedsLayout];
    });
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
