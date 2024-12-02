import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import { Constants } from '../../common/Constants'
import { StyleConstants } from '../../common/StyleConstants'
import { nonNullValidation } from '../../common/utils'
import axios, {  AxiosResponse } from '@ohos/axios';
import { window } from '@kit.ArkUI';

@Entry
@Component
export struct Login {
  // 用户账号
  @State username: string = ''

  // 用户密码
  @State password: string = ''


  // 是否显示LoadingProgress
  @State isShowLoadingProgress: boolean = false

  // 验证码过期时间
  @State reckonTimer: number = 0

  // 定时器
  @State timer: number = 0
  // 是否成功登录
  @State loginAchieve: boolean=false;
  static ll?:boolean
  //修改信息素获取用户信息
  static yonghu?:string
  static mima?:string
  // 登录
  handleRegister(): void {
    if (!nonNullValidation([this.username, this.password])) {
      promptAction.showToast({
        message: $r('app.string.input_empty_tips'),
        duration: 2000,
      });
    } else {
      axios({//使用Axios（）是一个基于 promise 的网络请求库，可以运行node.js，实现数据的响应
        method: "get",
        url: 'http://192.168.56.1:3000/find/'+this.username+ '/' + this.password,
      }).then((res:AxiosResponse) => {
        if(res.data.status==1){
          promptAction.showToast({
            message: '账号或密码不对',
            duration: 2000,
          });
        }else {
          console.info('result:' + JSON.stringify(res.data.message));//
          if (res.data.loginAchieve==true){
            Login.ll=true
            // console.log(s.set("isLogin", true)+'')
          }
          Login.yonghu=res.data.yonghu
          // Login.mima=res.data.mima
          this.isShowLoadingProgress = true;
          setTimeout(() => {
            this.isShowLoadingProgress = false;
            router.replaceUrl({
              url: 'pages/view/MainPage' ,
              params: {
                username: this.username
              }
            });
          }, Constants.DELAY_TIME_5s);
        }
      }).catch((error:string)=> {
        console.error(error);
      })
    }
  }
  build() {
    Column() {


      Column() {

        // 标题
        Column() {
          Text('  时光印记主题相册')
            .TextStyle()
            .fontSize($r('app.float.font_size_30fp'))
          Image($r('app.media.app'))
            .width(260).margin({top:20,left:13}).height(200)
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
        Row() {
          Text('注册 ')
            .TextStyle()
            .fontSize('19fp')
            .textAlign(TextAlign.Center)
            .onClick(()=>{
              router.pushUrl({url:'pages/auth/Register'})
            })
          Text('|').TextStyle().fontColor( Color.Black ).fontSize('19fp')
          Text(' 忘记密码')
            .TextStyle()
            .fontSize('19fp')
            .textAlign(TextAlign.Center)
            .onClick( () => {
              {
                router.pushUrl({
                  url: 'pages/auth/WangjiMima',
                })
              }
            })
        }
        .margin({ left: 90 })
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
   * 登录表单
   */
  @Builder
  Form() {

    TextInput({ placeholder: $r('app.string.user') })
      .inputStyle()
      .onChange((value: string) => {
        this.username = value;
      })

    TextInput({ placeholder: $r('app.string.password') })
      .type(InputType.Password)
      .inputStyle()
      .onChange((value: string) => {
        this.password = value;
      })
  }

  /**
   * 登录按钮
   */
  @Builder
  RegisterButton() {
    Button({ type: ButtonType.Capsule }) {
      Row() {
        if (!this.isShowLoadingProgress) {
          Text($r('app.string.login'))
            .fontSize('16fp')
            .fontColor(Color.White)
        } else {
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
    .onClick(() => this.handleRegister())
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
  .margin({ top: StyleConstants.SPACING })
}

// 文本样式
@Extend(Text) function TextStyle() {
  .fontColor(StyleConstants.BASE_STYLE.fontColor)
  .fontWeight(FontWeight.Bold)
  .margin({ top: StyleConstants.SPACING })
}