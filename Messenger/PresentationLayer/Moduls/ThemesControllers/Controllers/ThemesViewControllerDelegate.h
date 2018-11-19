//
//  ThemesViewControllerDelegate.h
//  Messenger
//
//  Created by Иван Базаров on 14.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ThemesViewController.h"


NS_ASSUME_NONNULL_BEGIN
@class ThemesViewController;
@protocol ThemesViewControllerDelegate <NSObject>

-(void)themesViewController:(ThemesViewController *)controller didSelectTheme:(UIColor *)selectedTheme;

@end

NS_ASSUME_NONNULL_END
