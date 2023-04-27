## OH-MY-ZSH INSTALL ##

# path to oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# THEME 
ZSH_THEME="robbyrussell"

# COMPLETION
# COMPLETION_WAITING_DOTS="true"

# PLUGINS
plugins=(git)

source $ZSH/oh-my-zsh.sh

# FLAGS
# export ARCHFLAGS="-arch x86_64"

# ALIASES

# SPEAKERS
# devialet git repositories folder
DVLT_GIT_PATH="${HOME}/Developments/devialet/git"

# devialet products ssh access repository
DVLT_SSH_KEYS_PATH="${DVLT_GIT_PATH}/ssh_keys"

DVLT_SSH_OPTS="-o 'PubkeyAcceptedKeyTypes +ssh-rsa' \
	-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
	-i ${DVLT_SSH_KEYS_PATH}/dev/id_rsa_dev \
	-i ${DVLT_SSH_KEYS_PATH}/sav2/id_rsa_sav \
	-i ${DVLT_SSH_KEYS_PATH}/sav/id_rsa_sav"

alias sshwk="ssh ${DVLT_SSH_OPTS}"
alias scpwk="scp ${DVLT_SSH_OPTS}"
alias gcl="git clone"
