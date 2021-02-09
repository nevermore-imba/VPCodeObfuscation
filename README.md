# VPCodeObfuscation
Objective-C项目自动代码混淆，暂不支持Swift

# 文件说明

## vp_confuse.sh 
这是一个可以执行的脚本，帮助我们生成混淆代码所需文件

以下文件都是在`vp_confuse.sh`执行后，自动生成：

## VPCodeConfuscationMacros.h
该文件采用宏的形式，分别罗列出需要混淆的关键字及各自随机生成的替换的字符串。

## vp_func.list
该文件罗列出了需要混淆的关键字，跟`VPCodeConfuscationMacros.h`一一对应

## vp_repCustom.list
默认是没有内容的表单，如果需要对指定的关键字进行混淆，那么你可以将其加入该文件中。如果有多个关键字，请逐行加入该表单中。

## vp_resCustom.list
默认是没有内容的表单，如果不希望指定的关键字被混淆，你可以将其加入该文件中。如果有多个关键字，请逐行加入该表单中。

## vp_reservedKeywords.list
默认是没有内容的表单，它跟`vp_resCustom.list`表单是同一个意思，不过里面加入的是Apple系统的APIs关键字，该表单中所添加的系统关键字不会被混淆。

## vp_specifiedFile.list
默认是没有内容的表单，我们可以指定需要混淆的文件。比如我们只需要混淆VPViewController.[mh]这两个文件，你只需将文件的名称`VPViewController`添加到该表单即可，当然也可以逐行分别写入表单。

## vp_excludeFile.list
该表单会默认添加一些文件或者文件夹名称，表示需要排除的文件或者文件夹，该文件或者文件夹下的文件将不会参与混淆，比如我们用到的第三方库就可以加到该表单中。
