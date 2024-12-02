import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import { Constants } from '../../common/Constants'
import { StyleConstants } from '../../common/StyleConstants'
import HeaderNavigation from '../../CommonComponents/BaseComponents/HeaderNavigation'
import {nonNullValidation} from '../../common/utils'
import  axios, { AxiosRequestConfig, AxiosResponse }  from '@ohos/axios';
import { window } from '@kit.ArkUI';

interface Data{
  username?:string
  password?:string
  email?:string
}


@Entry
@Component
export struct Register {

  // 用户账号
  @State username: string = ''

  // 用户密码
  @State password: string = ''

  // 用户邮箱
  @State email:string = ''

  // 隐私协议
  @State agreement: boolean = false

  // 是否显示LoadingProgress
  @State isShowLoadingProgress:boolean = false

  // 定时器
  @State timer:number = 0
  // data?: string | Object | ArrayBuffer;


  // 注册
  handleRegister():void{
    if (!nonNullValidation([this.password,this.username,this.email])) {
      promptAction.showToast({
        message: $r('app.string.empty_tips'),
        duration: 2000,
      });
    } else {
      if (!this.agreement) {
        promptAction.showToast({
          message: $r('app.string.agreement'),
          duration: 2000,
        });
        return
      }
      let data: Data;
      axios({
        method: "post",
        url: 'http://192.168.56.1:3000/publish',
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
          router.replaceUrl({ url: 'pages/auth/Login' });
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
      })

      Column() {

        // 标题
        Column() {
          Text('  时光印记主题相册')
            .TextStyle()
            .fontSize($r('app.float.font_size_30fp'))
          Image($r('app.media.app'))
            .width(260).margin({top:20,left:10}).height(200)
        }
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Start)
        .height('26%')

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

        // 隐私协议
        this.Agreement()

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
   * 注册表单
   */
  @Builder
  Form() {

    TextInput({ placeholder: $r('app.string.user') })
      .inputStyle()
      .onChange((value: string) => {
        this.username = value;
      })

    TextInput({ placeholder: $r('app.string.password')})
      .type(InputType.Password)
      .inputStyle()
      .onChange((value: string) => {
        this.password = value;
      })

    TextInput({ placeholder: $r('app.string.email')})
      .type(InputType.Email)
      .inputStyle()
      .onChange((value: string) => {
        this.email = value;
      })
  }

  /**
   * 注册按钮
   */
  @Builder
  RegisterButton(){
    Button( { type: ButtonType.Capsule }){
      Row() {
        if (!this.isShowLoadingProgress){
          Text($r('app.string.register'))
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

  /**
   * 隐私协议
   */
  @Builder
  Agreement() {
    Row() {
      Toggle({ type: ToggleType.Checkbox, isOn: this.agreement })
        .size({ width: 20, height: 20 })
        .selectedColor(StyleConstants.BASE_STYLE.fontColor)
        .onChange((isOn: boolean) => {
          this.agreement = isOn
        })
      Text('已阅读并同意')
        .fontSize($r('app.float.font_size_14fp'))
      Text('《服务条款》')
        .fontSize($r('app.float.font_size_14fp'))
        .fontColor(StyleConstants.BASE_STYLE.fontColor)
      Text('与')
        .fontSize($r('app.float.font_size_14fp'))
      Text('《隐私权政策》')
        .fontSize($r('app.float.font_size_14fp'))
        .fontColor(StyleConstants.BASE_STYLE.fontColor)
    }
    .margin({ top: StyleConstants.SPACING })

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
  .width(StyleConstants.FULL_WIDTH)
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


