" Vim syntax file
" Language: Vector Remap Language
" Maintainer: banst
" Latest Revision: 26 March 2021

if exists("b:current_syntax")
  finish
endif

" Comments;
syn keyword vrlTodo contained TODO FIXME XXX BUG
syn cluster vrlCommentGroup contains=vrlTodo

syn region vrlComment start="#" end="$" contains=@vrlCommentGroup,@Spell

hi def link vrlComment Comment
hi def link vrlTodo Todo

" Keywords;
syn keyword vrlStatement abort break continue return
syn keyword vrlConditional else if then
syn keyword vrlRepeat for in loop until while
syn keyword vrlDeclType type

hi def link vrlStatement Statement
hi def link vrlConditional Conditional
hi def link vrlRepeat Repeat
hi def link vrlDeclType Type

" Predefined functions and values
syn keyword vrlBoolean false true
syn keyword vrlPredefinedIdentifiers null

hi def link vrlBoolean Boolean
hi def link vrlPredefinedIdentifiers vrlBoolean

" Strings
syn region vrlString start=+"+ skip=+\\\\\|\\"+ end=+"+

hi def link vrlString String

" Float
syn match       vrlFloat             "\<-\=\d\+\.\d*\%([Ee][-+]\=\d\+\)\=\>"
syn match       vrlFloat             "\<-\=\.\d\+\%([Ee][-+]\=\d\+\)\=\>"

hi def link     vrlFloat             Float

" Integes
syn match vrlInt "\<-\=\(0\|[1-9]_\?\(\d\|\d\+_\?\d\+\)*\)\%([Ee][-+]\=\d\+\)\=\>"

hi def link vrlInt Integer
