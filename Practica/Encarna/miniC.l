%{

#include <stdio.h>
#include <string.h>
int ints = 0, floats = 0, ifs = 0, mains = 0, elses = 0, scanfs = 0, printfs = 0, lineasCodigo = 0, lineasComentario = 0, idents = 0;

%}

letra [a-zA-Z]
natural [0-9]
nodigitos [_a-zA-Z]
puntuacion [,;)}]
input [^\r\n]
operador [+*=&]
operador2 ("&&")
blanco (" ")
eol (\n|\r|\r\n)
numero ({natural}+("."{natural}+)?)
ident {letra}({nodigitos}|{natural})*
coment ("//"{input}*{eol}?)

%%

"printf"	printfs++;
"int"		ints++;
"float"		floats++;
"if"		ifs++;
"else"		elses++;
"main"		mains++;
"scanf"		scanfs++;

{ident} {
	idents++;
	//fprintf("identOutput.txt",,)
    printf("\n identificador");
}

{coment} {
	lineasComentario++;
    printf("\n Comentario");
}

.   {printf("\n otro");}
\n  {printf("salto");}

%%

int main()
{	
	char nombre[100];
	yyin = fopen ("../data/entrada.c","r");
	if (yyin != NULL)
	{
		yylex();
	}
	printf("\nints: %d floats: %d if: %d, main: %d, else: %d, scanf: %d, printf: %d\n",ints, floats, ifs, mains, elses, scanfs, printfs);
  	printf("Numero lineas comentario: %d\n",lineasComentario);
  	printf("Idents: %d\n", idents);
}

int yywrap()
{
	return 1;
}
