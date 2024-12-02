/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *编码
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo } from '@kit.CoreFileKit';
import { image } from '@kit.ImageKit';
import Logger from './LoggerUtil';
import { CommonConstants } from '../common/constant/CommonConstants';

const TAG: string = 'imageEdit_Encode';
const context = getContext(this);
let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
/**
 * Pack the image.
 *
 * @param pixelMap.
 */
export async function encode(component: Object, pixelMap: PixelMap) {//编码函数
  const newPixelMap = pixelMap;
  // 图片打包器类
  const imagePackerApi = image.createImagePacker();//通过image组件创建打包工具packer
  const packOptions: image.PackingOption = {//使用PackingOption进行打包参数设定，比如格式、压缩质量等
    format: CommonConstants.ENCODE_FORMAT,//解码形式格式
    quality: CommonConstants.ENCODE_QUALITY//解码
  }
  const imageData = await imagePackerApi.packing(newPixelMap, packOptions);//打包成图片信息数据imageData
  Logger.info(TAG, `imageData's length is ${imageData.byteLength}`);
  //创建媒体资源
  let photoType: photoAccessHelper.PhotoType = photoAccessHelper.PhotoType.IMAGE;//使用phAccessHelper的createAsset，在图库中创建一个类型为PhotoType.IMAGE的媒体文件，并获取到新建文件的uri。
  let extension: string = 'jpg';
  phAccessHelper.createAsset(photoType, extension, (err, uri) => {
    if (uri != undefined) {
      let file = fileIo.openSync(uri, fileIo.OpenMode.READ_WRITE);//使用fileIo的openSync以及writeSync将打包好的图片信息数据imageData，写入新建文件中。
      fileIo.writeSync(file.fd, imageData);
      fileIo.close(file.fd);
    }
  });
}