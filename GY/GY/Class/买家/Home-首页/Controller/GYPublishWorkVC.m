//
//  GYPublishWorkVC.m
//  GY
//
//  Created by 夏增明 on 2019/10/16.
//  Copyright © 2019 夏增明. All rights reserved.
//

#import "GYPublishWorkVC.h"
#import "HXPlaceholderTextView.h"
#import "GYWorkCategoryView.h"
#import <zhPopupController.h>
#import "FSActionSheet.h"
#import "zhAlertView.h"
#import "WSDatePickerView.h"
#import "GYDatePickerView.h"
#import <ZLPhotoActionSheet.h>
#import "GYEvaluatePhotoCell.h"
#import <ZLCollectionViewVerticalLayout.h>
#import "ZJPickerView.h"
#import "GYWorkType.h"
#import <AFNetworking.h>
#import "GYMyNeedsVC.h"

static NSString *const EvaluatePhotoCell = @"EvaluatePhotoCell";
@interface GYPublishWorkVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ZLCollectionViewBaseFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UITextField *task_title;
@property (weak, nonatomic) IBOutlet UITextField *task_type;
@property (weak, nonatomic) IBOutlet UITextField *task_price;
@property (weak, nonatomic) IBOutlet UITextField *task_date;
@property (weak, nonatomic) IBOutlet UITextField *task_time;
@property (weak, nonatomic) IBOutlet UITextField *task_city;
@property (weak, nonatomic) IBOutlet UITextField *task_address;
@property (weak, nonatomic) IBOutlet HXPlaceholderTextView *task_content;
@property (weak, nonatomic) IBOutlet UITextField *contact_name;
@property (weak, nonatomic) IBOutlet UITextField *contact_phone;
@property (weak, nonatomic) IBOutlet UIImageView *task_img;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
/** 已选择的数组 */
@property (nonatomic,strong) NSMutableArray *selectedAssets;
/** 已选择的数组 */
@property (nonatomic,strong) NSMutableArray *selectedPhotos;
/** 是否原图 */
@property (nonatomic, assign) BOOL isOriginal;
/** 是否选择了9张 */
@property (nonatomic, assign) BOOL isSelect9;
/** 模型数组 */
@property (nonatomic,strong) NSMutableArray *showData;
/** 是否多选 */
@property(nonatomic,assign) BOOL isMultiple;
/* 技术工种 */
@property(nonatomic,strong) NSArray *workTypes;
/* 选择工种视图 */
@property(nonatomic,strong) GYWorkCategoryView *workTypeView;
/** 类别id,逗号分割 */
@property(nonatomic,copy) NSString *type_ids;
/** city_id 服务地区，城市id 第二级的area_id */
@property(nonatomic,copy) NSString *city_id;
/** 封面图地址 */
@property(nonatomic,copy) NSString *task_imgUrl;
@end

@implementation GYPublishWorkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"发单"];
    [self getWorkTypesRequest];
    
    self.task_content.placeholder = @"请输入需求描述";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImgTaped:)];
    [self.task_img addGestureRecognizer:tap];
    
    [self setUpCollectionView];
    
    hx_weakify(self);
    [self.publishBtn BindingBtnJudgeBlock:^BOOL{
        hx_strongify(weakSelf);
        if (![strongSelf.task_title hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写标题"];
            return NO;
        }
        if (![strongSelf.task_type hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择类别"];
            return NO;
        }
        if (![strongSelf.task_price hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写价格"];
            return NO;
        }
        if (![strongSelf.task_date hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择日期"];
            return NO;
        }
        if (![strongSelf.task_time hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择时间段"];
            return NO;
        }
        if (![strongSelf.task_city hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择地区"];
            return NO;
        }
        if (![strongSelf.task_address hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写详细地址"];
            return NO;
        }
        if (![strongSelf.task_content hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请填写需求描述"];
            return NO;
        }
        if (!strongSelf.task_imgUrl || !strongSelf.task_imgUrl.length) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请上传封面图"];
            return NO;
        }
        if (strongSelf.showData.count == 1) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请选择上传详情图"];
            return NO;
        }
        if (![strongSelf.contact_name hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入姓名"];
            return NO;
        }
        if (![strongSelf.contact_phone hasText]) {
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:@"请输入电话"];
            return NO;
        }
        return YES;
    } ActionBlock:^(UIButton * _Nullable button) {
        hx_strongify(weakSelf);
        [strongSelf submitBtnClicked:button];
    }];
}
-(NSMutableArray *)showData
{
    if (_showData == nil) {
        _showData = [NSMutableArray array];
        [_showData addObject:HXGetImage(@"选择照片")];
    }
    return _showData;
}
-(GYWorkCategoryView *)workTypeView
{
    if (_workTypeView == nil) {
        _workTypeView = [GYWorkCategoryView loadXibView];
        _workTypeView.hxn_size = CGSizeMake(HX_SCREEN_WIDTH-30*2, 260);
    }
    return _workTypeView;
}
- (ZLPhotoActionSheet *)getPas
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    /**
     导航条颜色
     */
    actionSheet.configuration.navBarColor = HXControlBg;
    actionSheet.configuration.bottomViewBgColor = HXControlBg;
    actionSheet.configuration.indexLabelBgColor = HXControlBg;
    // -- optional
    //以下参数为自定义参数，均可不设置，有默认值
    /**
     是否升序排列，预览界面不受该参数影响，默认升序 YES
     */
    actionSheet.configuration.sortAscending = NO;
    /**
     是否允许相册内部拍照 ，设置相册内部显示拍照按钮 默认YES
     */
    actionSheet.configuration.allowTakePhotoInLibrary = YES;
    /**
     是否在相册内部拍照按钮上面实时显示相机俘获的影像 默认 YES
     */
    actionSheet.configuration.showCaptureImageOnTakePhotoBtn = NO;
    /**
     是否允许滑动选择 默认 YES （预览界面不受该参数影响）
     */
    actionSheet.configuration.allowSlideSelect = YES;
    /**
     编辑图片后是否保存编辑后的图片至相册，默认YES
     */
    actionSheet.configuration.saveNewImageAfterEdit = NO;
    
    /**
     回调时候是否允许框架解析图片，默认YES
如果选择了大量图片，框架一下解析大量图片会耗费一些内存，开发者此时可置为NO，拿到assets数组后自行解析，该值为NO时，回调的图片数组为nil
     */
    actionSheet.configuration.shouldAnialysisAsset = YES;
    
    /**
     是否允许选择照片 默认YES (为NO只能选择视频)
     */
    actionSheet.configuration.allowSelectImage = YES;
    /**
     是否允许选择视频 默认YES
     */
    actionSheet.configuration.allowSelectVideo = NO;
    /**
     是否允许选择Gif，只是控制是否选择，并不控制是否显示，如果为NO，则不显示gif标识 默认YES （此属性与是否允许选择照片相关联，如果可以允许选择照片那就会展示gif[前提是照片中存在gif]）
     */
    actionSheet.configuration.allowSelectGif = NO;
    /**
     是否允许编辑图片，选择一张时候才允许编辑，默认YES
     */
    actionSheet.configuration.allowEditImage = YES;
    /**
     是否允许录制视频(当useSystemCamera为YES时无效)，默认YES
     */
    actionSheet.configuration.allowRecordVideo = NO;
    /**
     设置照片最大选择数 默认10张
     */
    actionSheet.configuration.maxSelectCount = self.isMultiple?9:1;
    
    // -- required
    /**
     必要参数！required！ 如果调用的方法没有传sender，则该属性必须提前赋值
     */
    actionSheet.sender = self;
    /**
     已选择的图片数组
     */
    actionSheet.arrSelectedAssets = self.isMultiple?self.selectedAssets:[NSMutableArray array];
    /**
     选择照片回调，回调解析好的图片、对应的asset对象、是否原图
     pod 2.2.6版本之后 统一通过selectImageBlock回调
     */
    @zl_weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        @zl_strongify(self);
        if (self.isMultiple) {
            [self.showData removeAllObjects];
            [self.showData addObjectsFromArray:images];
            if (self.showData.count != 9) {
                [self.showData addObject:HXGetImage(@"选择照片")];
                self.isSelect9 = NO;
            }else{
                self.isSelect9 = YES;
            }
            
            self.selectedAssets = assets.mutableCopy;
            self.isOriginal = isOriginal;
            self.selectedPhotos = images.mutableCopy;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.photoCollectionView reloadData];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.photoViewHeight.constant = self.photoCollectionView.contentSize.height;
                });
            });
        }else{
            [self upImageRequestWithImage:@[images.firstObject] completedCall:^(NSString *imageUrl, NSString *imagePath) {
                self.task_imgUrl = imageUrl;
                [self.task_img sd_setImageWithURL:[NSURL URLWithString:imagePath]];
            }];
        }
    }];
    return actionSheet;
}
-(void)setUpCollectionView
{
    // 针对 11.0 以上的iOS系统进行处理
    if (@available(iOS 11.0, *)) {
        self.photoCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    } else {
        // 针对 11.0 以下的iOS系统进行处理
        // 不要自动调整inset
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    ZLCollectionViewVerticalLayout *flowLayout = [[ZLCollectionViewVerticalLayout alloc] init];
    flowLayout.delegate = self;
    flowLayout.canDrag = NO;
    flowLayout.header_suspension = NO;
    self.photoCollectionView.collectionViewLayout = flowLayout;
    self.photoCollectionView.dataSource = self;
    self.photoCollectionView.delegate = self;
    
    [self.photoCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYEvaluatePhotoCell class]) bundle:nil] forCellWithReuseIdentifier:EvaluatePhotoCell];
}
#pragma mark -- 点击事件
-(void)submitBtnClicked:(UIButton *)btn
{
    hx_weakify(self);
    if (self.isSelect9) {
        [self runUpLoadImages:self.showData completedCall:^(NSMutableArray *result) {
            hx_strongify(weakSelf);
            [strongSelf submitTaskRequest:btn imageUrls:result];
        }];
    }else{
        NSMutableArray *tempImgs = [NSMutableArray arrayWithArray:self.showData];
        [tempImgs removeLastObject];
        [self runUpLoadImages:tempImgs completedCall:^(NSMutableArray *result) {
            hx_strongify(weakSelf);
            [strongSelf submitTaskRequest:btn imageUrls:result];
        }];
    }
}
-(void)chooseImgTaped:(UITapGestureRecognizer *)tap
{
    self.isMultiple = NO;
    [[self getPas] showPhotoLibrary];
}
- (IBAction)chooseCategoryClicked:(UIButton *)sender {
    
    self.workTypeView.workTypes = self.workTypes;
    hx_weakify(self);
    self.workTypeView.workCateCall = ^(NSInteger index) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        if (index == 1) {
            NSMutableString *workTypeStr = [NSMutableString string];
            NSMutableString *workTypeIdStr = [NSMutableString string];
            for (GYWorkType *workType in strongSelf.workTypes) {
                if (workType.isSelected) {
                    if (workTypeStr.length) {
                        [workTypeStr appendFormat:@",%@",workType.set_val];
                        [workTypeIdStr appendFormat:@",%@",workType.set_id];
                    }else{
                        [workTypeStr appendFormat:@"%@",workType.set_val];
                        [workTypeIdStr appendFormat:@"%@",workType.set_id];
                    }
                }
            }
            strongSelf.task_type.text = workTypeStr;
            strongSelf.type_ids = workTypeIdStr;
        }
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeCenter;
    [self.zh_popupController presentContentView:self.workTypeView duration:0.25 springAnimated:NO];
}
- (IBAction)chooseDateClicked:(UIButton *)sender {
    //年-月-日
    hx_weakify(self);
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
        hx_strongify(weakSelf);
        NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd"];
        strongSelf.task_date.text = dateString;
    }];
    datepicker.dateLabelColor = HXControlBg;//年-月-日 颜色
    datepicker.datePickerColor = [UIColor blackColor];//滚轮日期颜色
    datepicker.doneButtonColor = HXControlBg;//确定按钮的颜色
    [datepicker show];
}
- (IBAction)chooseTimeClicked:(UIButton *)sender {
    GYDatePickerView *vc = [GYDatePickerView loadXibView];
    vc.hxn_size = CGSizeMake(HX_SCREEN_WIDTH, 280);
    hx_weakify(self);
    vc.action = ^(NSDate * _Nonnull startDate, NSDate * _Nonnull endDate) {
        hx_strongify(weakSelf);
        [strongSelf.zh_popupController dismissWithDuration:0.25 springAnimated:NO];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *startDateStr = [dateFormatter stringFromDate:startDate];
        NSString *endtDateStr = [dateFormatter stringFromDate:endDate];
       
        strongSelf.task_time.text = [NSString stringWithFormat:@"%@-%@",startDateStr, endtDateStr];
    };
    self.zh_popupController = [[zhPopupController alloc] init];
    self.zh_popupController.layoutType = zhPopupLayoutTypeBottom;
    [self.zh_popupController presentContentView:vc duration:0.25 springAnimated:NO];
}
- (IBAction)districtClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
    NSString *districtStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    if (districtStr == nil) {
        return ;
    }
    NSData *jsonData = [districtStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *district = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableArray *realArr = [NSMutableArray array];
    for (NSDictionary *Pro in (NSArray *)district[@"result"][@"list"]) {
        NSArray *sub = (NSArray *)Pro[@"city"];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *subPro in sub) {
            NSMutableArray *tempArr1 = [NSMutableArray array];
            for (NSDictionary *trdPro in subPro[@"area"]) {
                [tempArr1 addObject:trdPro[@"alias"]];
            }
            [tempArr addObject:@{subPro[@"alias"]:tempArr1}];
        }
        [realArr addObject:@{Pro[@"alias"] : tempArr}];
    }
    [self showPickerViewWithDataList:realArr];
}
#pragma mark 显示选择控制器
- (void)showPickerViewWithDataList:(NSArray *)dataList
{
    // 1.Custom propery（自定义属性）
    NSDictionary *propertyDict = @{
                                   ZJPickerViewPropertyCanceBtnTitleKey : @"取消",
                                   ZJPickerViewPropertySureBtnTitleKey  : @"确定",
                                   ZJPickerViewPropertyTipLabelTextKey  : @"选择地区", // 提示内容
                                   ZJPickerViewPropertyCanceBtnTitleColorKey : UIColorFromRGB(0xA9A9A9),
                                   ZJPickerViewPropertySureBtnTitleColorKey : UIColorFromRGB(0x232323),
                                   ZJPickerViewPropertyTipLabelTextColorKey :
                                       UIColorFromRGB(0x131D2D),
                                   ZJPickerViewPropertyLineViewBackgroundColorKey : UIColorFromRGB(0xdedede),
                                   ZJPickerViewPropertyCanceBtnTitleFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertySureBtnTitleFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertyTipLabelTextFontKey : [UIFont systemFontOfSize:15.0f],
                                   ZJPickerViewPropertyPickerViewHeightKey : @260.0f,
                                   ZJPickerViewPropertyOneComponentRowHeightKey : @40.0f,
                                   ZJPickerViewPropertySelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0x131D2D), NSFontAttributeName : [UIFont systemFontOfSize:20.0f]},
                                   ZJPickerViewPropertyUnSelectRowTitleAttrKey : @{NSForegroundColorAttributeName : UIColorFromRGB(0xA9A9A9), NSFontAttributeName : [UIFont systemFontOfSize:20.0f]},
                                   ZJPickerViewPropertySelectRowLineBackgroundColorKey : UIColorFromRGB(0xdedede),
                                   ZJPickerViewPropertyIsTouchBackgroundHideKey : @YES,
                                   ZJPickerViewPropertyIsShowSelectContentKey : @YES,
                                   ZJPickerViewPropertyIsScrollToSelectedRowKey: @YES,
                                   ZJPickerViewPropertyIsAnimationShowKey : @YES};
    
    // 2.Show（显示）
    hx_weakify(self);
    [ZJPickerView zj_showWithDataList:dataList propertyDict:propertyDict completion:^(NSString *selectContent) {
        hx_strongify(weakSelf);
        // show select content|
        NSArray *results = [selectContent componentsSeparatedByString:@"|"];
        //        NSArray *selectStrings = [selectContent componentsSeparatedByString:@","];
        NSMutableString *selectStringCollection = [[NSMutableString alloc] init];
        [[results.firstObject componentsSeparatedByString:@","] enumerateObjectsUsingBlock:^(NSString *selectString, NSUInteger idx, BOOL * _Nonnull stop) {
            if (selectString.length && ![selectString isEqualToString:@""]) {
                [selectStringCollection appendString:selectString];
            }
        }];
        strongSelf.task_city.text = selectStringCollection;

        NSString *path = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"json"];
        NSString *districtStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];

        if (districtStr == nil) {
            return ;
        }
        NSData *jsonData = [districtStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *district = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSArray *rows = [results.lastObject componentsSeparatedByString:@","];
        if (((NSArray *)district[@"result"][@"list"][[rows[0] integerValue]][@"city"]).count) {
            strongSelf.city_id = district[@"result"][@"list"][[rows[0] integerValue]][@"city"][[rows[1] integerValue]][@"id"];
        }
    }];
}
#pragma mark -- 接口
-(void)getWorkTypesRequest
{
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"getWorkTypeData" parameters:@{} success:^(id responseObject) {
        hx_strongify(weakSelf);
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            strongSelf.workTypes = [NSArray yy_modelArrayWithClass:[GYWorkType class] json:responseObject[@"data"]];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
-(void)submitTaskRequest:(UIButton *)btn imageUrls:(NSArray *)imageUrls
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"task_title"] = self.task_title.text;//需求标题
    parameters[@"type_ids"] = self.type_ids;//任务类别id，就是多个工种选择，逗号分隔
    parameters[@"task_type"] = self.task_type.text;//任务类别，就是多个工种选择，逗号分隔
    parameters[@"task_price"] = self.task_price.text;//价格，即服务费
    parameters[@"task_date"] = self.task_date.text;//服务日期
    parameters[@"task_time"] = self.task_time.text;//服务时间，如：17:00 - 17:30
    parameters[@"city_id"] = self.city_id;//服务地区，城市id 第二级的area_id
    parameters[@"address"] = self.task_address.text;//详情地址
    parameters[@"task_content"] = self.task_content.text;//需求描述
    parameters[@"task_img"] = self.task_imgUrl;//任务图片
    parameters[@"task_imgs"] = [imageUrls componentsJoinedByString:@","];//详情图片
    parameters[@"contact_name"] = self.contact_name.text;//需求方姓名
    parameters[@"contact_phone"] = self.contact_phone.text;//需求方手机
    
    hx_weakify(self);
    [HXNetworkTool POST:HXRC_M_URL action:@"pubTask" parameters:parameters success:^(id responseObject) {
        hx_strongify(weakSelf);
        [btn stopLoading:@"发布" image:nil textColor:nil backgroundColor:nil];
        if([[responseObject objectForKey:@"status"] integerValue] == 1) {
            GYMyNeedsVC *nvc = [GYMyNeedsVC new];
            nvc.isPublishPush = YES;
            [strongSelf.navigationController pushViewController:nvc animated:YES];
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:[responseObject objectForKey:@"message"]];
        }
    } failure:^(NSError *error) {
        [btn stopLoading:@"发布" image:nil textColor:nil backgroundColor:nil];
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
// 上传单张图
-(void)upImageRequestWithImage:(NSArray *)images completedCall:(void(^)(NSString * imageUrl,NSString * imagePath))completedCall
{
    [HXNetworkTool uploadImagesWithURL:HXRC_M_URL action:@"uploadFile" parameters:@{} name:@"file" images:images fileNames:nil imageScale:0.8 imageType:@"png" progress:nil success:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            completedCall(responseObject[@"data"][@"path"],responseObject[@"data"][@"imgPath"]);
        }else{
            [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:error.localizedDescription];
    }];
}
/**
 *  图片批量上传方法
 */
- (void)runUpLoadImages:(NSArray *)imageArr completedCall:(void(^)(NSMutableArray* result))completedCall{
    // 需要上传的图片数据imageArr
    
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray* result = [NSMutableArray array];
    for (int i=0;i<imageArr.count;i++) {
        [result addObject:[NSNull null]];
    }
    // 生成一个请求组
    dispatch_group_t group = dispatch_group_create();
    for (NSInteger i = 0; i < imageArr.count; i++) {
        dispatch_group_enter(group);
        NSURLSessionUploadTask *uploadTask = [self uploadTaskWithImage:imageArr[i] completion:^(NSURLResponse *response, NSDictionary* responseObject, NSError *error) {
            if (error) {
                // CBLog(@"第 %d 张图片上传失败: %@", (int)i + 1, error);
                dispatch_group_leave(group);
            } else {
                //CBLog(@"第 %d 张图片上传成功: %@", (int)i + 1, responseObject);
                @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                    if ([responseObject[@"status"] boolValue]){
                        // 将上传完成返回的图片链接存入数组
                        result[i] = responseObject[@"data"][@"path"];
                    }else{
                        [MBProgressHUD showTitleToView:nil postion:NHHUDPostionCenten title:responseObject[@"message"]];
                    }
                }
                dispatch_group_leave(group);
            }
        }];
        [uploadTask resume];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //HXLog(@"上传完成!");
        if (completedCall) {
            completedCall(result);//将图片链接数组传入
        }
    });
}

/**
 *  生成图片批量上传的上传请求方法
 *
 *  @param image           上传的图片
 *  @param completionBlock 包装成的请求回调
 *
 *  @return 上传请求
 */

- (NSURLSessionUploadTask*)uploadTaskWithImage:(UIImage*)image completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock {
    // 构造 NSURLRequest
    NSError* error = NULL;
    
    AFHTTPSessionManager *HTTPmanager = [AFHTTPSessionManager manager];
    //    HTTPmanager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", nil];
    NSMutableURLRequest *request = [HTTPmanager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@uploadFile",HXRC_M_URL]  parameters:@{} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //把本地的图片转换为NSData类型的数据
        NSData* imageData = UIImageJPEGRepresentation(image, 0.8);
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"file.png" mimeType:@"image/png"];
    } error:&error];
    
    // 可在此处配置验证信息
    // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:completionBlock];
    
    return uploadTask;
}
#pragma mark -- UICollectionView 数据源和代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.showData.count;
}
- (ZLLayoutType)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout *)collectionViewLayout typeOfLayout:(NSInteger)section
{
    return ClosedLayout;
}
//如果是ClosedLayout样式的section，必须实现该代理，指定列数
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(ZLCollectionViewBaseFlowLayout*)collectionViewLayout columnCountOfSection:(NSInteger)section
{
    return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GYEvaluatePhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:EvaluatePhotoCell forIndexPath:indexPath];
    cell.photoImg.image = self.showData[indexPath.item];
    //    if (self.isSelect9) {
    //        cell.delBtn.hidden = NO;
    //    }else{
    //        if (indexPath.row == self.showData.count - 1) {//最后一个
    //            cell.delBtn.hidden = YES;
    //        }else{
    //            cell.delBtn.hidden = NO;
    //        }
    //    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isSelect9) {
        [[self getPas] previewSelectedPhotos:self.selectedPhotos assets:self.selectedAssets index:indexPath.row isOriginal:self.isOriginal];
    }else{
        if (indexPath.row == self.showData.count - 1) {//最后一个
            self.isMultiple = YES;
            [[self getPas] showPhotoLibrary];
        }else{
            [[self getPas] previewSelectedPhotos:self.selectedPhotos assets:self.selectedAssets index:indexPath.row isOriginal:self.isOriginal];
        }
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (collectionView.hxn_width-10*3.f)/3.0;
    CGFloat height = width;
    return CGSizeMake(width, height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.f;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return  UIEdgeInsetsMake(5, 0, 10, 10);
}

@end
