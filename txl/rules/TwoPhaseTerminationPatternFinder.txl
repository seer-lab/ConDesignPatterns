% Two Phase Termination Pattern (a Concurrency Design Pattern) Finder for Java Concurrent Software
% Martin Mwebesa
% UOIT, April 20, 2011

% include "Java.Grm"
% include "JavaCommentOverrides.Grm"
include "../helper.txl"

define labelM
	'MUTATED
end define

redefine annotation
	[annotation2]
end redefine

define annotation2
   [SPOFF] '@ [reference] [opt '@] [SPON] [opt annotation_value_spec] [NL]
end define

redefine class_declaration
	[class_declaration2]
    | [attr labelM] [class_header] [class_body]
    | [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL] [class_header] [class_body]
end redefine

define class_declaration2
    [class_header] [class_body]
end define

redefine method_declaration
	[method_declaration2]
	| [attr labelM] [method_declaration2]
	| [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL] [method_declaration2]
end redefine

define method_declaration2
    [repeat modifier] [type_specifier] [method_declarator] [opt throws] [method_body]
end define

redefine variable_declaration
	[variable_declaration2]
    | [attr labelM] [repeat modifier] [type_specifier] [variable_declarators] '; [NL]
    | [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL] [repeat modifier] [type_specifier] [variable_declarators] '; [NL]
end redefine

define variable_declaration2
    [repeat modifier] [type_specifier] [variable_declarators] '; [NL]
end define

redefine while_statement
	[while_statement2]
    | 'while '( [expression] ')
	'{
        [statement]
	'}
 	| [attr labelM]
	'while '( [expression] ')
	'{
        [statement]
	'}
 	| [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL]
	'while '( [expression] ')
	'{
		[statement]
	'}
end redefine

define while_statement2
    'while '( [expression] ')
        [statement]
end define

redefine do_statement
	[do_statement2]
    | 'do
	'{
        [statement]
	'}
    'while '( [expression] ') ';
 	| [attr labelM]
    'do
	'{
        [statement]
	'}
    'while '( [expression] ') ';
 	| [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL]
    'do
	'{
        [statement]
	'}
    'while '( [expression] ') ';
end redefine

define do_statement2
    'do
        [statement]
    'while '( [expression] ') ';
end define

redefine expression_statement
 	[expression_statement2]
	| [attr labelM]
	[expression] ';
	| [attr labelM] [NL] [SPOFF] /* [SPON] [stringlit] [SPOFF] */ [SPON] [NL]
	[expression] ';
end redefine

define expression_statement2
    [expression] ';
end define


function main
	export Counter [number]
		0
	export CountRole1 [number]
		0
	export CountRunMethIDs [number]
		0
	export CountInterruptMethIDs [number]
		0
	export CountShutdownMethIDs [number]
		0
	export tmpRole2aPassed [number]
		0
	export tmpRole2bPassed [number]
		0
	export tmpRole3Passed [number]
		0
	export tmpRole4Passed [number]
		0
	export alreadyPrintedOutput [number]
		0
 	export runMethIDs [repeat id]
		_
 	export interruptMethIDs [repeat id]
		_
 	export shutdownMethIDs [repeat id]
		_
	export threadIdCollection [repeat id]
		_
	export usedThreadIdCollection [repeat id]
		_
	replace [program]
        P [program]
	construct TransformedProgram [stringlit]
		"TransformedForTwoPhaseTermPatt.java"
	by
		P [findTwoPhaseTerminationPattern] [printOutput] [printOutput1] [printOutput2] [printOutput3] [printOutput4]
		[printRunMethIDs] [printInterruptMethIDs] [printShutdownMethIDs] [printThreadIDs]
		[fput TransformedProgram]
		% P [findTwoPhaseTerminationPattern] [printPatternNotFound] [printOutput] [printOutput1] [printOutput2] [printOutput3] [printOutput4]
		% [printRunMethIDs] [printInterruptMethIDs] [printShutdownMethIDs] [printThreadIDs]
		% [fput TransformedProgram]
end function


function printPatternNotFound
	replace [program]
		P [program]

	import Counter [number]

	where
		Counter [= 0]

	construct InstanceFound [stringlit]
		"*** No instances of Two Phase Termination Pattern found. "

	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]

	by
		P
end function

% Function print out the number of Two Phase Termination design pattern instances found.
function printOutput
	replace [program]
		P [program]

	import alreadyPrintedOutput [number]
	import Counter [number]
	import CountRole1 [number]
	import CountRunMethIDs [number]
	import CountInterruptMethIDs [number]
	import CountShutdownMethIDs [number]

	where
		Counter [> 0]
	where
		Counter [= CountRole1]
	where
		Counter [= CountRunMethIDs]
	where
		Counter [= CountInterruptMethIDs]
	where
		Counter [= CountShutdownMethIDs]

	export alreadyPrintedOutput
		1

	construct InstanceFound [stringlit]
		"** Complete instances of Two Phase Termination Pattern found = "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ Counter] [print]
	by
		P
end function

% Function print out the number of Two Phase Termination design pattern instances found.
function printOutput1
	replace [program]
		P [program]

	import alreadyPrintedOutput [number]
	import Counter [number]
	import CountRole1 [number]
	import CountRunMethIDs [number]
	import CountInterruptMethIDs [number]
	import CountShutdownMethIDs [number]

	where
		alreadyPrintedOutput [= 0]
	where
		CountRole1 [< Counter] [= Counter]
	where
		CountRole1 [< CountRunMethIDs] [= CountRunMethIDs]
	where
		CountRole1 [< CountInterruptMethIDs] [= CountInterruptMethIDs]
	where
		CountRole1 [< CountShutdownMethIDs]	[= CountShutdownMethIDs]

	export alreadyPrintedOutput
		1

	construct InstanceFound [stringlit]
		"** Complete instances of Two Phase Termination Pattern found = "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ CountRole1] [print]
	by
		P
end function

% Function print out the number of Two Phase Termination design pattern instances found.
function printOutput2
	replace [program]
		P [program]

	import alreadyPrintedOutput [number]
	import Counter [number]
	import CountRole1 [number]
	import CountRunMethIDs [number]
	import CountInterruptMethIDs [number]
	import CountShutdownMethIDs [number]

	where
		alreadyPrintedOutput [= 0]
	where
		CountRunMethIDs [< Counter] [= Counter]
	where
		CountRunMethIDs [< CountRole1] [= CountRole1]
	where
		CountRunMethIDs [< CountInterruptMethIDs] [= CountInterruptMethIDs]
	where
		CountRunMethIDs [< CountShutdownMethIDs]	[= CountShutdownMethIDs]

	export alreadyPrintedOutput
		1

	construct InstanceFound [stringlit]
		"** Complete instances of Two Phase Termination Pattern found = "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ CountRunMethIDs] [print]
	by
		P
end function

% Function print out the number of Two Phase Termination design pattern instances found.
function printOutput3
	replace [program]
		P [program]

	import alreadyPrintedOutput [number]
	import Counter [number]
	import CountRole1 [number]
	import CountRunMethIDs [number]
	import CountInterruptMethIDs [number]
	import CountShutdownMethIDs [number]

	where
		alreadyPrintedOutput [= 0]
	where
		CountInterruptMethIDs [< Counter] [= Counter]
	where
		CountInterruptMethIDs [< CountRunMethIDs] [= CountRunMethIDs]
	where
		CountInterruptMethIDs [< CountRole1] [= CountRole1]
	where
		CountInterruptMethIDs [< CountShutdownMethIDs]	[= CountShutdownMethIDs]

	export alreadyPrintedOutput
		1

	construct InstanceFound [stringlit]
		"** Complete instances of Two Phase Termination Pattern found = "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ CountInterruptMethIDs] [print]
	by
		P
end function

% Function print out the number of Two Phase Termination design pattern instances found.
function printOutput4
	replace [program]
		P [program]

	import alreadyPrintedOutput [number]
	import Counter [number]
	import CountRole1 [number]
	import CountRunMethIDs [number]
	import CountInterruptMethIDs [number]
	import CountShutdownMethIDs [number]

	where
		alreadyPrintedOutput [= 0]
	where
		CountShutdownMethIDs [< Counter] [= Counter]
	where
		CountShutdownMethIDs [< CountRunMethIDs] [= CountRunMethIDs]
	where
		CountShutdownMethIDs [< CountInterruptMethIDs] [= CountInterruptMethIDs]
	where
		CountShutdownMethIDs [< CountRole1]	[= CountRole1]

	export alreadyPrintedOutput
		1

	construct InstanceFound [stringlit]
		"** Complete instances of Two Phase Termination Pattern found = "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ CountShutdownMethIDs] [print]
	by
		P
end function

% Function to print out the names of the methods running the process.
% The number of these methods should equal the number of instances printed out in the "printOutput" function.
function printRunMethIDs
	replace [program]
		P [program]
	import runMethIDs [repeat id]
	import CountRunMethIDs [number]
	where
		CountRunMethIDs [> 0]
	construct InstanceFound [stringlit]
		"** ROLE 2:  Method running process where latch is checked (i.e. thread is checked if interrupted). "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]
	construct InstanceFoundb [stringlit]
		"** On latch being set the process (the thread) is shutdown here.  Used within the instance of the Two Phase Termination Design Pattern:  "
	construct InstanceFoundPrintb [id]
		_ [unquote InstanceFoundb] [print]
	construct InstanceFoundPrint2 [program]
		_ [thePrintRunMethIDs each runMethIDs]
	by
		P
end function

% Function to aid in the printing of the method names in the function "printRunMethIDs".
function thePrintRunMethIDs theID [id]
	construct InstanceFound [stringlit]
		"   "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]
	replace [program]
		P [program]
	by
		P
end function

% Function to print out the names of the methods that set a latch to true - that actually interrupts the thread.
% The number of these methods should equal the number of instances printed out in the "printOutput" function.
function printInterruptMethIDs
	replace [program]
		P [program]
	import interruptMethIDs [repeat id]
	import CountInterruptMethIDs [number]
	where
		CountInterruptMethIDs [> 0]
	construct InstanceFound [stringlit]
		"** ROLE 3:  Method instances where latch is actually set (where the thread is interrupted).  Used within the instance of the Two Phase Termination Design Pattern:  "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]
	construct InstanceFoundPrint2 [program]
		_ [thePrintInterruptMethIDs each interruptMethIDs]
	by
		P
end function

% Function to aid in the printing of the method names in the function "printInterruptMethIDs".
function thePrintInterruptMethIDs theID [id]
	construct InstanceFound [stringlit]
		"   "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]
	replace [program]
		P [program]
	by
		P
end function

% Function to print out the names of the methods that eventually shutdown the process - that actually stop the thread.
% The number of these methods should equal the number of instances printed out in the "printOutput" function.
function printShutdownMethIDs
	replace [program]
		P [program]
	import shutdownMethIDs [repeat id]
	import CountShutdownMethIDs [number]
	where
		CountShutdownMethIDs [> 0]
	construct InstanceFound [stringlit]
		"** ROLE 4:  Method instances where the process is actually shutdown (where the thread is stopped).  Used within the instance of the Two Phase Termination Design Pattern:  "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]
	construct InstanceFoundPrint2 [program]
		_ [thePrintShutdownMethIDs each shutdownMethIDs]
	by
		P
end function

% Function to aid in the printing of the method names in the function "printShutdownMethIDs".
function thePrintShutdownMethIDs theID [id]
	construct InstanceFound [stringlit]
		"   "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]
	replace [program]
		P [program]
	by
		P
end function

% Function to print out the names of the process (the thread) that is being Two Phase Terminated.
% The number of these threads should equal the number of instances printed out in the "printOutput" function.
function printThreadIDs
	replace [program]
		P [program]
	% import usedThreadIdCollection [repeat id]
	import threadIdCollection [repeat id]
	import CountRole1 [number]
	where
		CountRole1 [> 0]
	construct InstanceFound [stringlit]
		"** ROLE 1:  Process(es) - Thread(s) that can be Two Phase Terminated:  "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]
	% construct InstanceFoundPrint2 [program]
		% _ [thePrintThreadIDs each usedThreadIdCollection]
	construct InstanceFoundPrint2 [program]
		_ [thePrintThreadIDs each threadIdCollection]
	by
		P
end function

% Function to aid in the printing of the thread names in the function "printThreadIDs".
function thePrintThreadIDs theID [id]
	construct InstanceFound [stringlit]
		"   "
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]
	replace [program]
		P [program]
	by
		P
end function


% //*******************************************************************************************//
% //*** Two Phase Termination pattern:                                                      ***//
% //*** This concurrency design pattern basically provides functionality to shutdown a      ***//
% //*** thread or process in an orderly manner (i.e. allowing for cleanup, etc�, etc�) by   ***//
% //*** checking the value of a latch at specific points in the execution of the thread or  ***//
% //*** process.  The latch is basically a flag of some sort.                               ***//
% //*** NB:  For the purposes of our experiment we will focus on orderly thread shutdown.   ***//
% //*******************************************************************************************//
% rule findTwoPhaseTerminationPattern
	% replace [class_declaration]
	    % CH [class_header] CB [class_body]
	% construct ThreadInstancesFound [class_body]
		% CB [findThreadInstances]
	% construct ShutdownMethodFound [class_body]
		% CB [findShutdownMethod]
	% construct RunMethodFound [class_body]
		% CB [findRunMethod]
	% construct InterruptMethodFound [class_body]
		% CB [findInterruptMethod]
	% by
		% 'MUTATED CH CB
% end rule
rule findTwoPhaseTerminationPattern
	replace [class_declaration]
	    CH [class_header] CB [class_body]
	construct TransformedClassBody [class_body]
		CB [findThreadInstances] [findShutdownMethod] [findRunMethod] [findInterruptMethod]
	by
		'MUTATED CH TransformedClassBody
end rule


% //***TwoPhaseTerminationPattern:  Role = 1(Thread(s) declaration - thread(s) that will be checked for an interrupt in Role 2.);
rule findThreadInstances
	construct  VARTYPE [type_specifier]
		'Thread
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
		threadID [id] OGP [opt generic_parameter]

	import threadIdCollection [repeat id]
	construct newIDCollection [repeat id]
		threadIdCollection [. threadID]
	export threadIdCollection
		newIDCollection

	import CountRole1 [number]
	construct PlusOne [number]
		1
	construct NewCount [number]
		CountRole1 [+ PlusOne]
	export CountRole1
		NewCount

	construct TwoPhaseTerminationAnnotation1pt1 [stringlit]
		"@TwoPhaseTerminationPatternAnnotation(patternInstanceID="
	construct TwoPhaseTerminationAnnotation1pt2 [stringlit]
		", roleID=1, roleDescription='Thread(s) declaration - thread(s) that will be checked for an interrupt in Role 2.')"

	by
		'MUTATED /* TwoPhaseTerminationAnnotation1pt1 [+ CountRole1] [+ TwoPhaseTerminationAnnotation1pt2] */ RM TS VDS ';
end rule


% //***TwoPhaseTerminationPattern:  Role = 4(Method that will contain functionality to stop the thread in Role 1.
% //								** Contains Role 4a.);
rule findShutdownMethod
	replace [method_declaration]
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]
	deconstruct MB
        BL2 [block]
	deconstruct BL2
		'{
			RDS3 [repeat declaration_or_statement]
		'}
	import threadIdCollection [repeat id]
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [isThreadStop MD each threadIdCollection]

	import tmpRole4Passed [number]
	where
		tmpRole4Passed [> 0]

	construct TransformedBL2 [block]
		'{
			TransformedRDS3
		'}
	construct TransformedMB [method_body]
        TransformedBL2

	construct TwoPhaseTerminationAnnotation4pt1 [stringlit]
		"@TwoPhaseTerminationPatternAnnotation(patternInstanceID="
	construct TwoPhaseTerminationAnnotation4pt2 [stringlit]
		", roleID=4, roleDescription='Method that will contain functionality to stop the thread in Role 1.')"

	import CountShutdownMethIDs [number]

	export tmpRole4Passed
		0

	by
		'MUTATED /* TwoPhaseTerminationAnnotation4pt1 [+ CountShutdownMethIDs] [+ TwoPhaseTerminationAnnotation4pt2] */ RM TS MD OT TransformedMB
end rule

% ///***TwoPhaseTerminationPattern:  Role = 4a(Actually stopping of the thread in Role 1.);
rule isThreadStop MD [method_declarator] threadID [id]
	replace [expression_statement]
		EX [expression] ';

	construct stopID [id]
		'stop
	deconstruct EX
		AE [assignment_expression]
	where all
		AE [matchesVarID stopID] [matchesVarID threadID]

	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]

	import usedThreadIdCollection [repeat id]
	construct newThreadIdCollection [repeat id]
		usedThreadIdCollection [. threadID]
	export usedThreadIdCollection
		newThreadIdCollection

	import shutdownMethIDs [repeat id]
	construct newMethodIDs [repeat id]
		shutdownMethIDs [. methodID]
	export shutdownMethIDs
		newMethodIDs

	import CountShutdownMethIDs [number]
	construct PlusOne [number]
		1
	construct NewCount [number]
		CountShutdownMethIDs [+ PlusOne]
	export CountShutdownMethIDs
		NewCount

	import tmpRole4Passed [number]
	construct NewCountb [number]
		tmpRole4Passed [+ PlusOne]
	export tmpRole4Passed
		NewCountb

	construct TwoPhaseTerminationAnnotation4apt1 [stringlit]
		"@TwoPhaseTerminationPatternAnnotation(patternInstanceID="
	construct TwoPhaseTerminationAnnotation4apt2 [stringlit]
		", roleID=4a, roleDescription='Actually stopping of the thread in Role 1.')"

	by
		'MUTATED /* TwoPhaseTerminationAnnotation4apt1 [+ CountShutdownMethIDs] [+ TwoPhaseTerminationAnnotation4apt2] */
		EX ';
end rule


% //***TwoPhaseTerminationPattern:  Role = 2(Method running the process.
% //								** Contains Role 2a.
% //								** Contains Role 2b.);
rule findRunMethod
	replace [method_declaration]
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]
	deconstruct MB
        BL2 [block]
	deconstruct BL2
		'{
			RDS3 [repeat declaration_or_statement]
		'}

	import shutdownMethIDs [repeat id]

	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [isShutdownMethCalled MD each shutdownMethIDs] [isWhileLpWait] [isDoWhileLpWait]

	import tmpRole2aPassed [number]
	where
		tmpRole2aPassed [> 0]

	import tmpRole2bPassed [number]
	where
		tmpRole2bPassed [> 0]

	construct TransformedBL2 [block]
		'{
			TransformedRDS3
		'}
	construct TransformedMB [method_body]
        TransformedBL2

	construct TwoPhaseTerminationAnnotation2pt1 [stringlit]
		"@TwoPhaseTerminationPatternAnnotation(patternInstanceID="
	construct TwoPhaseTerminationAnnotation2pt2 [stringlit]
		", roleID=2, roleDescription='Method running the process.')"

	import CountRunMethIDs [number]

	export tmpRole2aPassed
		0
	export tmpRole2bPassed
		0

	by
		'MUTATED /* TwoPhaseTerminationAnnotation2pt1 [+ CountRunMethIDs] [+ TwoPhaseTerminationAnnotation2pt2] */ RM TS MD OT TransformedMB
end rule

% //***TwoPhaseTerminationPattern:  Role = 2a(In a loop checking the latch - thread in Role 1 being checked for Role 2aa.);
rule isWhileLpWait
	replace [while_statement]
	    'while '( EX [expression] ')
			STMT [statement]

	import usedThreadIdCollection [repeat id]
	construct InstanceFound [expression]
		EX [isThdInterruptLatchCheck EX each usedThreadIdCollection]

	construct TwoPhaseTerminationAnnotation2apt1 [stringlit]
		"@TwoPhaseTerminationPatternAnnotation(patternInstanceID="
	construct TwoPhaseTerminationAnnotation2apt2 [stringlit]
		", roleID=2a, roleDescription='In a loop checking the latch - thread in Role 1 being checked for Role 2aa.')"

	construct TwoPhaseTerminationAnnotation2aapt1 [stringlit]
		"@TwoPhaseTerminationPatternAnnotation(patternInstanceID="
	construct TwoPhaseTerminationAnnotation2aapt2 [stringlit]
		", roleID=2aa, roleDescription='Thread in Role 1 being checked if it has been interrupted.')"

	import CountRunMethIDs [number]

	by
		'MUTATED /* TwoPhaseTerminationAnnotation2apt1 [+ CountRunMethIDs] [+ TwoPhaseTerminationAnnotation2apt2] */
		 /* TwoPhaseTerminationAnnotation2aapt1 [+ CountRunMethIDs] [+ TwoPhaseTerminationAnnotation2aapt2] */
	    'while '( EX ')
		{
			STMT
		}
end rule

% //***TwoPhaseTerminationPattern:  Role = 2a(In a loop checking the latch - thread in Role 1 being checked for Role 2aa.);
rule isDoWhileLpWait
	replace [do_statement]
		'do
			 STMT [statement]
		'while '( EX [expression] ') ';

	import usedThreadIdCollection [repeat id]
	construct InstanceFound  [expression]
		EX [isThdInterruptLatchCheck EX each usedThreadIdCollection]

	construct TwoPhaseTerminationAnnotation2apt1 [stringlit]
		"@TwoPhaseTerminationPatternAnnotation(patternInstanceID="
	construct TwoPhaseTerminationAnnotation2apt2 [stringlit]
		", roleID=2a, roleDescription='In a loop checking the latch - thread in Role 1 being checked for Role 2aa.')"

	construct TwoPhaseTerminationAnnotation2aapt1 [stringlit]
		"@TwoPhaseTerminationPatternAnnotation(patternInstanceID="
	construct TwoPhaseTerminationAnnotation2aapt2 [stringlit]
		", roleID=2aa, roleDescription='Thread in Role 1 being checked if it has been interrupted.')"

	import CountRunMethIDs [number]

	by
		'MUTATED /* TwoPhaseTerminationAnnotation2apt1 [+ CountRunMethIDs] [+ TwoPhaseTerminationAnnotation2apt2] */
		 /* TwoPhaseTerminationAnnotation2aapt1 [+ CountRunMethIDs] [+ TwoPhaseTerminationAnnotation2aapt2] */
		'do
		{
			 STMT
		}
		'while '( EX ') ';
end rule

% //***TwoPhaseTerminationPattern:  Role = 2aa(Thread in Role 1 being checked if it has been interrupted.);
function isThdInterruptLatchCheck EX [expression] threadID [id]
	replace [expression]
		EX

	construct interruptedID [id]
		'interrupted
	where all
		EX [matchesVarID interruptedID] [matchesVarID threadID]

	construct PlusOne [number]
		1
	import tmpRole2aPassed [number]
	construct NewCount [number]
		tmpRole2aPassed [+ PlusOne]
	export tmpRole2aPassed
		NewCount

	by
		EX
end function

% //***TwoPhaseTerminationPattern:  Role = 2b(After the loop, a call to Role 4 that shuts down the thread.);
rule isShutdownMethCalled  MD [method_declarator] shutDownMethID [id]
	replace [expression_statement]
		EX [expression] ';

	deconstruct EX
		AE [assignment_expression]
	where all
		AE [matchesVarID shutDownMethID]

	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]

	import runMethIDs [repeat id]
	construct newMethodIDs [repeat id]
		runMethIDs [. methodID]
	export runMethIDs
		newMethodIDs

	import CountRunMethIDs [number]
	construct PlusOne [number]
		1
	construct NewCount [number]
		CountRunMethIDs [+ PlusOne]
	export CountRunMethIDs
		NewCount

	import tmpRole2bPassed [number]
	construct NewCountb [number]
		tmpRole2bPassed [+ PlusOne]
	export tmpRole2bPassed
		NewCountb

	construct TwoPhaseTerminationAnnotation2bpt1 [stringlit]
		"@TwoPhaseTerminationPatternAnnotation(patternInstanceID="
	construct TwoPhaseTerminationAnnotation2bpt2 [stringlit]
		", roleID=2b, roleDescription='After the loop, a call to Role 4 that shuts down the thread.')"

	by
		'MUTATED /* TwoPhaseTerminationAnnotation2bpt1 [+ CountRunMethIDs] [+ TwoPhaseTerminationAnnotation2bpt2] */
		EX ';
end rule


% //***TwoPhaseTerminationPattern:  Role = 3(Method that will contain functionality to set the latch - interrupt the thread in Role 1.
% //								** Contains Role 3a.);
rule findInterruptMethod
	replace [method_declaration]
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]
	deconstruct MB
        BL2 [block]
	deconstruct BL2
		'{
			RDS3 [repeat declaration_or_statement]
		'}
	import usedThreadIdCollection [repeat id]
	construct TransformedRDS3 [repeat declaration_or_statement]
		RDS3 [isThreadInterrupted MD each usedThreadIdCollection]

	import tmpRole3Passed [number]
	where
		tmpRole3Passed [> 0]

	construct TransformedBL2 [block]
		'{
			TransformedRDS3
		'}
	construct TransformedMB [method_body]
        TransformedBL2

	construct TwoPhaseTerminationAnnotation3pt1 [stringlit]
		"@TwoPhaseTerminationPatternAnnotation(patternInstanceID="
	construct TwoPhaseTerminationAnnotation3pt2 [stringlit]
		", roleID=3, roleDescription='Method that will contain functionality to set the latch - interrupt the thread in Role 1.')"

	import CountInterruptMethIDs [number]

	export tmpRole3Passed
		0

	by
		'MUTATED /* TwoPhaseTerminationAnnotation3pt1 [+ CountInterruptMethIDs] [+ TwoPhaseTerminationAnnotation3pt2] */ RM TS MD OT TransformedMB
end rule

% //***TwoPhaseTerminationPattern:  Role = 3a(Actually setting the latch to true - interrupting the thread in Role 1.);
rule isThreadInterrupted MD [method_declarator] threadID [id]
	replace [expression_statement]
		EX [expression] ';

	construct interruptID [id]
		'interrupt
	deconstruct EX
		AE [assignment_expression]
	where all
		AE [matchesVarID interruptID] [matchesVarID threadID]

	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]

	import interruptMethIDs [repeat id]
	construct newMethodIDs [repeat id]
		interruptMethIDs [. methodID]
	export interruptMethIDs
		newMethodIDs

	import CountInterruptMethIDs [number]
	construct PlusOne [number]
		1
	construct NewCount [number]
		CountInterruptMethIDs [+ PlusOne]
	export CountInterruptMethIDs
		NewCount

	import CountRunMethIDs [number]
	import CountShutdownMethIDs [number]
	construct numZero [number]
	'0

	where not
		CountRunMethIDs [hasNumber numZero]
	where not
		CountShutdownMethIDs [hasNumber numZero]
	where not
		CountInterruptMethIDs [hasNumber numZero]

	import Counter [number]
	construct PlusOneb [number]
		1
	construct NewCountb [number]
		Counter [+ PlusOneb]
	export Counter
		NewCountb

	import tmpRole3Passed [number]
	construct NewCountc [number]
		tmpRole3Passed [+ PlusOne]
	export tmpRole3Passed
		NewCountc

	construct TwoPhaseTerminationAnnotation3apt1 [stringlit]
		"@TwoPhaseTerminationPatternAnnotation(patternInstanceID="
	construct TwoPhaseTerminationAnnotation3apt2 [stringlit]
		", roleID=3a, roleDescription='Actually setting the latch to true - interrupting the thread in Role 1.')"

	by
		'MUTATED /* TwoPhaseTerminationAnnotation3apt1 [+ CountInterruptMethIDs] [+ TwoPhaseTerminationAnnotation3apt2] */
		EX ';
end rule


% Function to check if there is a match to a variable ID.
function matchesVarID theID [id]
	match * [id]
		theID
end function

% Function to check if there is a match to a specific number.
function hasNumber theNumber [number]
	match * [number]
		theNumber
end function

% Function to check if it is a variable of a specific type.
function isVarOfType VARTYPE [type_specifier]
	match * [type_specifier]
		VARTYPE
end function








