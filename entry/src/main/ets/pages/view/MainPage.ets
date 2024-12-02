import Mine from '../mine/Index'
import xiangce from '../xiangce/xc'
import shouye from '../shouye/Index'
import {StyleConstants} from '../../common/StyleConstants'
import {Constants} from '../../common/Constants'
import { window } from '@kit.ArkUI'

interface ITABBARLIST {
  title:string
  selectIcon: Resource;
  icon: Resource;
}
@Entry
@Component
export struct TabPage {
  @State currentIndex: number = 0
  private tabsController: TabsController = new TabsController();//用于控制Tabs组件进行页签切换
  @Builder TabBuilder(title: string, index: number, selectImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === index ? selectImg : normalImg)
        .width(StyleConstants.TABBAR_SIZE)
        .height(StyleConstants.TABBAR_SIZE)
      Text(title)
        .margin({ top: 4 })
        .fontSize($r('app.float.font_size_14fp'))
        .fontColor(this.currentIndex === index ? StyleConstants.TABBAR_SELECT_DEFAULT.SELECT :StyleConstants.TABBAR_SELECT_DEFAULT.DEFAULT)
    }
    .justifyContent(FlexAlign.Center)
    .height($r('app.float.size_50vp'))
    .width(StyleConstants.FULL_WIDTH)
    .onClick(() => {
      this.currentIndex = index
      this.tabsController.changeIndex(this.currentIndex)
    })
  }

  build() {
    Tabs({
      barPosition: BarPosition.End,
      controller: this.tabsController//控制导航栏切换
    }) {
      /**
       * TODO:对于tabBar页面的循环必须严格遵循Constants.TABBARLIST的索引顺序进行条件渲染
       */
      ForEach(Constants.TABBARLIST,(item:ITABBARLIST,idx)=>{
        TabContent() {
          if (idx==0){
              shouye()
          } else if (idx==1) {
            xiangce()
          } else if (idx==2) {
            Mine()
          }
        }
        .tabBar(this.TabBuilder(item.title, idx, item.selectIcon, item.icon))

      },(item:ITABBARLIST,idx)=>idx.toString())

    }
    .width(StyleConstants.FULL_WIDTH)
    .backgroundColor(Color.White)
    .barHeight(56)
    .barMode(BarMode.Fixed)//barMode是控制导航栏是否可以滚动，默认值为Fixed
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
