//
//  ThemesViewController.h
//  Messenger
//
//  Created by Иван Базаров on 14.10.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ThemesViewControllerDelegate.h"
#import "Themes.h"

    
@interface ThemesViewController : UIViewController

@property (nonatomic, weak) id<ThemesViewControllerDelegate> delegate;
@property (retain, nonatomic) Themes* model;
@property (retain, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

- (void)changeTheme:(UIColor *)color;
- (IBAction)someThemeTapped:(UIButton *)sender;
- (IBAction)dismissButtonTapped:(UIBarButtonItem *)sender;

@end

