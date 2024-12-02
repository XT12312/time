import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import { Constants } from '../../common/Constants'
import { StyleConstants } from '../../common/StyleConstants'
import HeaderNavigation from '../../CommonComponents/BaseComponents/HeaderNavigation'
import {nonNullValidation} from '../../common/utils'
import {Login} from '../auth/Login'
import  axios, { AxiosRequestConfig, AxiosResponse }  from '@ohos/axios';
import Setting from '../mine/Index';
import { window } from '@kit.ArkUI';

interface Data{
  username?:string
  password?:string
  email?:string
}


@Entry
@Component
struct Xiugai {

  // 用户账号
  @State username: string = ''

  // 用户密码
  @State password: string = ''
  // 邮箱
  @State email: string = ''

  // 用户邮箱
  @State rpassword:string = ''

  // 验证码
  @State code:string = ''

  // 获取验证码
  @State  getCode:Resource | null = $r('app.string.get_v_code')

  // 验证码状态
  @State codeStata:boolean = false

  // 隐私协议
  @State agreement: boolean = false

  // 是否显示LoadingProgress
  @State isShowLoadingProgress:boolean = false

  // 验证码过期时间
  @State reckonTimer:number = 0

  // 定时器
  @State timer:number = 0
  // data?: string | Object | ArrayBuffer;

  // 注册
  handleRegister():void{
    if (!nonNullValidation([this.password,this.username])) {
      promptAction.showToast({
        message: $r('app.string.empty_tips'),
        duration: 2000,
      });
    } else {
      let data: Data;
      axios({
        method: "post",
        url: 'http://192.168.56.1:3000/upd',
        data:data={
          username:this.username,
          password:this.password,
          email:this.email
        },
      }).then((res:AxiosRequestConfig) => {
        console.info('result:' + JSON.stringify(res.data));
        this.isShowLoadingProgress = true;
        setTimeout(() => {
          this.isShowLoadingProgress = false;
          router.back()
        }, Constants.DELAY_TIME_5s);

      }).catch((error:string) => {
        console.error(error);
      })

    }

  }


  build() {
    Column() {
      HeaderNavigation({
        leftIconGroup: {
          icon: Constants.BACk,
          event: () => {
            router.back()
          }
        },
        middle: {
          title:$r('app.string.xiugai')
        }
      })

      Column() {

        // 表单
        Column() {
          this.Form()

        }
        .justifyContent(FlexAlign.Center)
        .height('60%')

        // 提交按钮
        Flex({ justifyContent: FlexAlign.Center }) {
          this.RegisterButton()
        }
      }
      .alignItems(HorizontalAlign.Start)
      .width('80%')
      .height('80%')

    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }


  /**
   * 修改表单
   */
  @Builder
  Form() {
    Text('账号')
      .fontSize(18)
      .margin({left:-232})
    TextInput({ text: Login.yonghu })
      .inputStyle()
      .onChange((value: string) => {
        this.username = value;
      })
    Text('密码')
      .fontSize(18)
      .margin({left:-232,top:20})
    TextInput({ text: Login.mima})
      .inputStyle()
      .onChange((value: string) => {
        this.password = value;
      })
    Text('邮箱')
      .fontSize(18)
      .margin({left:-232,top:20})
    TextInput({ text: Setting.email})
      .inputStyle()
      .onChange((value: string) => {
        this.email = value;
      })
  }

  /**
   * 修改按钮
   */
  @Builder
  RegisterButton(){
    Button( { type: ButtonType.Capsule }){
      Row() {
        if (!this.isShowLoadingProgress){
          Text("确认")
            .fontSize('16fp')
            .fontColor(Color.White)
        }else{
          LoadingProgress()
            .width(30)
            .height(30)
            .margin({ left: 12 })
            .color(StyleConstants.BASE_GREY)
        }
      }
    }
    .width(StyleConstants.FULL_BUTTON)
    .backgroundColor(StyleConstants.BASE_STYLE.fontColor)
    .height(StyleConstants.INPUT_HEIGHT)
    .onClick(()=>this.handleRegister())
  }
  onPageShow(): void {    //设置全屏的方法
    window.getLastWindow(AppStorage.get('context'), (err, data) => {
      if (err.code) {
        console.error('Failed to get last window.Cause:' + JSON.stringify(err))
        return
      }
      data.setFullScreen(true)
    })
  }
}

// 输入框样式
@Extend(TextInput) function inputStyle() {
  .fontColor(StyleConstants.BASE_STYLE.fontColor)
  .caretColor(StyleConstants.BASE_STYLE.fontColor)
  .placeholderColor(StyleConstants.BASE_STYLE.fontColor)
  .width('100%')
  .height(StyleConstants.INPUT_HEIGHT)
  .fontSize($r('app.float.font_size_18fp'))
  .backgroundColor(StyleConstants.BASE_STYLE.inputBackGroundColor)
  .margin({ top:StyleConstants.SPACING})
}

// 文本样式
@Extend(Text) function TextStyle() {
  .fontColor(StyleConstants.BASE_STYLE.fontColor)
  .fontWeight(FontWeight.Bold)
  .margin({ top: StyleConstants.SPACING})
}

