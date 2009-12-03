" Use PHP syntax check when doing :make                                                                                                                
set makeprg=php\ -l\ %                                                                                                                                 
                                                                                                                                                       
" Parse PHP error output                                                                                                                             
set errorformat=%m\ in\ %f\ on\ line\ %l                                                                                                             
                                                                                                                                                     
noremap ; :make<CR>
