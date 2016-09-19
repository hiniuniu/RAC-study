//
//  ViewController.m
//  RAC1-3
//
//  Created by Meng Fan on 16/9/19.
//  Copyright © 2016年 Meng Fan. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACReturnSignal.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //七、RAC-bind绑定
    [self bindAction];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 7、bind
- (void)bindAction {
    //绑定的实现思路：拦截API从而可以对数据进行操作，，而影响返回数据。
    
    //1、创建信号
    RACSubject *subject = [RACSubject subject];
    //2、绑定信号
    RACSignal *bindSignal = [subject bind:^RACStreamBindBlock{
        // block调用时刻：只要绑定信号订阅就会调用。不做什么事情，
        return ^RACSignal *(id value, BOOL *stop) {
            // 一般在这个block中做事 ，发数据的时候会来到这个block。
            // 只要源信号（subject）发送数据，就会调用block
            // block作用：处理源信号内容
            // value:源信号发送的内容，
            
            NSLog(@"接收到原信号的内容：%@", value);
            
            value = @3;
            //返回信号，不能为nil,如果非要返回空---则empty或 alloc init。
            // 把返回的值包装成信号
            return [RACReturnSignal return:value];
        };
    }];
    
    //3、订阅绑定信号
    [bindSignal subscribeNext:^(id x) {
        NSLog(@"接收到处理完的信号：%@", x);
    }];
    
    //4、发送信号
    [subject sendNext:@"123"];
}

@end
