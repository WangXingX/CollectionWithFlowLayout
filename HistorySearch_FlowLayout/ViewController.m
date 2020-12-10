//
//  ViewController.m
//  HistorySearch_FlowLayout
//
//  Created by 王星星 on 2020/11/30.
//

#import "ViewController.h"
#import "WX_TypeFlowLayout.h"
#import "WX_SearchCollectionViewCell.h"
#import "WXCollectionReusableView.h"
#define itemPadding 15                       // itemsize 的间距
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UIView *toolView;
@property (strong, nonatomic) UICollectionView *typeCollection;
//数据源
@property (strong, nonatomic) NSArray *projectArr;
//存储item高度信息
@property (strong, nonatomic) NSMutableArray *itemHeightArr;
//存选择信息
@property (strong, nonatomic) NSMutableArray *selectArr;

@end

@implementation ViewController

- (NSMutableArray *)itemHeightArr{
    if (!_itemHeightArr) {
        _itemHeightArr = [NSMutableArray array];
    }
    return _itemHeightArr;
}
- (NSMutableArray *)selectArr{
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor =  [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1];
    
    [self loadData];


    
    [self createTable];
}

- (void)loadData{
    self.projectArr = @[
        @{@"title":@"学科", @"value":@[@"全部",@"人力资源哈哈哈",@"高级营养管理师",@"我是测试数据用来测试换行的啊啊啊啊嗷嗷啊啊哈哈哈ahead",@"测试啊",@"23",@"高级",@"厉害",@"心理咨询师进阶",@"测试换行是否显示这个奶茶功能啊",@"我是多余的",@"还好"]},
        @{@"title":@"小类", @"value":@[@"全部",@"111",@"管理师"]},
        @{@"title":@"排序方式", @"value":@[@"综合",@"按热度",@"按价格"]}
    ];
    
    [self HeightForItem];
}

#pragma mark ******** 存储内容宽度（数据源预处理） ********
- (void)HeightForItem{
    [self.itemHeightArr removeAllObjects];
    [self.selectArr removeAllObjects];
    for (NSDictionary * tempDic in self.projectArr) {
        //存全部数据源的宽度
        NSMutableArray * allArray = [NSMutableArray array];
        //存展示部分数据源的宽度
        NSMutableArray * tempArray = [NSMutableArray array];
        //存储宽度
        NSMutableDictionary * newDic = [NSMutableDictionary dictionary];
        CGFloat allItemHeight = 0;
       
        NSMutableArray * selectState = [NSMutableArray array];
        NSInteger count = 0;
        for (NSString * typeStr in tempDic[@"value"]) {
           
            BOOL isOpen = NO;
            CGSize size = [typeStr boundingRectWithSize:CGSizeMake(1000, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15.0]} context:nil].size;
            
            allItemHeight  += (size.width + 30 + itemPadding);
            
            //仅显示3行数据，数据大于3行表示headview可以收缩，不能用height计算，因为一行可以显示多个item
            if (allItemHeight <= (self.view.frame.size.width - itemPadding) * 3) {
                isOpen = YES;
                 [tempArray addObject:@(size.width + 30)];
            }
            [allArray addObject:@(size.width + 30)];
            
            //isopen: 表示是否有可收缩的项 ， 当isopen = 0 时， currentOpenState 表示当前展开状态，默认不展开， 展开取oldArray， 不展开取oldArray ;  当isopen = 0 时 , newArray = oldArray
            [newDic addEntriesFromDictionary:@{@"isOpen":@(isOpen),@"currentOpenState":@"0",@"newArray":tempArray,@"oldArray":allArray}];
            
            if (count == 0) {
                [selectState addObject:@"1"];
            }else{
                [selectState addObject:@"0"];
            }
            count++;
        }
        
        [self.itemHeightArr addObject:newDic];
        [self.selectArr addObject:selectState];
    }
}



- (void)createTable{
    WX_TypeFlowLayout * flow = [[WX_TypeFlowLayout alloc]init];
    self.typeCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(itemPadding,  0 , self.view.frame.size.width - itemPadding,  self.view.frame.size.height ) collectionViewLayout:flow];
    self.typeCollection.delegate = self;
    self.typeCollection.dataSource = self;
    self.typeCollection.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.typeCollection];
    
    [self.typeCollection registerClass:[WX_SearchCollectionViewCell class] forCellWithReuseIdentifier:@"WX_SearchCollectionViewCell"];
    [self.typeCollection registerClass:[WXCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WXCollectionReusableView"];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.itemHeightArr.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
     NSDictionary * dic = self.itemHeightArr[section];
        if (dic.count > 0 ) {
            BOOL isOpen = [dic[@"isOpen"] boolValue];
            if (!isOpen) {
                  BOOL current = [dic[@"currentOpenState"] boolValue];
                 return current==0 ? [dic[@"newArray"] count]: [dic[@"oldArray"] count ];
                
            }else{
                NSArray * values = dic[@"oldArray"];
                return values.count;
            }
        }
        return 0;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WX_SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WX_SearchCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary * dic = self.projectArr[indexPath.section];
    
    if (dic) {
        NSArray * values = dic[@"value"];
        if (values.count > indexPath.row) {
            [cell loadDataToBtn:values[indexPath.row] isType:0];
        }
    }
    if (self.projectArr.count == self.selectArr.count) {
        NSArray * selectArray = self.selectArr[indexPath.section];
        if (selectArray.count > indexPath.row) {
            if ([selectArray[indexPath.row] intValue] == 0) {
                [cell.typeBtn setTitleColor:[UIColor darkGrayColor] forState:0];
             }else{
                [cell.typeBtn setTitleColor:[UIColor orangeColor] forState:0];
            }
        }
    }
    
    return cell;
}
#pragma mark --- UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = 10;
    NSDictionary * dic = self.itemHeightArr[indexPath.section];
       if (dic.count > 0 ) {
           BOOL isOpen = [dic[@"isOpen"] boolValue];
           if (!isOpen) {
                 BOOL current = [dic[@"currentOpenState"] boolValue];
               if (!current) {
                   NSArray * values = dic[@"newArray"];
                   width = [values[indexPath.row] doubleValue];
               }else{
                   NSArray * values = dic[@"oldArray"];
                   width = [values[indexPath.row] doubleValue];
               }
           }else{
               NSArray * values = dic[@"oldArray"];
                width = [values[indexPath.row] doubleValue];
           }
       }
    return CGSizeMake(width, 40);
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) { //header
        WXCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WXCollectionReusableView" forIndexPath:indexPath];
//        header.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
        NSDictionary * dic = self.projectArr[indexPath.section];
        NSDictionary * newDic = self.itemHeightArr[indexPath.section];
        if (dic && newDic) {
            NSString * title = dic[@"title"];
            //是否展开
            BOOL isOpen =  [newDic[@"isOpen"] boolValue];
            header.titleLabel.text = [NSString stringWithFormat:@"%@",title];           //NSStringFormat(@"%@", title);
           
            
            if (!isOpen) {
                 header.openBtn.hidden = NO;
                //收缩，可展开状态
                BOOL current = [newDic[@"currentOpenState"] boolValue];
                if (!current) {
                    [header.openBtn setImage:[UIImage imageNamed:@"spread-close"] forState:0];
                }else{
                    //展开可收缩状态
                    [header.openBtn setImage:[UIImage imageNamed:@"spread-line"] forState:0];
                }
                
                header.openBtn.tag = indexPath.section;
                [header.openBtn addTarget:self action:@selector(openOrClose:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                header.openBtn.hidden = YES;
            }
        }
        return header;
    }
    return nil;
}

#pragma mark ********  展开或者收缩 ********
- (void)openOrClose:(UIButton *)sender{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.itemHeightArr[sender.tag]];
    if (dic.count > 0 ) {
        BOOL isOpen = [dic[@"isOpen"] boolValue];
        if (!isOpen) {
            BOOL current = [dic[@"currentOpenState"] boolValue];
            dic[@"currentOpenState"] = [NSString stringWithFormat:@"%d",!current];
            self.itemHeightArr[sender.tag] = dic;
            [self.typeCollection reloadData];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.typeCollection.frame.size.width, 60);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.projectArr[indexPath.section];
    NSMutableArray * stateArrar = [NSMutableArray arrayWithArray:self.selectArr[indexPath.section]];
    if (dic && stateArrar.count > 0) {
        NSArray * array = dic[@"value"];
        if (array.count > indexPath.row) {
           
            for (NSInteger index=0; index<stateArrar.count; index ++) {
                stateArrar[index] = @"0";
            }
            
            stateArrar[indexPath.row] = @"1";
            self.selectArr[indexPath.section] = stateArrar;
          
             [collectionView reloadData];
        }
    }
   
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}
@end
