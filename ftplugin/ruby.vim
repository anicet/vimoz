" Use Ruby syntax check when doing :make                                                                                                                
set makeprg=ruby\ -c\ %                                                                                                                            
                                                                                                                                                       
" Parse PHP error output                                                                                                                             
set errorformat=%m\ in\ %f\ on\ line\ %l                                                                                                             
                                                                                                                                                     
noremap ; :make<CR>