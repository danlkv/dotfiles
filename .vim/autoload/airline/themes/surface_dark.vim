" ============================================================
" Surface dark
" 
" URL:https://github.com/danlkv/surface_colortheme
" Author: Danylo Lykov
" License: MIT
" Last Change: 2023/02/17
" ============================================================
let g:airline#themes#surface_dark#palette = {}

let s:normal1 = [ "#000000", "#201827", 0, 237 ]
let s:normal2 = [ "#345862", "#1B1520", 237, 60 ]
let s:normal3 = [ "#345862", "#1B1520", 237, 60 ]
let g:airline#themes#surface_dark#palette.normal = airline#themes#generate_color_map(s:normal1, s:normal2, s:normal3)

let s:insert1 = [ "#000000", "#3c6c36", 0, 78 ]
let s:insert2 = [ "#686f9a", "#30365F",  60, 237]
let s:insert3 = [ "#686f9a", "#30365F",  60, 237]
let g:airline#themes#surface_dark#palette.insert = airline#themes#generate_color_map(s:insert1, s:insert2, s:insert3)

let s:replace1 = [ "#000000", "#7a5ccc", 0, 98 ]
let s:replace2 = [ "#30365F", "#686f9a", 237, 60 ]
let s:replace3 = [ "#30365F", "#686f9a", 237, 60 ]
let g:airline#themes#surface_dark#palette.replace = airline#themes#generate_color_map(s:replace1, s:replace2, s:replace3)

let s:visual1 = [ "#000000", "#826e00", 0, 220 ]
let s:visual2 = [ "#686f9a", "#30365F",  237, 60 ]
let s:visual3 = [ "#686f9a", "#30365F", 237, 60 ]
let g:airline#themes#surface_dark#palette.visual = airline#themes#generate_color_map(s:visual1, s:visual2, s:visual3)

let s:inactive1 = [ "#000000", "#101820", 0, 237 ] 
let s:inactive2 = [ "#27424A", "#131015", 237, 60 ]
let s:inactive3 = [ "#27424A", "#131015", 237, 60 ]
let g:airline#themes#surface_dark#palette.inactive = airline#themes#generate_color_map(s:inactive1, s:inactive2, s:inactive3)

if !get(g:, 'loaded_ctrlp', 0)
  finish
endif

let s:CP1 = [ "#ecf0c1", "#0f111b", 255, 233 ]
let s:CP2 = [ "#ecf0c1", "#0f111b", 255, 233 ]
let s:CP3 = [ "#ecf0c1", "#0f111b", 255, 233 ]

let g:airline#themes#surface_dark#palette.ctrlp = airline#extensions#ctrlp#generate_color_map(s:CP1, s:CP2, s:CP3)

