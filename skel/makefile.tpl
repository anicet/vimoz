##############################
# Complete this to make it ! #
##############################

NAME 	=		# Name of executable file
SRC	=		# List of *.c
INCL  	=		# List of *.h

################
# Optional add #
################

IPATH   = -I.           # path of include file
OBJOPT  = -g2           # option for obj
EXEOPT  = -g2           # option for exe (-O2 -g2 -w -lm etc ...)
LPATH   = -L.           # path for librairies ... 

#####################
# Macro Definitions #
#####################

CC 	= cc
MAKE 	= make
SHELL	= /bin/sh
OBJS 	= $(SRC:.c=.o) 
RM 	= /bin/rm -f 	
COMP	= gzip -9v
UNCOMP	= gzip -df
STRIP	= strip

CFLAGS  = $(OBJOPT) $(IPATH)
LDFLAGS = $(EXEOPT) $(LPATH)

.SUFFIXES: .h.Z .c.Z .h.gz .c.gz .c.z .h.z 

##############################
# Basic Compile Instructions #
##############################

$(NAME): $(OBJS) $(SRC) $(INCL)  
	$(CC) $(OBJS) $(LDFLAGS) -o $(NAME) 
#	$(STRIP) ./$(NAME) # if you debug ,don't strip ...

depend:
	gcc $(IPATH) -MM $(SRC) 
clean:
	-$(RM) $(NAME) $(OBJS) *~
comp: clean
	$(COMP) $(INCL) $(SRC)
ucomp: 
	$(UNCOMP) $(SRC) $(INCL)

.c.Z.c .h.Z.h .c.gz.c .h.gz.h .c.z.c .h.z.h :
	 -$(UNCOMP) $<

.c.o:
	$(CC) $(CFLAGS) -c $< 

################
# Dependencies #
################
