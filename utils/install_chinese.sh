#fuck raspbian and rime
#sudo rm -rf ~/.config/fcitx
#sudo apt install ibus-rime
#sudo apt install fcitx-rime
#!/bin/bash
#sudo apt update
. $(dirname $0)/../global_definitions

#常用工具
chroot $ROOT_PATH apt install ttf-wqy-zenhei fcitx-googlepinyin -y
