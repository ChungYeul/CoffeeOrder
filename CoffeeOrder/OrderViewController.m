//
//  OrderViewController.m
//  CoffeeOrder
//
//  Created by SDT-1 on 2014. 1. 15..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "OrderViewController.h"

@interface OrderViewController ()<NSURLConnectionDataDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation OrderViewController {
    NSMutableData *_buffer;
    NSArray *_result;
}
- (IBAction)closeModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"https://api.parse.com/1/classes/Order"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url] ;
    [request addValue:@"T4JC47GMzVl5a19lIQokMxxE8Nx5WheSeptT8346" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [request addValue:@"2mvT9BGUhPDAOBhKEJbdE3UhWVnyBEhKmgiybXUt" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"count %d", _result.count);
    return _result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ORDER_CELL" forIndexPath:indexPath];
    NSDictionary *order = _result[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", order[@"coffee"]];
    cell.detailTextLabel.text = order[@"orderer"];
    return cell;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _buffer = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_buffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSUInteger option = kNilOptions;
    __autoreleasing NSError *error;
    // JSON 파싱:응답 데이터를 NSDictionary
    id result = [NSJSONSerialization JSONObjectWithData:_buffer options:option error:&error];
    NSLog(@"Result : %@", result);
    _result = result[@"results"];
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
