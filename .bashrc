# ~/.bashrc

[[ $- != *i* ]] && return #...................................................... done ... Asegura de cargar este archivo en terminal activa exclusivamente.

PS1='[\u@\aarch \W]\$ '

~/.bash_aliases #................................................................ done ... Carga el archivo bash_aliases personalizado.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
