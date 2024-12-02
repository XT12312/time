// AboutPage.ets
import { Constants } from '../../common/Constants'
import HeaderNavigation from '../../CommonComponents/BaseComponents/HeaderNavigation'
import router from '@ohos.router';
import { window } from '@kit.ArkUI';

@Entry
@Component
struct AboutPage {
  build() {
    Column() {
      HeaderNavigation({
        leftIconGroup: {
          icon: Constants.BACk,
          event: () => {
            router.back()
          }
        },
      }).margin({top:30,left:-20})
      // 应用图标
      Image($r('app.media.app'))
        .width(200)
        .height(200)
        .margin({ top: 20, bottom: 20 })

      // 应用名称
      Text('应用名称：时光印记')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 5 })


      // 应用版本
      Text('版本：1.0.0')
        .fontSize(16)


      // 开发者信息
      Text('开发者：云途一体创梦团')
        .fontSize(16)
        .margin({ top: 10, bottom: 10 })


      // 版权信息
      Text('版权所有 © 2024 [云途一体创梦团]')
        .fontSize(14)


      // 隐私政策和用户协议链接
      Button('隐私政策')
        .width('90%')
        .margin({ top: 20, bottom: 10 })
        .onClick(() => {
          // 打开隐私政策页面或链接
        });

      Button('用户协议')
        .width('90%')

        .onClick(() => {
          // 打开用户协议页面或链接
        });
    }
    .width('100%')
    .padding({ left: 20, right: 20 })

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