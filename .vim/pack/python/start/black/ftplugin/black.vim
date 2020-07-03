" Add mappings, unless the user didn't want this.
" The default mapping is registered under to <F7> by default, unless the user
" remapped it already (or a mapping exists already for <F7>)
if !exists("no_plugin_maps") && !exists("no_flake8_maps")
    if !hasmapto('Flake8(') && !hasmapto('flake8#Flake8(')
	nnoremap <F9> :Black<CR>
    endif
endif

