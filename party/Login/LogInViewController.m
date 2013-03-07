//
//  LogInViewController.m
//  party
//
//  Created by yilinlin on 13-1-29.
//
//

#import "LogInViewController.h"
#import "WelcomViewController.h"
#import "login.h"
#import "resign.h"
#import "write_done.h"
#import "write_infor.h"
#import "takePhoto.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CheckOneViewController.h"
#define kDuration 0.2  // 动画持续时间(秒)

@interface LogInViewController ()

@end

@implementation LogInViewController
@synthesize dictory;
@synthesize mail,mail_pass,user_pic,user_nick,user_age,user_sex;
@synthesize dateToolbar;
@synthesize resignView,loginView,infodoneView,infowriteView;
@synthesize photoView;
@synthesize imageView1;
@synthesize imageView;
@synthesize imageView2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        flogFriend=0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //********************************日期选择器*******************************************
    datepicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [datepicker setLocale: [[NSLocale alloc] initWithLocaleIdentifier: @"zh_CN"]];//设置时间选择器语言环境为中文
    datepicker.datePickerMode=UIDatePickerModeDate;
    datepicker.maximumDate = [NSDate date];
    [self.view addSubview:datepicker];
    mutableArray=[[NSMutableArray alloc]initWithCapacity:100];
    if (self.dateToolbar == nil) {
        self.dateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 38.0f)];
        self.dateToolbar.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(AreapickerHide)];
        UIBarButtonItem *spaceBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                      target:nil action:nil];
        
        UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(resignAreaboard:)];
        
        [self.dateToolbar setItems:[NSArray arrayWithObjects:cancelBtn,spaceBarItem,doneBarItem, nil]];
        [doneBarItem release];
        [cancelBtn release];
        [spaceBarItem release];
    }
    //********************************日期选择器end****************************************
    
    //********************************背景图片*******************************************
    self.imageView1=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320*mainwith, 460*mainhight)]autorelease];
    self.imageView1.image=[UIImage imageNamed:@"backgroundLogin@2x.png"];
    self.imageView1.alpha=1;
    [self.view addSubview:self.imageView1];
    //********************************背景图片 end*******************************************
    
    //********************************背景图片*******************************************
    self.imageView2=[[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320*mainwith, 460*mainhight)]autorelease];
    self.imageView2.image=[UIImage imageNamed:@"register@2x.png"];
    self.imageView2.alpha=1;
    [self.view addSubview:self.imageView2];
    //********************************背景图片 end*******************************************
    
    //********************************logo图片*******************************************
    self.imageView=[[[UIImageView alloc]initWithFrame:CGRectMake(125, mainscreenhight/2, 65, 65)]autorelease];
    self.imageView.image=[UIImage imageNamed:@"logo@2x.png"];
    self.imageView.backgroundColor=[UIColor clearColor];
    timer=[NSTimer scheduledTimerWithTimeInterval:0.006 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    [self.view addSubview:self.imageView];
    //********************************logo图片 end*******************************************
}

-(void) onTimer {
    
    imageView.frame=CGRectMake(125, 250-move, 65, 65);
    move++;
    int y=imageView.frame.origin.y;
    
    if (y==15||y<15) {
        [self loadingDate];
        [timer invalidate];//计时器停止运行
    }
}

-(void)loadingDate{
    //*****************************注册View*************************************
    self.resignView=[[[resign alloc]initWithFrame:CGRectMake(20*mainwith, 90*mainhight, 280*mainwith, mainscreenhight-90)]autorelease];
    self.resignView.field1.delegate=self;
    self.resignView.field2.delegate=self;
    [self.resignView.button1 addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    [self.resignView.button2 addTarget:self action:@selector(weibologin) forControlEvents:UIControlEventTouchUpInside];
    numberSum=3;
    [self.view addSubview:self.resignView];
    //*****************************注册View end*************************************
}

//将注册信息传给服务器
-(void)loadDate{
    numberSum=0;

    NSURL* url=[NSURL URLWithString:@"http://www.ycombo.com/che/servlet/reg"];
    
    ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
    
    NSLog(@"mail==%@",self.mail);
    NSLog(@"mail.pass====%@",self.mail_pass);
    NSLog(@"self.user_nick====%@",self.user_nick);
    NSLog(@"self.user_sex====%@",self.user_sex);
    NSLog(@"self.user_pic====%@",self.user_pic);
    NSLog(@"self.user_age====%@",self.user_age);
    
    NSMutableString* filename=[[NSMutableString alloc]init];
    [filename appendFormat:@"a___%@",self.mail];
    [filename appendFormat:@"b___%@",self.mail_pass];
    [filename appendFormat:@"c___%@",self.user_nick];
    [filename appendFormat:@"d___%@",self.user_age];
    [filename appendFormat:@"e___%@f___.jpg",self.user_sex];
    
    UIImage* image=self.user_pic;
    NSData *imageData=UIImageJPEGRepresentation(image, 0.1);
    //压缩
    [rrequest  addData:imageData withFileName:filename andContentType:@"image/jpeg" forKey:@"user_pic"];
    [rrequest setDelegate:self];
    [rrequest startAsynchronous];
     NSLog(@"filename===%@",filename);
    [filename release];
    
    //=========将用户的UUid放入本地=============================================
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"Get document path: %@",[paths objectAtIndex:0]);
    NSString *fileNameFile=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"Guo.txt"];
    NSMutableArray *uuidMutablearray=[NSMutableArray arrayWithObjects:self.mail, self.mail_pass,nil];
    NSLog(@"sadafdasfas%@",uuidMutablearray);
    [uuidMutablearray writeToFile:fileNameFile atomically:YES];
    
}

//从服务器获取数据
-(void)requestFinished:(ASIHTTPRequest *)request
{
    if (numberSum==0) {//注册完成之后调用
        NSData* response=[request responseData];
        //NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",bizDic);
        self.dictory=bizDic;
        //=========将用户的UUid放入本地=============================================
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSLog(@"Get document path: %@",[paths objectAtIndex:0]);
        NSString *fileName=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"myFile.txt"];
        NSString *content=[bizDic objectForKey:@"uuid"];
        NSLog(@"wosds%@",content);
        NSMutableArray *uuidMutablearray=[NSMutableArray arrayWithObject:content];
        NSLog(@"sadafdasfas%@",uuidMutablearray);
        [uuidMutablearray writeToFile:fileName atomically:YES];
        
        //=========将用户的UUid放入本地=============================================
        NSArray *pathsG=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSLog(@"Get document path: %@",[pathsG objectAtIndex:0]);
        NSString *fileNameG=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"Guo.txt"];
        NSMutableArray *uuidMutablearrayG=[NSMutableArray arrayWithObjects:self.mail, self.mail_pass,nil];
        NSLog(@"sadafdasfas%@",uuidMutablearrayG);
        [uuidMutablearrayG writeToFile:fileNameG atomically:YES];
        if (flogFriend==1) {
            FriendViewView *friend=[[FriendViewView alloc]initWithFrame:CGRectMake(0, 0, 320*mainwith, 460*mainhight)];
            [friend.buttonCancel addTarget:self action:@selector(goToMainView) forControlEvents:UIControlEventTouchUpInside];
            [friend.buttonAffirm addTarget:self action:@selector(goToMainView) forControlEvents:UIControlEventTouchUpInside];
            [self.view insertSubview:friend atIndex:18];
            [friend release];

        }

        
    }
    else if (numberSum==1) {
        [sinaWeibo logOut];
        NSData* response=[request responseData];
        NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"wwwwwwwwwwwwwwqqqqqqqqqqtttttttttt%@",bizDic);
        NSDictionary *dict=[bizDic objectForKey:@"sina_user"];
        NSURL *url=[NSURL URLWithString:[dict objectForKey:@"avatarLarge"]];
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        NSLog(@"输出照片：%@",image);
        NSString *sex=[dict objectForKey:@"gender"];
        NSLog(@"输出性别：%@",sex);
        NSString *stringName=[dict objectForKey:@"name"];
        NSLog(@"输出用户名：%@",stringName);
        NSString *stringUuid=[bizDic objectForKey:@"uuid"];
        
        NSString *stringExist=[bizDic objectForKey:@"status"];
        NSLog(@"用户是否存在%@",stringExist);
        if ([stringExist intValue]==200) {
            self.infodoneView=[[[write_done alloc]initWithFrame:CGRectMake(0, 0, 320*mainwith, 460*mainhight)]autorelease];
            self.infodoneView.backgroundColor=[UIColor grayColor];
            self.infodoneView.imgView.image=image;
            self.infodoneView.field1.text=stringName;
            self.infodoneView.field1.delegate=self;
            self.infodoneView.field2.delegate=self;
            self.infodoneView.field2.inputView=datepicker;
            self.infodoneView.field2.inputAccessoryView=dateToolbar;
            [self.infodoneView.button1 addTarget:self action:@selector(male) forControlEvents:UIControlEventTouchUpInside];
            [self.infodoneView.button2 addTarget:self action:@selector(female) forControlEvents:UIControlEventTouchUpInside];

            [self.infodoneView.button3 addTarget:self action:@selector(doneWon) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.infodoneView];
            //=========将用户的UUid放入本地=============================================
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSLog(@"Get document path: %@",[paths objectAtIndex:0]);
            NSString *fileName=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"myFile.txt"];
            NSString *content=stringUuid;
            NSLog(@"wosds%@",content);
            NSMutableArray *uuidMutablearray=[NSMutableArray arrayWithObject:content];
            NSLog(@"sadafdasfas%@",uuidMutablearray);
            [uuidMutablearray writeToFile:fileName atomically:YES];
            //=====================================
            NSArray *pathsG=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSLog(@"Get document path: %@",[pathsG objectAtIndex:0]);
            NSString *fileNameG=[[pathsG objectAtIndex:0] stringByAppendingPathComponent:@"Guo.txt"];
            NSMutableArray *uuidMutablearrayG=[NSMutableArray arrayWithObjects:@"新浪用户", @"新浪密码",nil];
            NSLog(@"sadafdasfas%@",uuidMutablearrayG);
            [uuidMutablearrayG writeToFile:fileNameG atomically:YES];
        }
        else if ([stringExist intValue]==300) {
            UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [soundAlert show];
            [soundAlert release];
            //=========将用户的UUid放入本地=============================================
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSLog(@"Get document path: %@",[paths objectAtIndex:0]);
            NSString *fileName=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"myFile.txt"];
            NSString *content=stringUuid;
            NSLog(@"wosds%@",content);
            NSMutableArray *uuidMutablearray=[NSMutableArray arrayWithObject:content];
            NSLog(@"sadafdasfas%@",uuidMutablearray);
            [uuidMutablearray writeToFile:fileName atomically:YES];
            //=====================================
            NSArray *pathsG=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSLog(@"Get document path: %@",[pathsG objectAtIndex:0]);
            NSString *fileNameG=[[pathsG objectAtIndex:0] stringByAppendingPathComponent:@"Guo.txt"];
            NSMutableArray *uuidMutablearrayG=[NSMutableArray arrayWithObjects:@"新浪用户", @"新浪密码",nil];
            NSLog(@"sadafdasfas%@",uuidMutablearrayG);
            [uuidMutablearrayG writeToFile:fileNameG atomically:YES];
            [self.view removeFromSuperview];
        }else{
            //=========将用户的UUid放入本地=============================================
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSLog(@"Get document path: %@",[paths objectAtIndex:0]);
            NSString *fileName=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"myFile.txt"];
            NSString *content=stringUuid;
            NSLog(@"wosds%@",content);
            NSMutableArray *uuidMutablearray=[NSMutableArray arrayWithObject:content];
            NSLog(@"sadafdasfas%@",uuidMutablearray);
            [uuidMutablearray writeToFile:fileName atomically:YES];
            
            //=====================================
            NSArray *pathsG=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSLog(@"Get document path: %@",[pathsG objectAtIndex:0]);
            NSString *fileNameG=[[pathsG objectAtIndex:0] stringByAppendingPathComponent:@"Guo.txt"];
            NSMutableArray *uuidMutablearrayG=[NSMutableArray arrayWithObjects:@"新浪用户名", @"新浪密码",nil];
            NSLog(@"sadafdasfas%@",uuidMutablearrayG);
            [uuidMutablearrayG writeToFile:fileNameG atomically:YES];
        }
        
        
        NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir=[path objectAtIndex:0];
        //NSFileManager *fm=[NSFileManager defaultManager];
        NSString *imagePath=[docDir stringByAppendingPathComponent:@"myFile.txt"];
        NSMutableArray *stringmutable=[NSMutableArray arrayWithContentsOfFile:imagePath];
        NSString *stringUUID=[stringmutable objectAtIndex:0];
        NSLog(@"wwwwwwwwwwwwwwwwwwww%@",stringUUID);
    }
    else if (numberSum==3) {//初始登录界面调用
        
        NSData* response=[request responseData];
        //NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",bizDic);
        self.dictory=bizDic;
        if ([[self.dictory objectForKey:@"status"] intValue]==300) {
            UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"邮箱已存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [soundAlert show];
            [soundAlert release];
        }
        else if((self.mail==nil)||(self.mail_pass==nil)){
            UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写完整信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [soundAlert show];
            [soundAlert release];
        }
        else if([[self.dictory objectForKey:@"status"] intValue]==400){
            UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写正确邮箱格式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [soundAlert show];
            [soundAlert release];
        }
        else{
            [self.imageView removeFromSuperview];
            [self.resignView removeFromSuperview];
            self.photoView=[[[takePhoto alloc]initWithFrame:CGRectMake(0, 0, 320*mainwith, 460*mainhight)]autorelease];
            [self choosePhoto];
            [self.imageView2 removeFromSuperview];
            self.imageView1.image=[UIImage imageNamed:@"background@2x.png"];
            self.photoView.imgView.userInteractionEnabled=YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePhoto)];
            [self.photoView.imgView addGestureRecognizer:singleTap];
            [singleTap release];
            [self.photoView.button1 addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            [self.photoView.button2 addTarget:self action:@selector(affirm) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.photoView];
        }
        
    }
    else if (numberSum==4) {//初始注册界面调用
        NSData* response=[request responseData];
        //NSLog(@"%@",response);
        NSError* error;
        NSDictionary* bizDic=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"wwwwwwwwwwwwqqqqqqqqqqqqqq%@",bizDic);
        self.dictory=bizDic;
        NSLog(@"self.mail_pass=%@",self.mail_pass);
        NSLog(@"self.mail_pass====%@",[self.dictory objectForKey:@"mail_pass"]);
        if ([self.dictory objectForKey:@""]) {
            UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户不存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [soundAlert show];
            [soundAlert release];
        }
        else if(self.mail==nil||self.mail_pass==nil){
            UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写完整信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [soundAlert show];
            [soundAlert release];
        }
        else if([[self.dictory objectForKey:@"status"] intValue]==400){
            UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写正确格式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [soundAlert show];
            [soundAlert release];
        }
        else{
            if ([[self.dictory objectForKey:@"mail_pass"] isEqualToString:self.mail_pass]) {
                
                //=========将用户的UUid放入本地=============================================
                NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSLog(@"Get document path: %@",[paths objectAtIndex:0]);
                NSString *fileName=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"Guo.txt"];
                NSMutableArray *uuidMutablearray=[NSMutableArray arrayWithObjects:self.mail, self.mail_pass,nil];
                NSLog(@"sadafdasfas%@",uuidMutablearray);
                [uuidMutablearray writeToFile:fileName atomically:YES];
                [self.view removeFromSuperview];
                
                NSArray *pathsp=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSLog(@"Get document path: %@",[paths objectAtIndex:0]);
                NSString *fileNamep=[[pathsp objectAtIndex:0] stringByAppendingPathComponent:@"myFile.txt"];
                NSString *content=[dictory objectForKey:@"uuid"];
                NSLog(@"wosds%@",content);
                NSMutableArray *uuidMutablearrayp=[NSMutableArray arrayWithObject:content];
                NSLog(@"sadafdasfas%@",uuidMutablearray);
                [uuidMutablearrayp writeToFile:fileNamep atomically:YES];
                
            }
            else{
                UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [soundAlert show];
                [soundAlert release];
                //[self.view removeFromSuperview];
            }
        }
    
    }
}
-(void)resignDate{
    numberSum=3;
    NSURL* url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/user/IF00034"];
    ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
    [rrequest setPostValue:self.mail forKey: @"mail"];
    [rrequest setDelegate:self];
    [rrequest startAsynchronous];
}

-(void)loginDate{
    numberSum=4;
    NSURL* url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/user/IF00035"];
    ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
    [rrequest setPostValue:self.mail forKey: @"mail"];
    NSLog(@"%@",self.mail);
    [rrequest setDelegate:self];
    [rrequest startAsynchronous];
}

-(void)doneWon{
    numberSum=0;
    [self.infodoneView.field2 endEditing:YES];
    self.user_age=self.infodoneView.field2.text;
    NSLog(@"wwwwwwwww%@",self.user_age);
    NSLog(@"qqqqqqqqqq%@",self.user_sex);
    if (self.user_sex==nil) {
        self.user_sex=@"M";
    }
    if((self.user_sex==nil)||(self.user_age==nil)){
        UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写完整信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [soundAlert show];
        [soundAlert release];
    }
    else{
        NSURL* url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/user/IF00040"];
        ASIFormDataRequest *rrequest =[ASIFormDataRequest  requestWithURL:url];
        NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir=[path objectAtIndex:0];
        //NSFileManager *fm=[NSFileManager defaultManager];
        NSString *imagePath=[docDir stringByAppendingPathComponent:@"myFile.txt"];
        NSMutableArray *stringmutable=[NSMutableArray arrayWithContentsOfFile:imagePath];
        NSString *stringUUID=[stringmutable objectAtIndex:0];
        NSLog(@"wwwwwwwwwwwwwwwwwwww%@",stringUUID);
        //
        [rrequest setPostValue:stringUUID forKey:@"uuid"];
        [rrequest setPostValue:self.user_age forKey:@"user_age"];
        [rrequest setPostValue:self.user_sex forKey:@"user_sex"];
        [rrequest startSynchronous];
        
        
        FriendViewView *friend=[[FriendViewView alloc]initWithFrame:CGRectMake(0, 0, 320*mainwith, 460*mainhight)];
        [friend.buttonCancel addTarget:self action:@selector(goToMainView) forControlEvents:UIControlEventTouchUpInside];
        [friend.buttonAffirm addTarget:self action:@selector(goToMainView) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:friend atIndex:6];
        [friend release];

    }
}

-(void)change{
    //*****************************注册登录界面相互跳转****************************************
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    NSUInteger green = [[self.view subviews] indexOfObject:self.imageView1];
    NSUInteger blue = [[self.view subviews] indexOfObject:self.imageView2];
    [self.view exchangeSubviewAtIndex:green withSubviewAtIndex:blue];
    [[self.view layer] addAnimation:animation forKey:@"animation"];
    
    if ([self.resignView superview]!=nil) {
        numberSum=4;
        [self.resignView removeFromSuperview];
        //[self.view insertSubview:self.loginView atIndex:0];
        self.loginView=[[[login alloc]initWithFrame:CGRectMake(20*mainwith, 90*mainhight, 280*mainwith, mainscreenhight-90)]autorelease];
        self.loginView.field1.delegate=self;
        self.loginView.field2.delegate=self;
        [self.loginView.button1 addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
        [self.loginView.button2 addTarget:self action:@selector(weibologin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.loginView];
        [self.loginView.field1 becomeFirstResponder];
    }
    else{
        numberSum=3;
        [self.loginView removeFromSuperview];
        //[self.view insertSubview:self.resignView atIndex:0];
        [self.view addSubview:self.resignView];
        [self.resignView.field1 becomeFirstResponder];
        self.resignView.field1.delegate=self;
        self.resignView.field2.delegate=self;
    }
    //*****************************注册登录界面相互跳转 end****************************************
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (numberSum==1) {
         [self.view removeFromSuperview];
    }
    
    if (numberSum==3) {
        [self.resignView.field1 endEditing:YES];
        [self.resignView.field2 endEditing:YES];
        [self resignDate];
    }
    if (numberSum==4) {
        [self.loginView.field1 endEditing:YES];
        [self.loginView.field2 endEditing:YES];
        [self.loginView endEditing:YES];
        [self loginDate];
    }
    return YES;
}

-(void)weibologin
{
    sinaWeibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        sinaWeibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        sinaWeibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        sinaWeibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
    [sinaWeibo logIn];
    sinaWeibo.delegate=self;
}

-(void)affirm{
    
    [self.photoView removeFromSuperview];
    
    self.infowriteView=[[[write_infor alloc]initWithFrame:CGRectMake(0, 0, 320*mainwith, 460*mainhight)]autorelease];
    numberSum=0;
    self.infowriteView.field1.delegate=self;
    self.infowriteView.field2.delegate=self;
    self.infowriteView.field2.inputView=datepicker;
    self.infowriteView.field2.inputAccessoryView=dateToolbar;
    
    [self.infowriteView.button4 addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.infowriteView.button1 addTarget:self action:@selector(male) forControlEvents:UIControlEventTouchUpInside];
    [self.infowriteView.button2 addTarget:self action:@selector(female) forControlEvents:UIControlEventTouchUpInside];
    [self.infowriteView.button3 addTarget:self action:@selector(countersign) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.infowriteView];
}
-(void)male{
    self.user_sex=@"M";
}
-(void)female{
    self.user_sex=@"F";
}

- (void)AreapickerHide
{
    [self.infowriteView.field2 endEditing:YES];
    [self.infodoneView.field2 endEditing:YES];
}
-(void)countersign
{
    [infowriteView.field1 endEditing:YES];
    [infowriteView.field2 endEditing:YES];
    if (self.user_sex==nil) {
        self.user_sex=@"M";
    }
    if(self.user_sex==nil||self.user_age==nil||self.user_nick==nil){
        UIAlertView *soundAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写完整信息" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [soundAlert show];
        [soundAlert release];
    }
    else{
        [self loadDate];
        
        flogFriend=1;
        }
}
-(void)goToMainView
{
    WelcomViewController* welcom=[[WelcomViewController alloc]init];
    welcom.view.frame=CGRectMake(0, -20, 320, mainscreenhight);
    [self.view addSubview:welcom.view];
}

-(void)resignAreaboard:(id)sender {
    NSDate *myDate = [NSDate date];//获取系统时间
    NSLog(@"myDate = %@",myDate);
    NSDate* date2=datepicker.date;//时间选择器的时间
    
    //计算两个事件之间的时间差，可以用来计算年龄
    NSCalendar *userCalendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit;
    NSDateComponents *components = [userCalendar components:unitFlags fromDate:date2 toDate:myDate options:0];
    int years = [components year];
    NSLog(@"%d",years);
    
    self.infowriteView.field2.text=[NSString stringWithFormat:@"%d",years];
    [self.infowriteView.field2 endEditing:YES];
    
    self.infodoneView.field2.text=[NSString stringWithFormat:@"%d",years];
    [self.infodoneView.field2 endEditing:YES];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up

{
    const float movementDuration = 0.3f; // tweak as needed
    int movement=0;
    if (up) {
        movement=-100;
    }
    else
    {
        movement=100;
    }
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
    
}

-(void)back{
    
    if ([self.photoView superview]!=nil) {
        [self.view addSubview:self.imageView2];
        self.imageView1.image=[UIImage imageNamed:@"backgroundLogin@2x.png"];
        [self.photoView removeFromSuperview];
        [self.view addSubview:self.imageView];
        [self.view addSubview:self.resignView];
        self.resignView.field1.delegate=self;
        self.resignView.field2.delegate=self;
        [self.resignView.field1 becomeFirstResponder];
        numberSum=3;
    }
    else if([self.infowriteView superview]!=nil){
        [self.infowriteView removeFromSuperview];
        self.infodoneView.field1.delegate=self;
        self.infodoneView.field2.delegate=self;
        [self.view addSubview:self.photoView];
    }
    
}

#pragma mark - UIActionSheetDelegate
//*************************************调用相册*******************************************
-(void)choosePhoto{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"相册"
                                  otherButtonTitles:@"拍照",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    [actionSheet release];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 1:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 0:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    } else {
        if (buttonIndex == 1||buttonIndex==2) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
	//[self presentModalViewController:imagePickerController animated:YES];
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	//[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
	self.photoView.photoImg = [info objectForKey:UIImagePickerControllerEditedImage];
	//[imageButton setImage:picture forState:UIControlStateNormal];
    self.photoView.imgView.image=self.photoView.photoImg;
    self.user_pic=self.photoView.imgView.image;
    NSLog(@"%@",self.user_pic);
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	//[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//*************************************调用相册 end*******************************************

#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    numberSum=1;
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    NSLog(@"1111111111111111111111111111");
    //numberSum=[sinaWeibo.userID integerValue];
    NSURL *url=[NSURL URLWithString:@"http://www.ycombo.com/che/mac/sina/SIF00000"];
    ASIFormDataRequest *rrequest =  [ASIFormDataRequest  requestWithURL:url];
    [rrequest setPostValue:sinaWeibo.userID forKey: @"suid"];
    
    [rrequest setDelegate:self];
    [rrequest startAsynchronous];
    //=================新浪微博登陆成功进入下个界面=======================================
    //    SinaGetViewController *sinaGetView=[[SinaGetViewController alloc]init];
    //    //[self.navigationController pushViewController:sinaGetView animated:YES];
    //    [self.view addSubview:sinaGetView.view];
    
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    
    
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
    //====================新浪微博登陆不成功返回==================================================
    
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
     [self removeAuthData];
}
- (void)removeAuthData
{
    NSLog(@"removeAuthData");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}
#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    
    
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    
    if([request.url hasSuffix:@"friendships/friends/bilateral.json"])
    {
        //
        //NSDictionary *dic=
        
        mutableArray=[result objectForKey:@"users"];
        //nameArray=[mutableArray objectAtIndex:2];
        //dicMu=[mutableArray objectForKey:@"statuses_count"];
        NSLog(@"%@",result);
        NSDictionary *dic=[mutableArray objectAtIndex:0];
        NSLog(@"rrrrrrrrrrrrr%@",[dic objectForKey:@"name"]);
        
        
        
        
    }
    if ([request.url hasSuffix:@"users/show.json"])
    {
        NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:result];
        number=[result objectForKey:@"id"];
               //NSNumber *a=[mutableArray objectAtIndex:0];
        currentAuthNameLabel.text = [NSString stringWithFormat:@"当前账号：%@", [userInfo objectForKey:@"id"]];
        
    }
}



-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (numberSum==3) {
        self.mail=self.resignView.field1.text;
        self.mail_pass=self.resignView.field2.text;
        numberSum=3;
    }
    if(numberSum==4){
        self.mail=self.loginView.field1.text;
        self.mail_pass=self.loginView.field2.text;
        numberSum=4;
    }
    if (numberSum==0) {
        self.user_nick=self.infowriteView.field1.text;
        self.user_age=self.infowriteView.field2.text;
    }
}


-(void)dealloc{
    [super dealloc];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
