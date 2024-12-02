import image from '@ohos.multimedia.image'
import { router, window } from '@kit.ArkUI';
import axios, { AxiosResponse } from '@ohos/axios';

@Observed
class Item{
  name: string
  brief: string;
  image: ResourceStr
  isLiked: boolean=false
  image1:string
  //static isLiked: boolean

  // static isLiked: boolean

  constructor(name: string,brief: string,  image: ResourceStr, isLiked: boolean,image1:string) {
    this.name = name
    this.brief=brief
    this.image = image
    this.isLiked=isLiked
    this.image1 = image1
  }
}
interface Data{
  title?:string
  photo?:string
  jieshao?:string
}
let data: Data
@Entry
@Component
export default struct Index {
  @State Porceitems: Array<Item> = [
    new Item('东晋黑釉',"商代晚期瓷器介绍:商代晚期,瓷器以青釉陶器为主,造型简洁,常见器型有鬲、豆、罐等。此时瓷器胎质粗松,釉层较厚,技术尚未成熟。尽管如此，商代晚期瓷器仍标志着我国瓷器工艺的初步发展,为后世瓷器制造奠定了基础。‌定义与起源‌：商代原始瓷是在制陶技术基础上发展而来的瓷器原始阶段制品，最早在河南郑州商代二里冈文化层中出现。\n" +
      "        制作工艺‌：采用含铁量约2%的粘土成型，经人工施釉，并在约1200℃高温下烧制而成。胎质较粗，釉色不稳定，多有流釉现象，胎釉结合较差。\n" +
      "        器物类型‌：主要为生活用器，如尊、盂、豆、罐、瓮等，也有仿青铜礼器的钟、錞于等。器形不甚工整，存在歪斜、高低不等和圆器不圆等情况。",  $r('app.media.img_1'),false,'app.media.img_1'),
    new Item('唐釉下彩', '唐三彩多以含有大量高岭土的白色黏土为原料，先在1000℃以上的窑温下烧制素坯，上釉后，在800℃左右低温下烧成。有的在釉下的胎上采用刻花、划花、贴花等技法做出鸟兽、花卉、人物等装饰。\n        釉由含铁、铜、钴、锰等多种呈色元素的矿物配制。作为助熔剂的铅，既可降低烧成温度，又能使釉面光亮。各种着色金属氧化物熔于铅釉中，相互交融，自然流淌，形成斑驳美丽的釉色。\n        颜色有黄、绿、白、蓝、褐等，其中蓝釉是中国最早的以钴土矿作彩料所呈现的釉色。唐三彩大都是冥器，只有小部分为生活用具，器类主要有俑、动物、模型器、建筑构件四大类，其中俑和动物是在武则天（684~704）时期才出现的。玄宗开元时期，唐三彩艺术发展到巅峰', $r('app.media.img_2'),false,'app.media.img_2'),
    new Item('汉青釉瓷', '出土的大量唐三彩，古董商们将其运至北京，引起了著名学者王国维、罗振玉等的高度重视和赞赏。之后，洛阳地区不断有唐三彩出土，数量之多、质量之美，令人惊叹。\n        出土地区主要集中在洛阳市北的邙山，市南的关林、龙门和市西的谷水一带，其中洛阳市内出土唐三彩的地点就多达20处以上，所出三彩数量至少500件之多。洛阳出土的唐三彩系本地烧造，一则因为洛阳市北的邙山就有生产唐三彩的原料——白色高岭土，二则因为距离洛阳不远的巩义市大、小黄冶村发现了烧制唐三彩器的窑址，经1976年以来进行的多次调查和考古发掘，发现了丰富的窑具、模具和三彩器等，充分证明了唐代陶器烧造技术方面的先导地位。', $r('app.media.img_3'),false,'app.media.img_3'),
    new Item('商代晚期', '由于商代历史长（一般认为有六百多年），文化面貌比较清楚，商代的陶器前后差别较大，陶瓷史家们往往把它分成三个时期来介绍：商代早期的陶器，以泥质灰陶为主，夹砂灰陶较夏代为多。\n        商代中期的陶器，以泥质灰陶和夹砂灰陶最多，约占同期陶器总数的90%以上。商代晚期的陶器，以泥质灰陶和夹砂灰陶为最多，另有少量的泥质红陶。\n        出土地区主要集中在洛阳市北的邙山，市南的关林、龙门和市西的谷水一带，其中洛阳市内出土唐三彩的地点就多达20处以上，所出三彩数量至少500件之多。洛阳出土的唐三彩系本地烧造，一则因为洛阳市北的邙山就有生产唐三彩的原料——白色高岭土，', $r('app.media.img_4'),false,'app.media.img_4'),
    new Item('宋白釉', '宋白釉是宋代瓷器的一种，以其胎质细腻、釉色纯净著称。这种釉色呈现出乳白色，质地温润，光洁如玉，反映了宋代瓷器制作的高超技艺。宋白釉常用于制作碗、盘、瓶等生活用器，因其典雅的外观和实用性，深受当时及后世喜爱。',$r('app.media.img_5'),false,'app.media.img_5'),
    new Item('元青花瓷','元青花瓷，起源于元代，是中国古代瓷器的一种，以钴料为着色剂，在瓷胎上绘制纹饰，再经过高温釉色而成。其纹饰繁复，色泽鲜艳，器型多样，具有很高的艺术价值和收藏价值。元青花瓷代表了中国古代瓷器工艺的高峰，也是研究元代历史、文化和艺术的重要实物资料。', $r('app.media.img_6'),false,'app.media.img_6'),
    new Item('明五彩','明代五彩瓷器是中国瓷器史上的一个重要品类，以其色彩丰富、绘制精细著称。五彩瓷器的制作工艺在明代达到了高峰，其特点是用料考究，色彩搭配巧妙，图案生动，具有很高的艺术价值和收藏价值。代表作品有嘉靖、万历年间制作的五彩大盘、花瓶等。',  $r('app.media.img_7'),false,'app.media.img_7'),
    new Item('清青花釉', '明五彩，又称“釉上五彩”，是中国传统彩瓷工艺的一种。它以瓷胎为基底，在瓷胎上以青花釉料描绘图案，然后施以五彩颜料，再经过高温烧制而成。清青花釉则是指清朝时期的青花瓷器，其釉色青翠，色泽稳定，是青花瓷中的经典之作。', $r('app.media.img_8'),false,'app.media.img_8'),
    new Item('现代', '现代陶瓷是一种融合了传统陶瓷工艺与现代设计理念的新型材料。它不仅继承了传统陶瓷的质感和美感，还通过创新技术，拥有了更加丰富的表现形式和更加广泛的应用领域', $r('app.media.img_9'),false,'app.media.img_9'),

  ]

  build() {
    Column(){
      List({space: 5}){
        ForEach(this.Porceitems, (item: Item,index:number) => {
            ListItem(){
              Porcelain({
                porcel:item
              })
            }
          }
        )
      }
      .width('100%')
      .layoutWeight(1)
      .alignListItem(ListItemAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f0ed')
  }
}
@Component
struct Porcelain {
  @ObjectLink porcel: Item;

  build() {
    Row() {
      Image(this.porcel.image)
        .width('100')
        .height('120')
      Column({ space: 20 }) {
        Text(this.porcel.name)
          .fontSize('20')
          .fontWeight(FontWeight.Bold)
          .fontColor("#707070")
          .margin({ top: 15 })
        Text(this.porcel.brief)
          .width(150)
          .fontSize('16')
          .fontColor("#707070")
          .margin({ left: 15 })
          .lineHeight(10)
          .textOverflow({overflow:TextOverflow.Ellipsis})
          .maxLines(1)
        Row() {
          Text("收藏")
            .fontSize('15')
            .fontColor("#707070")
            .margin({ bottom: 5, left: 5 })
          Image(this.porcel.isLiked == true ? $r('app.media.iconLiked') : $r('app.media.iconUnLiked'))
            .width(20)
            .height(20)
            .margin({ bottom: 8, left: 5 })
            .onClick(() => {
              console.log(String(this.porcel.image))
              this.porcel.isLiked = !this.porcel.isLiked
              if(this.porcel.isLiked){
                axios({
                  method: "post",
                  url: 'http://192.168.56.1:3000/like',
                  data:data={
                    title:this.porcel.name,
                    photo:this.porcel.image1,
                    jieshao:this.porcel.brief
                  },
                }).then((res:AxiosResponse) => {
                  // Login.mima=res.data.mima
                  // Setting.email=res.data.email
                  // router.pushUrl({url: 'pages/auth/xiugai' })
                })
              }else {
                axios({
                  method: "post",
                  url: 'http://192.168.56.1:3000/unlike',
                  data:data={
                    title:this.porcel.name,
                  },
                }).then((res:AxiosResponse) => {
                })
              }

            })

        }
        .justifyContent(FlexAlign.Center)

      }
      Button("详情>>")
        .borderRadius(5)
        .width("20%")
        .height(20)
        .margin({ left: 20, top: 75 })
        .onClick(() => router.pushUrl({
          url: 'pages/shouye/Detail',
          params: {
            xqtupian: this.porcel.image,
            jieshao:this.porcel.brief,
          }
        }))
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .borderRadius(12) //圆弧效果
    .backgroundColor('#e6e6e6')
    .margin({ top: 10 })
    .padding({ left: 10, right: 30 })
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