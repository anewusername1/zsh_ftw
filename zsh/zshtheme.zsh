if [ ! "$ZSH_THEME" = "" ]; then
  source "$ZSH/themes/$ZSH_THEME.zsh-theme"
else
  source "$ZSH/themes/default.zsh-theme"
fi
