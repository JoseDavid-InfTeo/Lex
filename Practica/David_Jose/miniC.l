%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
int ints = 0, floats = 0, ifs = 0, mains = 0, elses = 0, scanfs = 0, printfs = 0, lineasTotales = 0, lineasComentario = 0, idents = 0, cadenas = 0, numeros = 0;
int llaves = 1, parentesis = 1, parent = 0, llav = 0;
char *identificadores[100][100];
char *cads[100][100];
char *nums[100][100];

struct identificador
{
	char nombre[100];
	char tipo[10];
};

struct nodoIdent
{ 
	struct identificador ident;
	struct nodoIdent *sig;
	struct nodoIdent *ant;
};

struct listaIdents
{
	struct nodoIdent *pri;
	struct nodoIdent *ult;
};

%}

letra [a-zA-Z]
natural [0-9]
nodigitos [_a-zA-Z]
separadores [,;(){}]
input [^\r\n]
operador [+*=&"&&"]
blanco (" ")+
tabulacion \t
eol (\n|\r|\r\n)
numero ({natural}+("."{natural}+)?)
ident {letra}({nodigitos}|{natural})*
variables ((("int"|"float"){blanco}+{ident})(","{blanco}*{ident})*";")
coment ("//"{input}*{eol}?)
cadena \"(\\.|[^\\"])*\"
llaves [(){}]

%%

"printf"	printfs++;
"if"		ifs++;
"else"		elses++;
"main"		mains++;
"scanf"		scanfs++;

{llaves} {

	if(strcmp("(",yytext) == 0)
	{
		parent++ ;
	}

	if(strcmp(")",yytext) == 0)
	{
		if (parent < 1) 
		{
			parentesis = 0;
		}else{
			parent-- ;
		}
	}

	if(strcmp("{",yytext) == 0)
	{
		llav++ ;
	}

	if(strcmp("}",yytext) == 0)
	{
		if (llav < 1)
		{
			llaves = 0;
		}else{
			llav-- ;
		}
	}
}

{variables} {
	char entrada[100];
	char bufer[100];
	int cursor = 0, i, j;
	strcpy(entrada, yytext);
	for (i = 0; i < yyleng; i++)
	{
		//Caso int
		if (entrada[0] == 'i' && i > 3)
		{
			//Si es coma o punto-coma
			if (entrada[i] == ',' || entrada[i] == ';')
			{
				//Introducimos caracter a caracter el contenido del bufer
				for (j = 0; j < cursor; j++)
				{
					identificadores[idents][j] = bufer[j];
				}
				cursor = 0;
				idents++;
				ints++;
			}else
			{		
				bufer[cursor] = entrada[i];
				cursor++;
			}
		}

		//Caso float
		if (entrada[0] == 'f'  && i > 5)
		{
			//Si es coma o punto-coma
			if (entrada[i] == ',' || entrada[i] == ';')
			{
				for (j = 0; j < cursor; j++)
				{
					identificadores[idents][j] = bufer[j];
				}
				cursor = 0;
				idents++;
				floats++;
			}else
			{
				bufer[cursor] = entrada[i];
				cursor++;
			}
		}
	}
}

{cadena} {
	char entrada[100];
	int i;
	strcpy(entrada, yytext);
	for (i = 0; i < yyleng; i++)
	{
		cads[cadenas][i] = entrada[i];	
	} 
	cadenas++;
}

{numero} { 
	char entrada[100];
	int i;
	strcpy(entrada, yytext);
	for (i = 0; i < yyleng; i++)
	{
		nums[numeros][i] = entrada[i];	
	} 
	numeros++; 
}

{coment} {
	lineasComentario++ ;
	lineasTotales++;
}

{eol} {
	lineasTotales++;
}

{separadores} {

}

{operador} 	  {

}

{nodigitos}	  {

}

{blanco} {

}

{tabulacion} {

}

. {
	printf("Error en linea %d [%s]\n",lineasTotales+1, yytext);
} ;

%%

int main()
{	
	char nombre[100];
	yyin = fopen ("../data/entrada.c","r");
	
	if (yyin != NULL)
	{
		yylex();
	}
	printf("----------------------------------\nNumero de variables:\n\t");
	printf("ints: %d, floats: %d, if: %d, main: %d, else: %d, scanf: %d, printf: %d\n",ints, floats, ifs, mains, elses, scanfs, printfs);
  	printf("----------------------------------\nNumero de lineas:\n\t");
  	printf("comentario: %d - codigo: %d - totales: %d\n",lineasComentario, lineasTotales-lineasComentario, lineasTotales);
  	printf("----------------------------------\n");
  	printf("Idents: \n\t");

  	for (int i = 0; i < idents; i++)
  	{
  		int j = 0;
  		while (identificadores[i][j] != '\0')
  		{
	  		printf("%c", identificadores[i][j]);
	  		j++;
  		}
  		printf(" ");
	  	
  	}

  	printf("\n");
  	printf("----------------------------------\n");
  	printf("Balanceo de llaves:\n");
  	if (parentesis == 1 && parent == 0 ) 
    {
    	printf("\tLos parentesis estan bien balanceados :)\n");
  	}else{
  		printf("\tLos parentesis estan MAL balanceados :(\n");
  	}
  	if (llaves == 1 && llav == 0 ) 
    {
    	printf("\tLas llaves estan bien balanceadas :)\n");
  	}else{
  		printf("\tLas llaves estan MAL balanceadas :(\n");
  	}
  	printf("----------------------------------\n");
  	printf("Constantes:\n\tCadenas: ");

  	for (int i = 0; i < cadenas; i++)
  	{
  		int j = 0;
  		while (cads[i][j] != '\0')
  		{
	  		printf("%c", cads[i][j]);
	  		j++;
  		}
  		printf(" ");
	  	
  	}

  	printf("\n\tNumericas: ");
  	for (int i = 0; i < numeros; i++)
  	{
  		int j = 0;
  		while (nums[i][j] != '\0')
  		{
	  		printf("%c", nums[i][j]);
	  		j++;
  		}
  		printf(" ");
	  	
  	}
  	printf("\n\n");
}

int yywrap()
{
	return 1;
}

//Webgrafia
//http://www.lysator.liu.se/c/ANSI-C-grammar-l.html