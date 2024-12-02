import { router, window } from '@kit.ArkUI'

@Entry
@Component
struct Detail {

  build() {
    Column(){
      Row() {
          Image($r('app.media.back'))
            .width(30)
            .height(20)
            .margin({right:300,top:30,bottom:5})
            .onClick(()=>router.back())

      }

      Row(){
        Image((router.getParams() as Record<string, string>)['xqtupian'])
          .width('90%')
          .height('360')
          .margin({top:30})
      }.height('350')

      Scroll(){//子组件text高要大于Scroll，否则滚动无效
        Text('       '+(router.getParams() as Record<string, string>)['jieshao'])
          .width('95%')
          .height(500)
          .fontSize(20)
          .lineHeight(24)
      }
      .margin({top:30})
      .width('95%')
      .height(350)
      .scrollBarColor("#8a8a8a")// 设置滚动条颜色
      .scrollBarWidth(5)// 设置滚动条宽度
      //.scrollBar(BarState.On)// 设置滚动条永久显示
      // .backgroundColor("#e6e6e6")


    }.width('100%').height('100%')
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