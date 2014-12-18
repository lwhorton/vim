# Problems + Solutions

## UltiSnips filetype recognotion doesn't work
Vundle doesn't complete the installation process. UltiSnips needs a few more source files, but Vim only allows this directly in the home directory, so make a sym link:
```bash
mkdir -p ~/.vim/after/plugin
ln -s ~/.vim/bundle/ultisnip/after/plugin/* ~/.vim/after/plugin
mkdir ~/.vim/ftdetect
ln -s ~/.vim/bundle/ultisnip/ftdetect/* ~/.vim/ftdetect
```

## YouCompleteMe might need recompilation
```bash
cd ~/.vim/bundle/YouCompleteMe
./install.sh --clang-completer
```

## YouCompleteMe and UltiSnips don't get along
Due to the <template>-><tab> expand nature of UltiSnips, YouCompleteMe's tab to select is broken. This has been remapped using the help of SuperTab. Use <S-j> and <S-k> to move up/down auto-complete sections. I don't like that YCM puts the selection in the register and expects you to keep typing... it would be much nicer if you highlight the selection, hit enter, then keep typing (like every other auto-complete ever).
