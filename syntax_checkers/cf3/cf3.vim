"============================================================================
"File:        cfengine.vim
"Description: Check cfengine syntax using 'cf-promises -I -f'
"Maintainer:  Anthonin Bonnefoy <anthonin.bonnefoy@gmail.com>
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"
"============================================================================
"
" You need the cf-promises in ~/.cfagent/bin/cf-promises when editing policy as a user.
"
" The error format works on cfengine 3.5.1
" It expects a cf3 filetype, so add to your vimrc
" au BufRead,BufNewFile *.cf set ft=cf3

if exists("g:loaded_syntastic_cf3_cfpromises_checker")
    finish
endif
let g:loaded_syntastic_cf3_cfpromises_checker=1

if executable(expand('~') . '/.cfagent/bin/cf-promises')
        let g:syntastic_cf3_cfpromises_path=expand('~').'/.cfagent/bin/cf-promises'
elseif executable('cf-promises')
        let g:syntastic_cf3_cfpromises_path='cf-promises'
elseif executable('/var/cfengine/bin/cf-promises')
        let g:syntastic_cf3_cfpromises_path='/var/cfengine/bin/cf-promises'
endif

function! SyntaxCheckers_cf3_cfpromises_IsAvailable()
    return executable(g:syntastic_cf3_cfpromises_path)
endfunction

function! SyntaxCheckers_cf3_cfpromises_GetLocList()
    let makeprg = g:syntastic_cf3_cfpromises_path . ' -I -f ' . expand('%:p')
    let errorformat = '%f:%l:%c:\ error:\ %m,%-G%.%#'
    let errors = SyntasticMake({ 'makeprg': makeprg, 'errorformat': errorformat })
    return errors
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'cf3',
    \ 'name': 'cfpromises'})
