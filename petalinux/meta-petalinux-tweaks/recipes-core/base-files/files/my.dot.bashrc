# ~/.bashrc: executed by bash(1) for non-login shells.

export PS1='\h:\w\$ '
export XILINX_XRT='/usr'
umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

# Create an rsync alias for large file copies
alias ccp='rsync --info=progress2'
