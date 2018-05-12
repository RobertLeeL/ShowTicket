//
//  STSearchNavBarView.m
//  ShowTicket
//
//  Created by 李龙跃 on 2018/5/12.
//  Copyright © 2018年 Longyue Li. All rights reserved.
//

#import "STSearchNavBarView.h"
#import "common_define.h"
#import "UIColor+Hex.h"

@interface STSearchNavBarView ()<UISearchBarDelegate>

@end

@implementation STSearchNavBarView

- (instancetype)initWithFrame:(CGRect)frame
               beginEditBlock:(SearchBarShouldBeginEditingBlock)editBlock
             clickSearchBlock:(SearchBarSearchButtonClickedBlock)searchBlock {
    self = [super initWithFrame:frame];
    if (self) {
        self.beginEditBlock = editBlock;
        self.searchBlock = searchBlock;
        [self creatView];
    }
    return self;
}

- (void)creatView {
    
    [self addSubview:self.searchBar];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat cancleBtnHeight = 17;
    cancelBtn.frame = CGRectMake(CGRectGetMaxX(self.searchBar.frame) + 31/2, 20 + (44-cancleBtnHeight)/2, 45, cancleBtnHeight);
    [cancelBtn addTarget:self action:@selector(backToSuperView) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorHex(0x646464) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:cancelBtn];
}

- (void)backToSuperView {
    if (self.clickCancelBlock) {
        self.clickCancelBlock();
    }
}
#pragma mark -- SearchBarDelegate
//如果是联想词搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (self.tfdDidChangedBlock) {
        self.openAssociativeSearch = YES;
        self.tfdDidChangedBlock(searchText);
    }
}
//点击清除按钮 || 呼出键盘
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if ([searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        if (self.beginEditBlock) {
            self.beginEditBlock(searchBar);
        }
    }
    return YES;
}
//点击搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) return;
    
    [searchBar resignFirstResponder];
    
    if (self.searchBlock) {
        self.searchBlock(searchBar);
    }
}

#pragma mark -- LazyLoad

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        CGFloat searchBarHeight = 30;
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 20 + (44-searchBarHeight)/2, SCREEN_WIDTH - 80, searchBarHeight)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入搜索名称";
        _searchBar.layer.cornerRadius = 5;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.backgroundImage = [self imageWithColor:kSearchBarTFDColor];
//        _searchBar.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3"];
        //放大镜
        UIImage *leftImage = [UIImage imageNamed:@"searchBar_left_icon"];
        [_searchBar setImage:leftImage forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        //清除按钮
        UIImage *clearImage = [UIImage imageNamed:@"searchBar_right_clear_icon"];
        [_searchBar setImage:clearImage forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
        
        
        UITextField *searchField = [self getSearchTextField:_searchBar];
        searchField.enablesReturnKeyAutomatically = YES;
        [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        [searchField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
        searchField.backgroundColor = kSearchBarTFDColor;
        searchField.textColor = [UIColor whiteColor];
        
    }
    return _searchBar;
}

- (UITextField *)getSearchTextField:(UISearchBar *)searchBar
{
    return [searchBar valueForKey:@"_searchField"];;
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
