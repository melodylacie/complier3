%{
#include "heading.h"
int yyerror(char *s);
int yylex(void);
int xtoi(char *hexstring);
void push(int value);
void pop(int index);
 
 /*-------------REG STRUCTURE-------------*/
int regToInt(char *reg);

int regArray[26] = {0};
int acc = 0;

 /*-------------STACK STRUCTURE-------------*/
struct stack {
    struct stack *prev;
    int     value;
};
struct stack *top;
int size = 0;

/*-------------ERROR FLAG-------------*/
bool topErr = false;
bool calErr	= false;

 
%}

%union{
  int		int_val;
  string*	op_val;
}

%start	input 

 
%token	<int_val>	INTEGER_LITERAL REG
%type	<int_val>	exp cmd ref

 

%left	PLUS MINUS
%left	MULT
%left	DIVIDE
%left	MOD
%left	OR
%left	AND
%left	NOT

%left ACC  
%left TOP  
%left SIZE  
%left PUSH  
%left POP  
%left SHOW  
%left LOAD  

%%

input:		
		| exp	{ if(!calErr)
					cout << "Result: " << $1 << endl; 
				  else
					calErr = false;
				}
		| cmd	{;}
		
		;

exp:	INTEGER_LITERAL		{ $$ = $1; }
		|ref				{ $$ = $1; }
 			
		| exp MINUS exp		{ $$ = $1 - $3; acc = $$; }
		| exp PLUS exp		{ $$ = $1 + $3; acc = $$; }
		
		| exp MULT exp		{ $$ = $1 * $3; acc = $$; }
		| exp DIVIDE exp	{ $$ = $1 / $3; acc = $$; }
		| exp MOD exp		{ $$ = $1 % $3; acc = $$; }
			
		| exp OR exp		{ $$ = $1 | $3; acc = $$; }
		| exp AND exp		{ $$ = $1 & $3; acc = $$; }
		| NOT exp			{ $$ = ~$2; acc = $$; }
		| MINUS exp			{ $$ = -$2; acc = $$; }
		| '(' exp ')' 		{ $$ = $2;  acc = $$; }
		;
 
cmd:	SHOW ref			{ 	if(!topErr)
								{
									$$ = $2; 
									cout << "Value: " << $2 << endl; 
								}else{
									cerr << "ERROR: Stack is Empty!" <<endl;
									topErr = false;
								}
							}
									
		|LOAD ref REG		{ 	if(!topErr)
								{
									regArray[$3] = $2;  
								}else{
									cerr << "ERROR: Stack is Empty!" <<endl;
									topErr = false;
								}
							}
		|PUSH ref			{ 	if(!topErr)
								{
									push($2);
								}else{
									cerr << "ERROR: Stack is Empty!" <<endl;
									topErr = false;
								}
							}
		|POP REG			{ pop($2); }
		
		
		;

ref:	REG					{ $$ = regArray[$1]; }
		|ACC				{ $$ = acc; }
		|TOP				{	if(size > 0)
									$$ = top->value;
								else
									topErr = true;
							}
		|SIZE				{ $$ = size; }
		;

%%

int xtoi(char *hexstring)
{
	int	i = 0;
	while (*(hexstring+1)) // ignore prelast = 'h|H'
	{
		char c = toupper(*hexstring++);
		if ((c < '0') || (c > 'F') || ((c > '9') && (c < 'A')))
			break;
		c -= '0';
		if (c > 9)
			c -= 7;
		i = (i << 4) + c;
	}
	return i;
}

int regToInt(char *reg){
	return ((int)*(reg+2)) - 65 ;
}

int yyerror(string s)
{
  extern char *yytext;	// defined and maintained in lex.c
  
  cerr << "ERROR: " << s << " at symbol \"" << yytext;
  calErr = true;
  return 0;
}

int yyerror(char *s)
{
  return yyerror(string(s));
}

void push(int value)
{
	struct stack *temp = new stack;
	temp->prev = top;
	temp->value = value;
	size++;
	top = temp;
}

void pop(int index)
{
	if(size > 0){
		regArray[index] = top->value;
		struct stack *temp;
		temp = top;
		top = top->prev;
		delete(temp);
		size--;
	}else{
		cerr << "ERROR: Stack is Empty!" <<endl;
	}
}