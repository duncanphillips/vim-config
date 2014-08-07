# Vim config files

## Requires:

vim custom build with:

- python
- ruby
- perl
- utf-8

## Install:
```bash
git clone https://github.com/gmarik/vundle.git ~/vim-config/.vim/bundle/vundle
ln ~/vim-config/.vim ~/.vim                     
ln ~/vim-config/.vimrc ~/.vimrc                 
ln ~/vim-config/.vimrc.bundles ~/.vimrc.bundles 
vim +BundleInstall +qall                        
cd .vim/bundle/Command-T/ruby/command-t/ && ruby extconf.rb && make && cd -
```
