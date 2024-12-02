import { curves, router, window } from '@kit.ArkUI';



interface Data { //数据类型
  src: ResourceStr
  txt: string
  index:number
}


@Entry
@Component
export default  struct xc {
  @State datas: Data[] = [] //默认数据源
  @State templete: string = '1fr 1fr' //默认列数
  static ll?:number//静态变量可跨页面传输数据
  aboutToAppear(): void { //模拟生成数据源
    for (let i = 1; i <= 19; i++) {
      this.datas.push({
        src: $r(`app.media.img_${i}`),
        txt: '第' + i + '个',
        index:i
      })
    }

  }

  @Builder
  genitem(src: ResourceStr, txt: string,index:number) { //瀑布流子布局 有图片和文本 图片高度不一样

    Column() {

      Image(src).width('100%')
        .onClick(()=>{
          xc.ll=index
          router.pushUrl({url:'pages/xiangce/textContent'})
        })
      Text(txt).fontSize(18).fontWeight(FontWeight.Bold).margin(10)
    }.width('100%')
  }

  build() {
    Stack() {
      Column() {
        WaterFlow() {
          ForEach(this.datas, (item: Data) => {
            FlowItem() {
              this.genitem(item.src, item.txt,item.index)
            }
          }, (item: Data) => JSON.stringify(item))

        }.columnsTemplate(this.templete)
        .rowsGap(20)
        .columnsGap(10)
        .animation({ curve: curves.springMotion() }) //切换列数的时候有动画
      }
      .height('100%')
      .width('100%')

      Button('变化').width('60%').backgroundColor('rgba(255,0,0,0.5)')
        .onClick(() => {
          let count = Math.floor(Math.random() * 5 + 1) //生成随机列数1~5
          let str = ''
          for (let i = 1; i <= count; i++) { //生成列数字符串
            str = str + '1fr '
          }
          this.templete = str
        })
    }.width('100%')
    .height('100%')
    .alignContent(Alignment.Bottom)
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
