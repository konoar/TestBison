############################################
#
# Bison Test
#   copyright 2019.06.10 konoar
#
############################################

TARGETBIN := ./testbin

.PHONY: clean run

run: $(TARGETBIN)
	@-$(TARGETBIN)

clean:
	@-rm $(TARGETBIN) flex.c flex.h bison.c bison.h

$(TARGETBIN): main.c flex.l bison.y
	@flex  -o flex.c flex.l
	@bison -o bison.c -d bison.y
	@gcc   -o $(TARGETBIN) main.c flex.c bison.c 2> /dev/null

