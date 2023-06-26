all:
	@mkdir -p "${HOME}/.config/nvim"
	@ln -Fis "${CURDIR}/nvimrc" "${HOME}/.config/nvim/init.vim"
	@ln -Fis "${CURDIR}/vimrc" "${HOME}/.vimrc"
