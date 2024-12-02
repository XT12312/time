import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import { Constants } from '../../common/Constants'
import { StyleConstants } from '../../common/StyleConstants'
import HeaderNavigation from '../../CommonComponents/BaseComponents/HeaderNavigation'
import {nonNullValidation} from '../../common/utils'
import http from '@ohos.net.http';
import  axios, { AxiosRequestConfig, AxiosResponse }  from '@ohos/axios';
import { data } from '@kit.TelephonyKit';
import { window } from '@kit.ArkUI';

interface Data{
  username?:string
  password?:string
  email?:string
}


@Entry
@Component
struct Register {

  // 用户账号
  @State username: string = ''

  // 用户密码
  @State password: string = ''

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
    if (!nonNullValidation([this.password,this.username,this.rpassword])) {
      promptAction.showToast({
        message: $r('app.string.empty_tips'),
        duration: 2000,
      });
    } else {
      if (this.password!=this.rpassword) {
        promptAction.showToast({
          message: "密码不一致",
          duration: 2000,
        });
        return
      }
      let data: Data;
      axios({
        method: "post",
        url: 'http://192.168.56.1:3000/upd',
        data:data={
          username:this.username,
          password:this.password,
        },
      }).then((res:AxiosRequestConfig) => {
        if(res.data.status==1){
          promptAction.showToast({
            message: '账号不存在',
            duration: 2000,
          });
        }else {
          console.info('result:' + JSON.stringify(res.data));
          this.isShowLoadingProgress = true;
          setTimeout(() => {
            this.isShowLoadingProgress = false;
            router.replaceUrl({ url: 'pages/auth/Login' });
          }, Constants.DELAY_TIME_5s);
        }
        // console.info('result:' + JSON.stringify(res.data));
        // router.pushUrl({
        //   url: 'pages/NewApp_one',
        // })
      }).catch((error:string) => {
        console.error(error);
      })

      // const httpRequest=http.createHttp()
      // httpRequest.request("http://localhost:3000/vips",{
      //   method:http.RequestMethod.POST,
      //   header:{
      //     'Content-Type':'application/json'
      //   },
      //   extraData:{
      //     username:this.username,
      //     password:this.password,
      //     email:this.email
      //   },
      //   connectTimeout:60000,
      //   readTimeout:60000
      // },(err,data)=>{
      //   if (!err) {
      //     console.log("data.result",data.result)
      //     console.log("data.responseCode",data.responseCode)
      //     if (data.responseCode==201) {
      //       console.log("注册成功")
      //     }
      //   }
      // }
      // )


    }

  }

  // 获取验证码
  getVerificationCode():void{
    // 重新给倒计时赋值
    this.reckonTimer = 60
    this.getCode = $r('app.string.send_code');
    this.code = '123456'
    this.codeStata = true
    // 验证码过期
    this.timer = setInterval(()=>{
      this.reckonTimer--
      if (this.reckonTimer <= 0) {
        this.codeStata = false
        this.getCode = $r('app.string.refresh_code');
        clearInterval(this.timer)
      }
    },1000)

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
          title:$r('app.string.WangjiMima')
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
    // .backgroundImage(PageConstants.LOGIN_BG, ImageRepeat.NoRepeat)
    // .backgroundImageSize(ImageSize.Cover)
  }


  /**
   * 忘记密码表单
   */
  @Builder
  Form() {

    TextInput({ placeholder: $r('app.string.user') })
      .inputStyle()
      .onChange((value: string) => {
        this.username = value;
      })

    TextInput({ placeholder: $r('app.string.password')})
      .inputStyle()
      .onChange((value: string) => {
        this.password = value;
      })

    TextInput({ placeholder: $r('app.string.rpassword')})
      .inputStyle()
      .onChange((value: string) => {
        this.rpassword = value;
      })

  }

  /**
   * 忘记密码按钮
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
// import  axios, { AxiosResponse }  from '@ohos/axios'
// import router from '@ohos.router'
// import HeaderNavigation from '../../CommonComponents/BaseComponents/HeaderNavigation'
// import { Constants } from '../../common/Constants'
// import { StyleConstants } from '../../common/StyleConstants'
// import promptAction from '@ohos.promptAction';
//
//
// interface Data{
//   username?:string
//   password?:string
// }
// @Entry
// @Component
// struct Index {
//   // 上传数据
//   @State username: string = ''
//   @State password: string = ''
//   @State rpassword:string=''
//   static a:boolean
//   // if (a:boolean){
//   //   promptAction.showToast({
//   //     message: $r('app.string.input_empty_tips'),
//   //     duration: 2000,
//   //   });
//   // }
//   build() {
//     Column() {
//       HeaderNavigation({
//         leftIconGroup: {
//           icon: Constants.BACk,
//           event: () => {
//             router.back()
//           }
//         },
//         middle: {
//           title: $r('app.string.WangjiMima')
//         }
//       })
//       TextInput({placeholder:'原账号'} )
//         .placeholderColor('#515151')
//         .margin(20)
//         .height(50)
//         .onChange(value =>{
//           console.log(value)
//           this.username = value
//         })
//         .backgroundColor(StyleConstants.BASE_STYLE.inputBackGroundColor)
//       TextInput({placeholder:'新密码'})
//         .placeholderColor('#515151')
//         .margin({ left:20,right:20,bottom:20 })
//         .height(50)
//         .onChange(value =>{
//           console.log(value)
//           this.password = value
//         })
//         .backgroundColor(StyleConstants.BASE_STYLE.inputBackGroundColor)
//       TextInput({placeholder:'确认密码'})
//         .placeholderColor('#515151')
//         .margin({ left:20,right:20,bottom:20 })
//         .height(50)
//         .onChange(value =>{
//           console.log(value)
//           this.password = value
//         })
//         .backgroundColor(StyleConstants.BASE_STYLE.inputBackGroundColor)
//       if (this.rpassword==this.password){
//         Button('修改密码')
//           .width(200)
//           .onClick(()=>{
//             let data: Data;
//             axios({
//               method: "post",
//               url: 'http://localhost:3000/upd',
//               data:data={
//                 username:this.username,
//                 password:this.password,
//               },
//             }).then((res:AxiosResponse)   => {
//               console.info('result:' + JSON.stringify(res.data));
//               {
//                 router.pushUrl({
//                   url: 'pages/auth/login',
//                 })
//               }
//             }).catch((error:string) => {
//               console.error(error);
//             })
//           })
//       }
//     }
//     .width('100%')
//     .height('100%')
//   }
// }
