# ~/.profile: executed by Bourne-compatible login shells.

if [ -f ~/.bashrc ]; then
  . ~/.bashrc
elif [ -f /etc/skel/.bashrc ]; then
  . /etc/skel/.bashrc
fi

# path set by /etc/profile
# export PATH

mesg n
