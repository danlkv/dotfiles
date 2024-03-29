" ============================================================
" light_carrot
" 
" URL:https://github.com/pineapplegiant/light_carrot
" Author: Danylo Lykov
" License: MIT
" Last Change: 2023/02/17
" ============================================================

let g:airline#themes#light_carrot#palette = {}

let s:normal1 = [ "#30365F", "#AFC5DC", 0, 237 ] " background
let s:normal2 = [ "#6C839B", "#AFC5DC", 237, 60 ] " filename
let s:normal3 = [ "#6C839B", "#AFC5DC", 237, 60 ] 
let g:airline#themes#light_carrot#palette.normal = airline#themes#generate_color_map(s:normal1, s:normal2, s:normal3)

let s:insert1 = [ "#000000", "#778348", 0, 78 ]
let s:insert2 = [ "#1A3730", "#C2C1B0", 237, 60 ] " filename
let s:insert3 = [ "#6C839B", "#C2C1B0", 237, 60 ]
let g:airline#themes#light_carrot#palette.insert = airline#themes#generate_color_map(s:insert1, s:insert2, s:insert3)

let s:replace1 = [ "#000000", "#7a5ccc", 0, 98 ]
let s:replace2 = [ "#30365F", "#686f9a", 237, 60 ]
let s:replace3 = [ "#30365F", "#686f9a", 237, 60 ]
let g:airline#themes#light_carrot#palette.replace = airline#themes#generate_color_map(s:replace1, s:replace2, s:replace3)

let s:visual1 = [ "#000000", "#F2D590", 0, 220 ]
let s:visual2 = [ "#30365F", "#C3AA92", 237, 60 ]
let s:visual3 = [ "#30365F", "#C3AA92", 237, 60 ]
let g:airline#themes#light_carrot#palette.visual = airline#themes#generate_color_map(s:visual1, s:visual2, s:visual3)

let s:inactive1 = [ "#303650", "#AEB0B3", 0, 237 ] " background
let s:inactive2 = [ "#BEC0D8", "#FCE3DD", 237, 60 ]
let s:inactive3 = [ "#88939B", "#B8BABD", 237, 60 ] " filename
let g:airline#themes#light_carrot#palette.inactive = airline#themes#generate_color_map(s:inactive1, s:inactive2, s:inactive3)

if !get(g:, 'loaded_ctrlp', 0)
  finish
endif

let s:CP1 = [ "#ecf0c1", "#0f111b", 255, 233 ]
let s:CP2 = [ "#ecf0c1", "#0f111b", 255, 233 ]
let s:CP3 = [ "#ecf0c1", "#0f111b", 255, 233 ]

let g:airline#themes#light_carrot#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(s:CP1, s:CP2, s:CP3)

" ===================================
" Generated by Estilo 1.4.1
" https://github.com/jacoborus/estilo
" ===================================
