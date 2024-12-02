import router from '@ohos.router';
import { window } from '@kit.ArkUI';

/**
 * 引导页
 */
@Entry
@Component
struct WelcomePage {

  //给组件绑定一个控制器，用来控制组件翻页
  private swiperController: SwiperController = new SwiperController()
  /**
   * 控制启动按钮显示还是隐藏
   */
  @State flag: boolean = false;
  private titleStr: string[] = ['陶瓷之韵，典藏时光', '陶瓷相册，镌刻时光之美', '陶瓷印记，典藏永恒之美']
  private desStr: string[] = [
    '在每一页翻动的瞬间，感受陶瓷的温润与岁月的沉淀。',
    '不只是相册，更是艺术品。每一幅照片，都被精心嵌入陶瓷框中，仿佛将时间定格于这不朽的材质之中，让回忆随陶瓷一同传世。',
    '在这些由土与火交织而成的页面中，不仅记录着您的欢笑与泪水，更承载着对未来的期许。'
  ]
  private swco: Record<string, number | Color> = { 'size': 20, 'bottom': 200, 'color': Color.White }//设置小圆点的样式

  build() {
    Column({ space: 5 }) {
      Stack({ alignContent: Alignment.Bottom }) {
        Swiper(this.swiperController) {
          //todo 引导页图片内容
          //todo 引导页一
          Stack({ alignContent: Alignment.Center }) {
            Image($r("app.media.welcome1")).width('100%').height('100%')
            Column() {
              Text(this.titleStr[0]).fontSize(25).fontColor(Color.White).fontWeight(FontWeight.Bold)
              Text(this.desStr[0]).fontSize(20).fontColor(Color.White).margin({ left: 20, right: 20, top: 25 })
            }
          }.width('100%').height("100%").alignContent(Alignment.Center)


          //todo 引导页 二
          Stack({ alignContent: Alignment.Center }) {
            Image($r("app.media.welcome2")).width('100%').height('100%')
            Column() {
              Text(this.titleStr[1]).fontSize(25).fontColor(Color.White).fontWeight(FontWeight.Bold)
              Text(this.desStr[1]).fontSize(20).fontColor(Color.White).margin({ left: 20, right: 20, top: 25 })
            }
          }.width('100%').height("100%").align(Alignment.Center)
          //todo 引导页三
          Stack({ alignContent: Alignment.Center }) {
            Image($r("app.media.welcome3")).width('100%').height('100%')
            Column() {
              Text(this.titleStr[2]).fontSize(25).fontColor(Color.White).fontWeight(FontWeight.Bold)
              Text(this.desStr[2]).fontSize(20).fontColor(Color.White).margin({ left: 20, right: 20, top: 25 })
            }
          }.width('100%').height("100%").align(Alignment.Center)
        }
        .index(0) //todo 当前索引为0 开始
        .autoPlay(true) //todo 停止自动播放
        .indicator(true) // todo 默认开启指示点
        .indicatorStyle(this.swco)//指示点的样式。包含颜色，大小等，可自定义
        .loop(true) // todo 停止自动播放  默认开启循环播放
        .vertical(false) //todo 横向切换 默认横向切换

        Row({ space: 5 }) {
          Text('登录注册')
            .fontSize(20)
            .fontColor(Color.White)
            .width(140)
            .height(45)
            .backgroundColor('#00000000')
            .borderStyle(BorderStyle.Solid)
            .borderRadius(40)
            .borderColor(Color.White)
            .borderWidth(1)
            .textAlign(TextAlign.Center)
            .onClick(() => {
              //跳转登录
              router.pushUrl({
                url: 'pages/auth/Login'
              })
            })
          Text('立即体验')
            .fontSize(20)
            .fontColor(Color.White)
            .width(140)
            .height(45)
            .backgroundColor('#00000000')
            .borderStyle(BorderStyle.Solid)
            .borderRadius(40)
            .borderColor(Color.White)
            .borderWidth(1)
            .textAlign(TextAlign.Center)
            .onClick(() => {
              //跳转首页
              router.pushUrl({
                url: 'pages/view/MainPage'
              })
            })
        }
        .width(380)
        .height(50)
        .margin({ bottom: 20 })
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Bottom)

      }

    }.width('100%')
    .height('100%')
    .margin(0)
    .expandSafeArea([SafeAreaType.SYSTEM])
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