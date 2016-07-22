//
//  MusicListVC.m
//  BLELight
//
//  Created by even on 16/1/2.
//  Copyright © 2016年 Aiden. All rights reserved.
//

#import "MusicListVC.h"
#import "MusicsTool.h"
#import "Music.h"
#import "AudioTool.h"
#import "UIView+Frame.h"
#import "UIViewController+TabBarVCDismiss.h"
#import "NSTimer+Add.h"
#import "UIAlertView+MKBlockAdditions.h"
#import "FFTTool.h"

@interface MusicListVC ()<EZAudioPlayerDelegate,EZAudioFFTDelegate>

@property (weak, nonatomic) IBOutlet UIView *colorContentView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic, strong) Music *playingMusic;

@property (nonatomic, strong) EZAudioPlayer *player;
@property (nonatomic, strong) NSTimer *progressTimer;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property (nonatomic, strong) EZAudioFFTRolling *fft;

@property (weak, nonatomic) IBOutlet UILabel *currentTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *sevenColorLbl;
@property (weak, nonatomic) UIButton *selectedColorBtn;


@property (assign, nonatomic) BOOL needResumePlayWhenAlarmEndPlay; // 是否在铃声播放结束后继续播放音乐
@property (assign, nonatomic) NSInteger currentVolumeGrade;// 当前音量的等级 1-5  ,0为没有开始播放
@property (assign, nonatomic) CGFloat currentVolume;
@property (strong, nonatomic) NSDate *sendDate; // 记录上一次发送音乐数据的时间
@property (strong, nonatomic) NSDate *changeColorDate; // 记录上一次音乐变换颜色的时间

@property (assign, nonatomic) BOOL needResumePlayWhenSliderDragged; //记录当用户拖动进度条后，是否需要恢复播放


@end

@implementation MusicListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addColorBtns];

    [self.slider setThumbImage:[UIImage imageNamed:@"dot_red"] forState:UIControlStateNormal];
    
    if([MusicsTool playingMusic]) {
        self.playingMusic = [MusicsTool playingMusic];
    }
    
    self.view.backgroundColor = kGlbBgColor;
    [self updateLanguage];
    [self addDissmissBtnToLeftBarBtnItem];
    
    [kNotificationCenter addObserver:self selector:@selector(alarmStartPlay) name:kAlarmStartPlayNotification object:nil];
    [kNotificationCenter addObserver:self selector:@selector(alarmEndPlay) name:kAlarmEndPlayNotification object:nil];
    [kNotificationCenter addObserver:self selector:@selector(pausePlayIfNeeded) name:kBeginLightModeNotification object:nil];
    [kNotificationCenter addObserver:self selector:@selector(pausePlayIfNeeded) name:kBeginRunModeNotification object:nil];
    
    self.fft = [EZAudioFFTRolling fftWithWindowSize:2048
                                         sampleRate:44100
                                           delegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    self.playOrPauseButton.selected = self.playOrPauseButton.selected;
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)tabBarVCWillDismiss {
    if (_progressTimer) {
        kMyProfileTool.currentMode = ModeIdle;
    }

}

- (void)dealloc {
    // 判断按钮当前的状态
    if (self.player.isPlaying)
    {
        // 调用工具类方法暂停
        [AudioTool pauseMusicWithURL:self.playingMusic.assetURL];
    }
    
    [kNotificationCenter removeObserver:self];
}

#pragma mark - Private
- (void)onAudioSessionEvent:(NSDictionary *)userInfo {
    MyLog(@"userInfo%@",userInfo);
//    BOOL isInterruptionEndded = [userInfo[AVAudioSessionInterruptionTypeKey]boolValue];
    
    [self playOrPause];
}




- (void)alarmStartPlay {
    if (self.player.isPlaying) {
        self.needResumePlayWhenAlarmEndPlay = YES;
        [self playOrPause];
    }
}

- (void)alarmEndPlay {
    if (self.needResumePlayWhenAlarmEndPlay) {
        [self playOrPause];
    }
}


- (void)addColorBtns {
    CGFloat btnW = 40;
    CGFloat btnH = 50;
    CGFloat margin = (kScreenWidth - btnW * 7) / 8.0;
    for (int i = 0; i < 7; i ++) {
        
        CGFloat btnX = (i + 1) * margin + i * btnW;
        CGFloat btnY = (68 - btnH) * 0.5;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [self.colorContentView addSubview:btn];
        btn.userInteractionEnabled = NO;
        btn.tag = i + 1;
        
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        [btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        NSString *imgName = [NSString stringWithFormat:@"%@_n",@(i + 1)];
        NSString *selectedImgName = [NSString stringWithFormat:@"%@",@(i + 1)];
        [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selectedImgName] forState:UIControlStateSelected];
        
        btn.titleEdgeInsets = UIEdgeInsetsMake(60, -30, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        
        NSString *title;
        switch (i) {
            case 0:
                title = kMyProfileTool.isEnglish ? @"Red" : @"浪漫红";
                break;
            case 1:
                title = kMyProfileTool.isEnglish ? @"Orange" : @"活泼橙";
                break;
            case 2:
                title = kMyProfileTool.isEnglish ? @"Yellow" : @"明亮黄";
                break;
            case 3:
                title = kMyProfileTool.isEnglish ? @"Green" : @"自然绿";
                break;
            case 4:
                title = kMyProfileTool.isEnglish ? @"Blue" : @"宁静蓝";
                break;
            case 5:
                title = kMyProfileTool.isEnglish ? @"Purple" : @"高贵紫";
                break;
            case 6:
                title = kMyProfileTool.isEnglish ? @"White" : @"纯洁白";
                break;
            default:
                break;
        }
        [btn setTitle:title forState:UIControlStateNormal];
    }
}


// 重置数据
- (void)resetPlayingMusic
{
    
    kMyProfileTool.currentMode = ModeIdle;
    
    // 停止当前正在播放的歌曲
    [AudioTool stopMusicWithURL:self.playingMusic.assetURL];
}

// 开始播放
- (void)startPlayingMusic
{
    [kBLE showConnectShoeIfNeeded];
    
    // 0.设置状态
    kMyProfileTool.currentMode = ModeMusic;
    
    // 1.取出当前正在播放的音乐模型
    Music *music = [MusicsTool playingMusic];
    
    // 2.播放音乐
    self.player = [AudioTool playMusicWithURL:music.assetURL];
    self.player.delegate = self;
    self.playOrPauseButton.selected = YES;
    
    if (self.playingMusic == [MusicsTool playingMusic]) {
        NSLog(@"仅开启定时器");
        return;
    }
    
    // 记录当前正在播放的音乐
    self.playingMusic = [MusicsTool playingMusic];
    
    // 3.设置其他属性
    // 设置总时长
    self.totalTimeLbl.text = [CommonTool mmssStrWithTimeInterval:self.player.duration];
    

    
    [self.tableView reloadData];
    
    if (self.slider.userInteractionEnabled == NO) {
        self.slider.userInteractionEnabled = YES;
    }
}


#pragma mark - 内部控制器方法




- (NSInteger)getRandomColorExcept:(NSInteger )color {
    NSInteger random = arc4random() % 7  + 1;
    if (random == color) {
        return [self getRandomColorExcept:color];
    } else {
        return random;
    }
}


// 监听进度条点击事件
- (IBAction)onProgressBgTap:(UIGestureRecognizer *)sender {
    NSLog(@"%s", __func__);
    // 1.取出当前点击的位置
    CGPoint point =  [sender locationInView:sender.view];
    // 2.设置滑块的位置, 为点击的位置
    self.slider.x = point.x;
    // 3.计算进度
    double progress = point.x / sender.view.width;
    // 4.设置播放事件
    self.player.currentTime = progress * self.player.duration;
}

#pragma mark - Action
/**
 *  上一首
 */
- (IBAction)previous
{
    WEAKSELF
    [CommonTool excuteBlockInMusicMode:^(){
        
        if ([MusicsTool musics].count == 0) {
            return;
        }
        
        // 1.重置数据
        [weakSelf resetPlayingMusic];
        // 2.设置当前播放的音乐
        [MusicsTool setPlayingMusic:[MusicsTool previousMusic]];
        // 3.开始播放
        [weakSelf startPlayingMusic];
        
         [kNotificationCenter postNotificationName:kBeginMusicModeNotification object:nil];
    }];
    
}
/**
 *  下一首
 */
- (IBAction)next
{
    WEAKSELF
    [CommonTool excuteBlockInMusicMode:^(){
        
        if ([MusicsTool musics].count == 0) {
            return;
        }
        
        // 1.重置数据
        [weakSelf resetPlayingMusic];
        // 2.设置当前播放的音乐
        [MusicsTool setPlayingMusic:[MusicsTool nextMusic]];
        // 3.开始播放
        [weakSelf startPlayingMusic];
         [kNotificationCenter postNotificationName:kBeginMusicModeNotification object:nil];
    }];
    
}
/**
 *  播放暂停
 */
- (IBAction)playOrPause
{
    WEAKSELF
    [CommonTool excuteBlockInMusicMode:^(){
        
        if ([MusicsTool musics].count == 0) {
            return;
        }
        
        // 判断按钮当前的状态
        if (weakSelf.playOrPauseButton.selected)
        {
            // 选中, 显示的暂停-->显示播放
            weakSelf.playOrPauseButton.selected = NO;
            
            // 调用工具类方法暂停
            [AudioTool pauseMusicWithURL:weakSelf.playingMusic.assetURL];
            
            
            Byte bytes[] = {0xA5,0x61};
            [kBLE writeBytesForPeripheral:bytes length:2];
            
        } else {
            // 未选中, 显示播放-->显示的暂停
            weakSelf.playOrPauseButton.selected = YES;
            
            if (weakSelf.playingMusic == nil) {
                [MusicsTool setPlayingMusic:[MusicsTool nextMusic]];
            }
            [weakSelf startPlayingMusic];
            
            [kNotificationCenter postNotificationName:kBeginMusicModeNotification object:nil];
        }
    }];
}



- (void)updateLanguage {
    self.navigationItem.title = kMyProfileTool.isEnglish ? @"Music Mode" : @"音乐模式";
    self.sevenColorLbl.text = kMyProfileTool.isEnglish ? @"RGB colorful tone" : @"RGB七彩音符";
}

- (void)updateSelectedColorLbl {

}


// 如果在播放音乐暂停播放
- (void)pausePlayIfNeeded {
    // 判断按钮当前的状态
    if (self.playOrPauseButton.selected)
    {
        // 选中, 显示的暂停-->显示播放
        self.playOrPauseButton.selected = NO;
        
        // 调用工具类方法暂停
        [AudioTool pauseMusicWithURL:self.playingMusic.assetURL];
        
    }
}



- (IBAction)progressSliderValueChanged:(id)sender {
    if (self.player.isPlaying) {
        [self.player pause];
        self.needResumePlayWhenSliderDragged = YES;
    }
}

- (IBAction)progressSliderTouchUp:(UISlider *)sender {
    [self.player setCurrentTime:self.playingMusic.duration * sender.value];
    
    if (self.needResumePlayWhenSliderDragged) {
        [self.player play];
        self.needResumePlayWhenSliderDragged = NO;
    }
    
}


#pragma mark - EZAudioPlayerDelegate
//------------------------------------------------------------------------------

- (void)  audioPlayer:(EZAudioPlayer *)audioPlayer
          playedAudio:(float **)buffer
       withBufferSize:(UInt32)bufferSize
 withNumberOfChannels:(UInt32)numberOfChannels
          inAudioFile:(EZAudioFile *)audioFile
{
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [weakSelf.fft computeFFTWithBuffer:buffer[0] withBufferSize:bufferSize];
    });
}


- (void)audioPlayer:(EZAudioPlayer *)audioPlayer
    updatedPosition:(SInt64)framePosition
        inAudioFile:(EZAudioFile *)audioFile
{
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!weakSelf.slider.touchInside)
        {            
            // 计算进度
            double progress = weakSelf.player.currentTime / self.player.duration;
            weakSelf.slider.value = progress;
            weakSelf.currentTimeLbl.text = [CommonTool mmssStrWithTimeInterval:self.player.currentTime];
        }
    });
}

- (void)audioPlayer:(EZAudioPlayer *)audioPlayer reachedEndOfAudioFile:(EZAudioFile *)audioFile {
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf next];
    });
}


#pragma mark - EZAudioFFTDelegate
//------------------------------------------------------------------------------

- (void)        fft:(EZAudioFFT *)fft
 updatedWithFFTData:(float *)fftData
         bufferSize:(vDSP_Length)bufferSize
{
    
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        FFTTool *tool = [FFTTool sharedInstance];
        CGFloat volume = [tool getColorWithFFT:fftData length:bufferSize];
        NSLog(@"volume:%@",@(volume));
        
        if (weakSelf.sendDate == nil) {
            weakSelf.sendDate = [NSDate date];
        }
        
        if (weakSelf.changeColorDate == nil) {
            weakSelf.changeColorDate = [NSDate date];
        }
        
        NSTimeInterval interval = [[NSDate date]timeIntervalSinceDate:self.sendDate];
        // 当两次的音量相差step时，才能发指令，不然蓝牙速度跟不上
        if ( interval >= 0.10) {
            
            NSInteger color = weakSelf.selectedColorBtn.tag;
            if ([[NSDate date]timeIntervalSinceDate:weakSelf.changeColorDate] > 5) {
                color = (color + 1) % 7;
                
                weakSelf.changeColorDate = [NSDate date];
            }

            if (color == 0) {
                color = 1;
            }
            
            if (volume > 255) {
                volume = 255;
            }
            
            Byte bytes[] = {0xAE,volume,color};
            [kBLE writeBytesForPeripheral:bytes length:3];
            
            weakSelf.sendDate = [NSDate date];
            
            // 高亮选中的颜色按钮
            weakSelf.selectedColorBtn.selected = NO;
            for (UIButton *btn  in weakSelf.colorContentView.subviews) {
                if (btn.tag == color) {
                    weakSelf.selectedColorBtn = btn;
                }
            }
            weakSelf.selectedColorBtn.selected = YES;
        }
        
    });
    
    
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [MusicsTool musics].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    static NSString *identifier = @"music";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.backgroundColor = kGetColorFromRGB(40, 40, 40, 1);
        cell.detailTextLabel.textColor = kLightGrayColor;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    // 2.设置数据
    Music *music = [MusicsTool musics][indexPath.row];
    
    cell.textLabel.text = music.name;
    cell.detailTextLabel.text = music.singer;
    
    UILabel *label = [[UILabel alloc]init];
    label.text = [CommonTool mmssStrWithTimeInterval:music.duration];
    label.font = [UIFont systemFontOfSize:16];
    [label sizeToFit];
    cell.accessoryView = label;
    
    if(music == self.playingMusic) {
        cell.textLabel.textColor = kGetColorFromHex(0xfc4851, 1);
        label.textColor = kGetColorFromHex(0xfc4851, 1);
        cell.imageView.image = [UIImage imageNamed:@"ic_Music-tone_h"];
    } else {
        cell.textLabel.textColor = kWhiteColor;
        label.textColor = kWhiteColor;
        cell.imageView.image = [UIImage imageNamed:@"ic_Music-tone_n"];
    }
    // 3.返回cell
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.主动取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    WEAKSELF
    [CommonTool excuteBlockInMusicMode:^(){
        
        Music *music = [MusicsTool musics][indexPath.row];
        if (music != [MusicsTool playingMusic]) {
            // 1.重置数据
            [weakSelf resetPlayingMusic];
            // 2.设置当前播放的音乐
            [MusicsTool setPlayingMusic:music];
            // 3.开始播放
            [weakSelf startPlayingMusic];
            
            [kNotificationCenter postNotificationName:kBeginMusicModeNotification object:nil];
        }
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

@end
