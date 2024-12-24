# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin:/mnt/binf/rui/bin:/mnt/binf/rui/bin/ncbi-blast-2.15.0+/bin
PATH=$PATH:$HOME/.local/bin:$HOME/bin:/mnt/binf/rui/bin:/mnt/binf/rui/bin/software/bin:/mnt/binf/rui/bin/jars/VarDict-1.8.3/bin:/mnt/binf/rui/bin/sratoolkit.3.1.1-centos_linux64/bin

export PATH

##### set Terminal
export PS1="\[\033]2;\h:\u \w\007\033[33;1m\]\u \033[35;1m\t\033[0m \[\033[36;1m\]\w\[\033[0m\]\n\[\e[32;1m\]$\[\e[0m\]"
export PS1="\[\e[33;1m\]\u@\h \[\e[35;1m\]\t \[\033[36;1m\]\w\[\033[0m\]\n\[\e[32;1m\]$ \[\e[0m\]"

#####User specific aliases and functions
extract () {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
             esac
         else
             echo "'$1' is not a valid file"
         fi
    }

function mcd { mkdir -p "$1" && cd "$1";}



##### alias
alias le='less -NS'
alias zle='zless -NS'
alias ll='ls -lFhG'
alias la='ls -A'
alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'
alias grep='grep --color=auto'

###############
export PURECN='/usr/local/lib64/R/library/PureCN/extdata'
export hs37d5='/mnt/binf/rui/database/reference/hs37d5/hs37d5.fa'
export hs37d5gz='/mnt/binf/rui/database/reference/hs37d5/hs37d5.fa.gz'
export PATH=/mnt/binf/rui/bin/jdk-17.0.2/bin:$PATH
