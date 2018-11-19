//
//  ThemesViewController.m
//  Messenger
//
//  Created by Иван Базаров on 14.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ThemesViewController.h"


@implementation ThemesViewController

- (Themes *)model {
    Themes *themeModel = [[Themes alloc] init];
    return [themeModel autorelease];
}

- (void)changeTheme:(UIColor *)color {
    self.view.backgroundColor = color;
    self.navigationController.navigationBar.backgroundColor = color;
    [_delegate themesViewController:self didSelectTheme:color];
    
}

- (IBAction)dismissButtonTapped:(UIBarButtonItem *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)someThemeTapped:(UIButton *)sender {
    UIColor* themeColor = [[Themes alloc] defaultColor];
    
    switch (sender.tag) {
        case 1:
            themeColor = [[Themes alloc] theme1];
            break;
        case 2:
            themeColor = [[Themes alloc] theme2];
            break;
        case 3:
            themeColor = [[Themes alloc] theme3];
            break;
        default:
            break;
    }
    [self changeTheme:themeColor];
    [themeColor release];
}



- (void)dealloc {
    [_model release];
    [_buttons release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UINavigationBar.appearance.backgroundColor;

}

@end

