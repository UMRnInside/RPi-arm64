# RPi-arm64
为树莓派3构建基于Debian ARM64 的操作系统。

目前支持:

* **Stage 1:** 下载、准备、编译内核
* **Stage 2:** 使用 _debootstrap_ 构建根文件系统
* **Stage 3:** 安装bootcode和VideoCore libs
* **Stage 4:** 离线操作 (例如添加用户)

************
广告:
树莓派64位系统交流群(QQ):697381661

预构建版本：[百度云](http://pan.baidu.com/s/1hsZVl1i)

如果您想要 _原汁原味（？）_ 的 _Ubuntu_ ：[chainsx/ubuntu64-rpi](https://github.com/chainsx/ubuntu64-rpi)

## 简明指南
这个是 _真正的简明指南_

1. `./build.sh`
2. 喝杯茶，不过喝杯咖啡也行

不过，如果您想手动更改某些设置……

1. `cp rpi3_defconfig config`
2. 按需编辑 `config`
3. `./build.sh`
4. 喝杯茶/咖啡/可乐……

> ご注文は うさぎ ですか？

> 请问您今天要来点兔子吗？

## 使用Docker
1. `cp rpi3_defconfig config`
2. 按需编辑 `config`
3. `./build_docker.sh`

## 参数
阅读每个阶段(stage)内的`README.md`，或者认真阅读默认配置： `rpi3_defconfig`
