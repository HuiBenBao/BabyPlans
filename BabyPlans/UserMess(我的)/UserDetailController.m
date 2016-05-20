//
//  UserDetailController.m
//  BabyPlans
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserDetailController.h"

#define iconCellHeight 120*SCREEN_WIDTH_RATIO55
#define generalCellHeight 60*SCREEN_WIDTH_RATIO55
#define footerHeight 120*SCREEN_WIDTH_RATIO55

@interface UserDetailController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UserMessModel * userModel;

@property (nonatomic,weak) UIImageView * iconView;

@property (nonatomic,weak) UITextField * textField;

@property (nonatomic,strong) UIImage * iconImg;


@end

@implementation UserDetailController
+ (instancetype)userDetailWithModel:(UserMessModel *)model{

    UserDetailController * detailVC = [[UserDetailController alloc] init];
 
    detailVC.userModel = model;
    
    return detailVC;
}

- (void)viewDidLoad{

    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return (indexPath.row==0) ?  iconCellHeight: generalCellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return footerHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView * footer = [[UIView alloc] init];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat btnX = 30*SCREEN_WIDTH_RATIO55;
    btn.frame = CGRectMake(btnX, footerHeight/2, KScreenWidth-btnX*2, footerHeight/2);
    
    [btn setTitle:@"上传" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn setTitleColor:ColorI(0xffffff) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(updateMess) forControlEvents:UIControlEventTouchUpInside];
    
    btn.layer.cornerRadius = 8*SCREEN_WIDTH_RATIO55;
    btn.clipsToBounds = YES;
    
    [footer addSubview:btn];
    footer.backgroundColor = [UIColor clearColor];
    
    return footer;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * ident = @"UserDetailCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
    }
    
    CGFloat cellHeight = generalCellHeight;
    if (indexPath.row==0) {
        
        cell.textLabel.text = @"头像";
        
        cellHeight = iconCellHeight;
        
        CGFloat imgY = 10*SCREEN_WIDTH_RATIO55;
        CGFloat imgH = iconCellHeight - imgY*2;
        CGFloat imgW = imgH;
        
        UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(iconCellHeight, imgY, imgW, imgH)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:self.userModel.iconStr] placeholderImage:[UIImage imageNamed:@"defaultIconImg"]];
        
        imageV.layer.cornerRadius = imgH/2;
        imageV.clipsToBounds = YES;
        [imageV addTarget:self action:@selector(iconClick)];
        
        self.iconView = imageV;
        
        [cell.contentView addSubview:imageV];
        
    }else{
        switch (indexPath.row) {
            case 1:{
                
                cell.textLabel.text = @"昵称";
                
                UITextField * detailLbl = [[UITextField alloc] initWithFrame:CGRectMake(iconCellHeight, 1, KScreenWidth-iconCellHeight, generalCellHeight-2)];
                detailLbl.text = [defaults valueForKey:UserNickName];
                
                detailLbl.textColor = ColorI(0x5b5b5b);
                detailLbl.font = FONT_ADAPTED_NUM(15);
                
                
                detailLbl.inputAccessoryView = [self getKeyBoardView];
                self.textField = detailLbl;
                
                [cell.contentView addSubview:detailLbl];
            }
            break;
        default:
            break;
        }
    }
    
    //分割线
    [cell.contentView buildBgView:ColorI(0xdddddd) frame:CGRectMake(0, cellHeight-1, KScreenWidth, 1)];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
/**
 *  添加键盘上方按钮
 */
- (UIView *)getKeyBoardView{

    UIView *keyBoardTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44*SCREEN_WIDTH_RATIO55)];
    
    keyBoardTopView.backgroundColor = [UIColor colorWithRed:200/255.0 green:203/255.0 blue:210/255.0 alpha:0.8];
    
    UIButton * finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(KScreenWidth-50*SCREEN_WIDTH_RATIO55 ,0, 40*SCREEN_WIDTH_RATIO55, 44*SCREEN_WIDTH_RATIO55);
    
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    finishBtn.titleLabel.font = FONTBOLD_ADAPTED_WIDTH(18);
    [finishBtn setTitleColor:[UIColor colorWithRed:17/255.0 green:102/255.0 blue:254/255.0 alpha:1] forState:UIControlStateNormal];
    
    [finishBtn addTarget:self action:@selector(updateNikeName) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.frame = CGRectMake(15*SCREEN_WIDTH_RATIO55, 0, 40*SCREEN_WIDTH_RATIO55, keyBoardTopView.frame.size.height);
    [clickBtn setTitle:@"取消" forState:UIControlStateNormal];
    [clickBtn setTitleColor:[UIColor colorWithRed:17/255.0 green:102/255.0 blue:254/255.0 alpha:1] forState:UIControlStateNormal];
    
    [clickBtn addTarget:self action:@selector(onKeyBoardDown) forControlEvents:UIControlEventTouchUpInside];
    
    [keyBoardTopView addSubview:finishBtn];
    [keyBoardTopView addSubview:clickBtn];

    return keyBoardTopView;
}
/**
 *  点击取消隐藏键盘,并将昵称还原
 */
- (void)onKeyBoardDown{

    [self.textField resignFirstResponder];
    self.textField.text = [defaults valueForKey:UserNickName];
}
/**
 *  点击完成，隐藏键盘
 */
- (void)updateNikeName{

    [self.textField resignFirstResponder];
}
/**
 *  上传信息
 */
- (void)updateMess{

    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.dimBackground = YES;
    
    [CloudLogin changeIcon:_iconImg nikeName:[self.textField.text trim] birthday:nil sex:nil Success:^(NSDictionary *responseObject) {
        
        NSLog(@"%@",responseObject);
        
        hud.hidden = YES;
        [hud removeFromSuperview];

        int status = [responseObject[@"status"] intValue];
        
        if (status==0) {
            [self.view poptips:@"修改成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });

        }else{
            
            [self.view poptips:responseObject[@"error" ]];
        }
    } failure:^(NSError *errorMessage) {
        hud.hidden = YES;
        [hud removeFromSuperview];
        [self.view poptips:@"网络异常"];
    }];

}
/**
 *  图像点击方法
 */
- (void)iconClick{
    
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
    
    [photoMenuSheet showInView:self.tableView];
    
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
        
        if (IOS8) {
            picker.modalPresentationStyle=UIModalPresentationOverCurrentContext;

        }
        
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
    if (IOS8) {
        picker.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        
    }
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
        UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
        
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
//        NSString * filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            
            UIImage * img = [UIImage imageWithData:data];
            self.iconView.image = img;
            self.iconImg = img;
            
            
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
/**
 *  用户点击取消按钮时调用
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
