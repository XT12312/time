import router from '@ohos.router';
import { Login } from '../auth/Login'
import { promptAction, window } from '@kit.ArkUI';
import axios, { AxiosResponse } from '@ohos/axios';
interface Data{
  username?:string
  password?:string
  email?:string
}
let data: Data
@Entry
@Component
export default struct Setting {
  @State tuichu:string='false'
  static email?:string
  static results:string[]
  build() {
    if (Login.ll == undefined ) {
      Login()
    } else {
      if ((router.getParams() as Record<string, string>)['tuichu']=='false'){
        Login()
      }else {
        Row() {
          Image($r('app.media.touxiang'))
            .width(60)
            .height(60)
            .onClick(()=>
            axios({
              method: "post",
              url: 'http://192.168.56.1:3000/xc',
              data:data={
                username:Login.yonghu,
              },
            }).then((res:AxiosResponse) => {
              Login.mima=res.data.mima
              Setting.email=res.data.email
              router.pushUrl({url: 'pages/auth/xiugai' })
            })
            )
          Column() {
            Text((router.getParams() as Record<string, string>)['username'])
              .fontSize(22).margin({left:10})
          }
        }.margin({ top: -600 })
        .alignItems(VerticalAlign.Center)
        .width('100%')
        .backgroundColor(Color.White)
        .padding({ left: 24 })
        .borderRadius(16)
        Column(){
          // Text('我的收藏').margin({top:14,left:10}).fontSize(20)
          //   .backgroundColor(0xe8e8e8).borderRadius(16).width('100%').height(50).padding({left:10})
          Text('我的信息').margin({top:14,left:10}).fontSize(20)
            .backgroundColor(0xe8e8e8).borderRadius(16).width('100%').height(50).padding({left:10})
            .onClick(()=>
            axios({
              method: "post",
              url: 'http://192.168.56.1:3000/xc',
              data:data={
                username:Login.yonghu,
              },
            }).then((res:AxiosResponse) => {
              Login.mima=res.data.mima
              Setting.email=res.data.email
              router.pushUrl({url: 'pages/auth/xiugai' })
            })
            )
          Text('我的收藏').margin({top:14,left:10}).fontSize(20)
            .backgroundColor(0xe8e8e8).borderRadius(16).width('100%').height(50).padding({left:10})
            .onClick(() => {
              axios({
                method: "post",
                url: 'http://192.168.56.1:3000/Mylike',
              }).then((res:AxiosResponse) => {
                Setting.results= res.data.shoucang
                router.pushUrl({
                  url: 'pages/mine/like' ,
                })
              })
            })

          Text('关于应用').margin({top:14,left:10}).fontSize(20)
            .backgroundColor(0xe8e8e8).borderRadius(16).width('100%').height(50).padding({left:10})
            .onClick(()=>{
              router.pushUrl({url:'pages/mine/AboutPage'})
            })
        }.margin({top:-400,right:240,left:20})
        .alignItems(HorizontalAlign.Start)
        .width('80%')
        .height(90)
        Blank()

        Button('退出登录', { type: ButtonType.Capsule })
          .width('90%')
          .height(40)
          .fontSize(16)
          .fontColor(Color.Red)
          .fontWeight(FontWeight.Medium)
          .backgroundColor(0xCCCCCC)
          .margin({ top: 100 })
          .onClick(() => {
            promptAction.showToast({ message: '退出登录' })
            router.replaceUrl({
              url: 'pages/view/MainPage' ,
              params: {
                tuichu: this.tuichu
              }
            })
          })
      }
    }
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