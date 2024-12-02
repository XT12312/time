import axios, { AxiosResponse } from '@ohos/axios';
import Setting from './Index';
import { router } from '@kit.ArkUI';
import HeaderNavigation from '../../CommonComponents/BaseComponents/HeaderNavigation';
import { Constants } from '../../common/Constants';

interface Data{
  title?:string
}
let data: Data
@Entry
@Component
struct Like {
  @State message: string = 'Hello World';
  build() {
    Column(){
      HeaderNavigation({
        leftIconGroup: {
          icon: Constants.BACk,
          event: () => {
            router.back()
          }
        },
        middle: {
          title:'我的收藏'
        }
      })
      Blank().height(30)
      List({space: 5}){
        ForEach(Setting.results, (item: string[],index:number) => {
          ListItem(){
            Text(item['title'])
              .like()
              .onClick(() => {
                axios({
                  method: "post",
                  url: 'http://192.168.56.1:3000/detail',
                  data:data={
                    title:item['title'],
                  },
                }).then((res:AxiosResponse) => {
                  Setting.results= res.data.shoucang
                  router.pushUrl({
                    url: 'pages/shouye/Detail' ,
                    params: {
                      xqtupian: $r(res.data.tupian),
                      jieshao:res.data.neirong,
                    }
                  })
                })
              })
          }

        })
      }
    }
    // Text('hhh')
  }
}
@Extend(Text) function like(){
  .fontSize(20)
  .padding({left:10})
  .margin({top:10,left:20})
  .backgroundColor('#f1f3f5')
  .borderRadius(16)
  .width('90%')
  .height(40)
}