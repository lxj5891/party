//
//  login.m
//  resign
//
//  Created by mac bookpro on 1/26/13.
//  Copyright (c) 2013 mac bookpro. All rights reserved.
//

#import "login.h"

@implementation login
@synthesize field1,field2,button1,button2,button,mail,pass;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //*****************************注册或登录*************************************
        field1=[[[UITextField alloc]initWithFrame:CGRectMake(44, 0, 223, 40.5)]autorelease];
        field1.placeholder=@"登录邮箱";
        field1.font=[UIFont systemFontOfSize:14];
        field1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        field1.delegate = self;
        
        UITextField *mailFiled=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 267, 40.5)];
        mailFiled.backgroundColor=[UIColor clearColor];
        mailFiled.userInteractionEnabled=NO;
        mailFiled.background = [UIImage imageNamed:@"user@2x.png"];
        [self addSubview:mailFiled];
        [mailFiled release];
        
        [self addSubview:self.field1];
        //*****************************注册或登录 end*************************************
        
        //*****************************密码*************************************
        field2=[[[UITextField alloc]initWithFrame:CGRectMake(44, 52, 223, 40.5)]autorelease];
        field2.placeholder=@"密码";
        field2.font=[UIFont systemFontOfSize:14];
        field2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        field2.secureTextEntry = YES;
        //self.field2.backgroundColor=[UIColor redColor];
        field2.delegate = self;
        field2.returnKeyType = UIReturnKeyGo;
        
        UITextField *mailFiled1=[[UITextField alloc]initWithFrame:CGRectMake(0, 52, 267, 40.5)];
        mailFiled1.backgroundColor=[UIColor clearColor];
        mailFiled1.userInteractionEnabled=NO;
        mailFiled1.background = [UIImage imageNamed:@"pass@2x.png"];
        [self addSubview:mailFiled1];
        [mailFiled1 release];
        
        [self addSubview:self.field2];
        //*****************************密码 end*************************************
        
        //*******************************忘了按钮*********************************
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame=CGRectMake(166, -2, 60, 44);
        self.button.backgroundColor=[UIColor clearColor];
        [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.button setTitle:@"忘了" forState:UIControlStateNormal];
        self.button.titleLabel.font=[UIFont systemFontOfSize:14];
        [self.field2 addSubview:self.button];
        //*******************************忘了按钮*********************************
        
        //*****************************账号转换按钮*************************************
        self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button1.frame=CGRectMake(0, 100, 90, 25);
        self.button1.backgroundColor=[UIColor clearColor];
        [self.button1 setBackgroundImage:[UIImage imageNamed:@"zhece@2x.png"] forState:UIControlStateNormal];
        [self addSubview:self.button1];
        //*****************************账号转换按钮 end*************************************
        
        //*****************************新浪图标*************************************
        self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button2.frame=CGRectMake(225, 97, 33, 24.5);
        [self.button2 setBackgroundImage:[UIImage imageNamed:@"sina@2x.png"] forState:UIControlStateNormal];
        [self.button2 setBackgroundImage:[UIImage imageNamed:@"sinaing@2x.png"] forState:UIControlEventTouchUpInside];
        [self addSubview:self.button2];
        //*****************************新浪图标 end*************************************
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
}
//#pragma keyboard
//#pragma textFielddelegate
//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    self.pass=self.field2.text;
//    self.mail=self.field1.text;
//}

@end
