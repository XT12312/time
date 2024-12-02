// @Entry
import { router, window } from '@kit.ArkUI';
import  xc  from '../xiangce/xc';

@Entry
@Component
struct textContent {
  build() {
    Column() {
      Image($r(`app.media.img_${xc.ll}`))
        .width('100%') // 设置图片宽度为全屏
        .height('85%') // 设置图片高度为全屏
        .objectFit(ImageFit.Contain)// 保持图片比例
        .onClick(()=>{
          router.back()
        })
      Row(){
        Column(){
          Image($r('app.media.share'))
            .width(32)
            .height(32)
            .margin({right: '20%' })
          Text("分享")
            .fontSize(16)
            .margin({right:68})
        }
        Column() {
          Image($r('app.media.change'))
            .width(32)
            .height(32)
            .margin({ right: '20%' })
          .onClick(() => router.pushUrl({
            url:'pages/HomePage',
            params: {
              photo: xc.ll,
            }
          }))
          Text("编辑")
            .fontSize(16)
            .margin({right:68})
        }
        Column() {
          Image($r('app.media.more'))
            .width(40)
            .height(32)
          Text("更多")
            .fontSize(16)

        }
      }.margin({top:'60'})
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White); // 设置背景颜色为黑色
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
