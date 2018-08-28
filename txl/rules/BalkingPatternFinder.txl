% Balking Pattern (a Concurrency Design Pattern) Finder for Java Concurrent Software
% Martin Mwebesa
% UOIT, February 12, 2011

% include "Java.Grm"
% include "JavaCommentOverrides.Grm"
include "../helper.txl"

redefine annotation
	[annotation2]
end redefine

define annotation2
   [SPOFF] '@ [reference] [opt '@] [SPON] [opt annotation_value_spec] [NL]
end define

% redefine method_declaration
	% [attr labelM] [NL] [repeat annotation] [method_declaration2]
	% | [method_declaration2]
% end redefine

redefine method_declaration
	[method_declaration2]
	| [attr labelM] [NL] [method_declaration2]
	| [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL] [method_declaration2]
end redefine

define method_declaration2
    [repeat modifier] [type_specifier] [method_declarator] [opt throws] [method_body]
end define

redefine variable_declaration
	[variable_declaration2]
    | [attr labelM] [repeat modifier] [type_specifier] [variable_declarators] '; [NL]
end redefine

define variable_declaration2
    [repeat modifier] [type_specifier] [variable_declarators] '; [NL]
end define

redefine synchronized_statement
	[synchronized_statement2]
	| 'synchronized '( [expression] ')
	'{
		[statement]
	'}                 [NL]
end redefine

define synchronized_statement2
    'synchronized '( [expression] ')
        [statement]                  [NL]
end define

redefine if_statement
	[if_statement2]
    | 'if '( [expression] ')
		[statement]
    [opt else_clause]      [NL]
	| [attr labelM]
	'if '( [expression] ')
		[statement]
    [opt else_clause]      [NL]
	| [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL]
	'if '( [expression] ')
		[statement]
    [opt else_clause]      [NL]
end redefine

define if_statement2
    'if '( [expression] ')
        [statement]
    [opt else_clause]      [NL]
end define

redefine else_clause
	[else_clause2]
    | 'else
		[statement]
	| [attr labelM]
	'else
		[NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL]
		[statement]
end redefine

define else_clause2
    'else
        [statement]
end define

redefine expression
	[expression2]
	| [attr labelM] [NL] [expression2]
	| [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL] [expression2]
end redefine

define expression2
    [assignment_expression]
end define

redefine return_statement
	[return_statement2]
	| [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL] 'return [opt expression] ';      [NL]
end redefine

define return_statement2
    'return [opt expression] ';      [NL]
end define


% Main functions of the this Balking design pattern finder program.
function main
	export idCollection [repeat id]
		_
	export MethodIDs [repeat id]
		_
	export BalkingFlagIDs [repeat id]
		_
	export Counter [number]
		0
	export tmpCounter [number]
		0

    replace [program]
        P [program]
	construct TransformedProgram [stringlit]
		"TransformedForBalkingPatt.java"
	by
        P [GetAllBooleanVariables] [findBalkingPatternSynchMod] [findBalkingPatternSynchMod2] [printPatternNotFound] [printOutput] [printMethodIDs]
		[fput TransformedProgram]
end function

function printPatternNotFound
	replace [program]
		P [program]

	import Counter [number]

	where
		Counter [= 0]

	construct InstanceFound [stringlit]
		"*** No instances of Balking Pattern found. "

	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]

	by
		P
end function

% Function print out the number of Balking design pattern instances found.
function printOutput
	replace [program]
		P [program]
	import Counter [number]
	where
		Counter [> 0]
	construct InstanceFound [stringlit]
		"** Instances of Balking Pattern found = "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ Counter] [print]
	by
		P
end function

% Function to print out the names of the methods that use the Balking design pattern.
% The number of these methods should equal the number of instances printed out in the "printOutput" function.
function printMethodIDs
	replace [program]
		P [program]
	import Counter [number]
	import MethodIDs [repeat id]
	where
		Counter [> 0]
	construct InstanceFound [stringlit]
		"** Method instances with using the Balking Design Pattern:  "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]
	construct InstanceFoundPrint2 [id]
		_ [thePrintMethodIDs each MethodIDs]
	by
		P
end function

% Function to aid in the printing of the method names in the function "printMethodIDs".
function thePrintMethodIDs theID [id]
	construct InstanceFound [stringlit]
		"   "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]
	replace [program]
		P [program]
	by
		P
end function

% Function to print out the names of the flags that enabling the balking to occur in the methods printed out in the "printMethodIDs" function.
% The number of these methods should equal the number of instances printed out in the "printOutput" function.
function printBalkFlagIDs
	replace [program]
		P [program]
	import Counter [number]
	import BalkingFlagIDs [repeat id]
	where
		Counter [> 0]
	construct InstanceFound [stringlit]
		"** Methods above respectively use the following Balking flags:  "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]
	construct InstanceFoundPrint2 [id]
		_ [thePrintBalkFlagIDs each BalkingFlagIDs]
	by
		P
end function

% Function to aid in the printing of the Balking flag names in the function "printBalkFlagIDs".
function thePrintBalkFlagIDs theID [id]
	construct InstanceFound [stringlit]
		"   "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]
	replace [program]
		P [program]
	by
		P
end function

% Function to obtain all boolean variables declared globally in the Java program hence obtaining all flags
% that could potentially be used to aid in balking.
rule GetAllBooleanVariables
	construct  VARTYPE [type_specifier]
		'boolean
	replace [variable_declaration]
		RM [repeat modifier] TS [type_specifier] VDS [variable_declarators] ';
	where
		 TS [isVarOfType VARTYPE]
	deconstruct VDS
		LVD [list variable_declarator+]
	deconstruct LVD
		VN [variable_name] OEVI [opt equals_variable_initializer]
	deconstruct VN
		DN [declared_name] RD [repeat dimension]
	deconstruct DN
		flagID [id] OGP [opt generic_parameter]
	import idCollection [repeat id]
	construct newIDCollection [repeat id]
		idCollection [. flagID]
	export idCollection
		newIDCollection

	by
		'MUTATED RM TS VDS ';
end rule


% //**************************************************************************************//
% //*** Balking pattern allows for an object�s method(s) to return without doing any   ***//
% //*** processing if the object is not in an appropriate state to execute the method. ***//
% //**************************************************************************************//

% //***BalkingPattern:  Role = 1(Ensuring method is synchronized - guarded);
% First Rule to determine if a method is synchronized by determining if one of the modifiers in the method definition
% uses the synchronized keyword.  The method can then be a candidate for balking.
rule findBalkingPatternSynchMod
	construct  SYNCH [modifier]
		'synchronized
	replace [method_declaration]
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]
	where
		RM [isMethodSynchronized SYNCH]
	deconstruct MB
        BL2 [block]
	deconstruct BL2
		'{
			RDS3 [repeat declaration_or_statement]
		'}

	import tmpCounter [number]
	export tmpCounter
		0

	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [getIfStmt MD RDS3]
	construct TransformedBL2 [block]
		'{
			TransformedRDS3
		'}
	construct TransformedMB [method_body]
        TransformedBL2

	import Counter [number]
	import tmpCounter
	where
		Counter [> 0]
	where
		Counter [= tmpCounter]

	construct balkingAnnotation1pt1 [stringlit]
		"@BalkingPatternAnnotation(patternInstanceID="
	construct balkingAnnotation1pt2 [stringlit]
		", roleID=1, roleDescription='Ensuring method is synchronized - guarded')"

	by
		'MUTATED /* balkingAnnotation1pt1 [+ Counter] [+ balkingAnnotation1pt2] */ RM TS MD OT TransformedMB
end rule

% //***BalkingPattern:  Role = 1(Ensuring method is synchronized - guarded);
% Second Rule to determine if method is synchronized by determining if the "this" keyword is used to refer to the
% method and if it is synchronized.  The method can then be a candidate for balking.
rule findBalkingPatternSynchMod2
	construct  THIS [expression]
		'this
	replace [method_declaration]
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]
	deconstruct MB
        BL [block]
	deconstruct BL
	    '{
			RDS [repeat declaration_or_statement]
		'}
	deconstruct RDS
		STMT [statement]
		RDS2 [repeat declaration_or_statement]
	deconstruct STMT
		SSTMT [synchronized_statement]
	deconstruct SSTMT
	    'synchronized '( EX [expression] ')
			BL2 [block]
	where
		EX [isMethodSynchdUsingThis THIS]
	deconstruct BL2
		'{
			RDS3 [repeat declaration_or_statement]
		'}

	import tmpCounter [number]
	export tmpCounter
		0

	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [getIfStmt MD RDS3]
	construct TransformedBL2 [block]
		'{
			TransformedRDS3
		'}
	construct TransformedSSTMT [synchronized_statement]
	    'synchronized '( EX ')
			TransformedBL2
	construct TransformedSTMT [statement]
		TransformedSSTMT
	construct TransformedRDS [repeat declaration_or_statement]
		TransformedSTMT
		RDS2
	construct TransformedBL [block]
	    '{
			TransformedRDS
		'}
	construct TransformedMB [method_body]
        TransformedBL

	import tmpCounter
	import Counter [number]
	where
		Counter [> 0]
	where
		Counter [= tmpCounter]

	construct balkingAnnotation1pt1 [stringlit]
		"@BalkingPatternAnnotation(patternInstanceID="
	construct balkingAnnotation1pt2 [stringlit]
		", roleID=1, roleDescription='Ensuring method is synchronized - guarded')"

	by
		'MUTATED /* balkingAnnotation1pt1 [+ Counter] [+ balkingAnnotation1pt2] */ RM TS MD OT TransformedMB
end rule

% //***BalkingPattern:  Role = 2(Ensure an if statement  that tests a flag right at
% //						the start of the synchronized method);
% Called from within findBalkingPatternSynchMod and findBalkingPatternSynchMod2 to check if there is an if-statement
rule getIfStmt MD [method_declarator] RDS3 [repeat declaration_or_statement]
	replace [if_statement]
		'if '( EX2 [expression] ')
			STMT3 [statement]
		OEC [opt else_clause]

	import idCollection [repeat id]

	% construct InstanceFound [expression]
		% EX2 [isBalkingExpression EX2 STMT3 MD each idCollection]
	construct TransformedSTMT3 [statement]
		STMT3 [isBalkingIf EX2 MD each idCollection]

	construct TransformedOEC [opt else_clause]
		OEC [isBalkingElse EX2 MD each idCollection]

	import tmpCounter [number]
	import Counter [number]
	where
		Counter [> 0]
	where
		Counter [= tmpCounter]

	construct balkingAnnotation2pt1 [stringlit]
		"@BalkingPatternAnnotation(patternInstanceID="
	construct balkingAnnotation2pt2 [stringlit]
		", roleID=2, roleDescription='Ensure an if statement that tests a flag right at the start of the synchronized method')"

	% construct balkingAnnotation3pt1 [stringlit]
		% "@BalkingPatternAnnotation(patternInstanceID="
	% construct balkingAnnotation3pt2 [stringlit]
		% ", roleID=3, roleDescription='Ensuring one of the if or else tests of the flag in Role 2 does an immediate return - balking')"

	by
		'MUTATED
		/* balkingAnnotation2pt1 [+ Counter] [+ balkingAnnotation2pt2] */
		'if '( EX2 ')
			TransformedSTMT3
			% /* balkingAnnotation3pt1 [+ Counter] [+ balkingAnnotation3pt2] */
			% STMT3
		TransformedOEC
end rule

% This rule will determine if the expression used in the if statement of a method uses the one of the boolean flags
% and does an immediate return after use of the flag hence, making the method a user of the Balking design pattern.
% Will be used by the functions "findBalkingPatternSynchMod2" and "findBalkingPatternSynchMod".
rule isBalkingIf EX2 [expression] MD [method_declarator] flagID [id]
	% replace [expression]
		% AE [assignment_expression]

	replace [return_statement]
		'return OE[opt expression] ';

	where
		EX2 [matchesFlag flagID]
	% construct returnStmt [statement]
		% 'return;
	% where
		% expSTMT [hasOnlyReturnStmt returnStmt]

	import Counter [number]
	construct PlusOne [number]
		1
	construct NewCount [number]
		Counter [+ PlusOne]
	export Counter
		NewCount

	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]

	import MethodIDs [repeat id]
	construct newMethodIDs [repeat id]
		MethodIDs [. methodID]
	export MethodIDs
		newMethodIDs

	import BalkingFlagIDs [repeat id]
	construct newBalkingFlagIDs [repeat id]
		BalkingFlagIDs [. flagID]
	export BalkingFlagIDs
		newBalkingFlagIDs

	import tmpCounter [number]
	export tmpCounter
		Counter

	construct balkingAnnotation3pt1 [stringlit]
		"@BalkingPatternAnnotation(patternInstanceID="
	construct balkingAnnotation3pt2 [stringlit]
		", roleID=3, roleDescription='Ensuring one of the if or else tests of the flag in Role 2 does an immediate return - balking')"

	by
		'MUTATED
		/* balkingAnnotation3pt1 [+ Counter] [+ balkingAnnotation3pt2] */
		'return OE ';
		% 'MUTATED AE
end rule

% //***BalkingPattern:  Role = 3(Ensuring one of the if or else tests of the flag in
% //						Role 2 does an immediate return - balking );
% This rule will determine if the else part of the if statemenet used in the method does an immediate return and if
% the if part uses one of the boolean flags hence, making the method a user of the Balking design pattern.
% Will be used by the functions "findBalkingPatternSynchMod2" and "findBalkingPatternSynchMod".
rule isBalkingElse EX2 [expression] MD [method_declarator] flagID [id]
	replace [else_clause]
		'else
			STMT4 [statement]

	import tmpCounter [number]
	where
		tmpCounter [= 0]

	where
		EX2 [matchesFlag flagID]
	construct returnStmt [statement]
		'return;
	where
		STMT4 [hasOnlyReturnStmt returnStmt]
	import Counter [number]
	construct PlusOne [number]
		1
	construct NewCount [number]
		Counter [+ PlusOne]
	export Counter
		NewCount

	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]

	import MethodIDs [repeat id]
	construct newMethodIDs [repeat id]
		MethodIDs [. methodID]
	export MethodIDs
		newMethodIDs

	import BalkingFlagIDs [repeat id]
	construct newBalkingFlagIDs [repeat id]
		BalkingFlagIDs [. flagID]
	export BalkingFlagIDs
		newBalkingFlagIDs

	construct balkingAnnotation3pt1 [stringlit]
		"@BalkingPatternAnnotation(patternInstanceID="
	construct balkingAnnotation3pt2 [stringlit]
		", roleID=3, roleDescription='Ensuring one of the if or else tests of the flag in Role 2 does an immediate return - balking')"

	export tmpCounter
		Counter

	by
		'MUTATED
		'else
			/* balkingAnnotation3pt1 [+ Counter] [+ balkingAnnotation3pt2] */
			STMT4
end rule

% Function to check if it is a variable of a specific type.
function isVarOfType VARTYPE [type_specifier]
	match * [type_specifier]
		VARTYPE
end function

% Function to check if the synchronized modifier is being used.
function isMethodSynchronized SYNCH [modifier]
	match * [modifier]
		SYNCH
end function

% Function to check if the synchronized modifier is being used by the "this" keyword.
function isMethodSynchdUsingThis THIS [expression]
	match * [expression]
		THIS
end function

% Function to check if there is a match to one of the boolean flags.
function matchesFlag theID [id]
	match * [id]
		theID
end function

% Function to check if the statement is the "return" statment.
function hasOnlyReturnStmt returnStmt [statement]
	match * [statement]
		returnStmt
end function

% Function to check the statment contains an Else Clause.
function hasOEC OEC [opt else_clause]
	match * [opt else_clause]
		OEC
end function








