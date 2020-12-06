set -e

# 创建临时文件夹
mkdir install_vim_tmp
cd install_vim_tmp

# 下载安装  ncurses 库
rm -rf ncurses-6.1.tar.gz
rm -rf ncurses-6.1
wget -c --limit-rate=30m https://raw.githubusercontent.com/HuStanding/vim8/master/ncurses-6.1.tar.gz -O  ncurses-6.1.tar.gz

tar -xzvf ncurses-6.1.tar.gz
mkdir -p ~/.local
cd ncurses-6.1
./configure --prefix= /home/"$USER"/.local/dependency/ncurses6.1
make
make install

cd ..

# 下载安装 vim8
rm -rf vim.tar
rm -rf ./vim
wget -c --limit-rate=30m https://raw.githubusercontent.com/HuStanding/vim8/master/vim.tar -O vim.tar 
tar -xvf vim.tar
cd ./vim
./configure \
--with-features=huge \
--enable-multibyte \
--enable-rubyinterp \
--enable-pythoninterp=yes \
--enable-luainterp \
--enable-gui=gtk2 \
--enable-cscope \
--prefix=/home/"$USER"/.local/software/vim8 CFLAGS="-I/home/"$USER"/.local/dependency/ncurses6.1/include" LDFLAGS="-L/home/"$USER"/.local/dependency/ncurses6.1/lib"

make
make install

cd ..


# 拷贝vim 插件
mkdir -p ~/.local/vim_rc_back_up
# 备份原始文件
if [ -f ~/.vimrc ]; then
        cp -rf ~/.vimrc   ~/.local/vim_rc_back_up/
fi
if [ -f ~/.vimrc.bundles ]; then
        cp -rf ~/.vimrc.bundles   ~/.local/vim_rc_back_up/
fi
if [ -d ~/.vim ]; then
        cp -rf ~/.vim   ~/.local/vim_rc_back_up/
fi
if [ -f ~/.bashrc ]; then
        cp -rf ~/.bashrc   ~/.local/vim_rc_back_up/
fi

# .vim 插件文件夹
rm -rf huzhu_vim.zip
rm -rf ./.vim
wget -c --limit-rate=30m https://raw.githubusercontent.com/HuStanding/vim8/master/huzhu_vim.zip -O huzhu_vim.zip 
unzip huzhu_vim.zip
rm -rf ~/.vim
cp -r ./.vim ~/

# .vim 文件夹
rm -rf vim_src.zip
rm -rf ./vim_src
wget -c --limit-rate=30m https://raw.githubusercontent.com/HuStanding/vim8/master/vim_src.zip -O vim_src.zip 

unzip vim_src.zip

cp ./vim_src/.vimrc ~/
cp ./vim_src/.vimrc.bundles  ~/

# 安装pip 依赖包
pip install jedi==0.12.1 -i https://mirrors.cloud.tencent.com/pypi/simple --user
pip install isort==4.3.4 -i https://mirrors.cloud.tencent.com/pypi/simple --user
pip install pylint -i https://mirrors.cloud.tencent.com/pypi/simple --user
pip install yapf==0.30.0 -i https://mirrors.cloud.tencent.com/pypi/simple --user

echo '# vim8 alias' >> ~/.bashrc
echo 'alias vim="${HOME}/.local/software/vim8/bin/vim"' >> ~/.bashrc
# 将 ~/.local/bin 加入环境变量
echo 'export PATH="${HOME}/.local/bin:$PATH"' >> ~/.bashrc

cd ..
rm -rf ./install_vim_tmp

echo 'congratulations， you have installed vim8 successfully.'
echo 'And your origin vimrc、vimrc.bundles 、.vim were moved to ~/.local/vim_rc_back_up/'
echo 'now please run: source  ~/.bashrc'
echo 'enjoy it~'
