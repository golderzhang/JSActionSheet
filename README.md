# JSActionSheet

JSActionSheet是一款iOS扁平化的ActionSheet，简单易用。

# 如何使用

- 下载工程Demo文件，拷贝JSActionSheet.h与JSActionSheet.m文件到需要的工程
- 在需要的地方#import "JSActionSheet.h"即可

``` objective-c

JSActionSheet *sheet = [JSActionSheet actionSheetWithTitle:@"选择照片"];
[sheet addAction:[JSAction actionWithTitle:@"照片库" actionStyle:JSActionStyleDefault handler:^(JSAction *action) {

}]];
[sheet addAction:[JSAction actionWithTitle:@"相机" actionStyle:JSActionStyleDefault handler:^(JSAction *action) {

}]];
[sheet addAction:[JSAction actionWithTitle:@"取消" actionStyle:JSActionStyleCancel handler:^(JSAction *action) {

}]];
[sheet show];

```

# 注意

- 避免引用循环
- 在主线程调用
