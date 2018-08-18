% Single Threaded Execution Pattern (a Concurrency Design Pattern) Finder for Java Concurrent Software
% Martin Mwebesa
% UOIT, February 6, 2011

include "Java.Grm"

define labelM
	'MUTATED
end define

redefine annotation
	[annotation2]
	| [repeat id]
end redefine

define annotation2
   [SPOFF] '@ [reference] [opt '@] [SPON] [opt annotation_value_spec]
end define

% redefine method_declaration
	% [attr labelM] [NL] [annotation] [method_declaration2]
	% | [method_declaration2]
% end redefine
redefine method_declaration
	[method_declaration2]
	| [attr labelM] [method_declaration2]
	| [attr labelM] [NL] /*[stringlit]*/ [method_declaration2]
end redefine

define method_declaration2
    [NL] [repeat modifier] [type_specifier] [method_declarator] [opt throws] [method_body]
end define

redefine synchronized_statement
 	[synchronized_statement2]
	| [attr labelM] 
    'synchronized '( [expression] ')
        [statement]                  [NL]
end define

define synchronized_statement2
    'synchronized '( [expression] ')
        [statement]                  [NL]
end define

function main
	export singThrAnnotation [stringlit]
		_
	export singThrExMethIDColl [repeat id]
		_
	export tmpCntSingThrExMethIDs [number]
		0
	export Counter [number]
		0
    replace [program]
        P [program]
		
	construct TransformedProgram [stringlit]
		"TransformedForSingleThreadExecPatt.java"
		
	% construct theFileName [stringlit]
		% _ [fget TransformedProgram]
		
	% construct TransformedProgram [stringlit]
		% _ [fget "test.java"]
		
	% construct TransformedProgram [stringlit]
		% _ [getp "Enter filename: "]
		
	% construct TransformedProgram [stringlit]
		% _ [get]
		
	by
        P [findSingleThreadedExecPattern] [findSingleThreadedExecPattern2] [printPatternNotFound] [printOutput] [printSTEMethodIDs] [fput TransformedProgram]
	
end function

function printPatternNotFound
	replace [program]
		P [program]
	
	import Counter [number]
	
	where
		Counter [= 0]
	
	construct InstanceFound [stringlit]
		"*** No instances of Single Threaded Execution Pattern found. "
	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]
	
	by 
		P
end function

function printOutput
	replace [program]
		P [program]
	
	import Counter [number]
	
	where
		Counter [> 0]
	
	construct InstanceFound [stringlit]
		"Instances of Single Threaded Execution Pattern found = "
	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ Counter] [print]
	
	by 
		P
end function

% Function to print out the names of the single threaded exec pattern methods that are used within the Single Threaded design pattern.
% The number of these methods should equal the number of instances printed out in the "printOutput" function.
function printSTEMethodIDs
	replace [program]
		P [program]	
	import Counter [number]	
	import singThrExMethIDColl [repeat id]
	where
		Counter [> 0]	
	construct InstanceFound [stringlit]
		"** Methods using the Single Threaded Execution pattern instances:  "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [print]	
	construct InstanceFoundPrint2 [id]
		_ [thePrintSTEMethodIDs each singThrExMethIDColl]
	by 
		P
end function

% Function to aid in the printing of the method names in the function "printSTEMethodIDs".
function thePrintSTEMethodIDs theID [id]
	construct InstanceFound [stringlit]
		"   "	
	construct InstanceFoundPrint [id]
		_ [unquote InstanceFound] [+ theID] [print]	
	replace [id]
		theID
	by
		theID	
end function


% //**********************************************************************************************//
% //*** Single Threaded Execution pattern:                                                     ***//
% //*** Helps prevent issues (incorrect results) occurring from accessing a specific resource  ***// 
% //*** (object) at the same time through concurrent calls to a method from multiple threads.  ***//   
% //*** This issue is a data race.  This prevention is done by implementing guarded methods.   ***// 
% //*** In Java this basically means declaring these methods that can be called concurrently   ***//
% //*** but may lead to incorrect results, as synchronized.                                    ***//
% //**********************************************************************************************//

% //***SingleThreadedExecutionPattern:  Role = 1(Use of synchronized keyword, Java's way of implementing a guarded method);
rule findSingleThreadedExecPattern
	construct  SYNCH [modifier]
		'synchronized
		
	replace [method_declaration] 
		RM [repeat modifier] TS [type_specifier] MD [method_declarator] OT [opt throws] MB [method_body]
		
	where 
		RM [isSynchronized SYNCH]
					
	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]    
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]    
		
	construct PlusOne [number]
		1
		
	import singThrExMethIDColl [repeat id]
	construct newSTEMethIDs [repeat id]
		singThrExMethIDColl [. methodID]
	export singThrExMethIDColl
		newSTEMethIDs	

	import Counter [number]
	construct NewCountb [number]
		Counter [+ PlusOne]
	export Counter
		NewCountb		
		
	construct singThrAnnotationpt1 [stringlit]
		"@SingleThreadedExecPatternAnnotation(patternInstanceID="
	construct singThrAnnotationpt2 [stringlit]
		", roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
	
	by
		'MUTATED /* singThrAnnotationpt1 [+ Counter] [+ singThrAnnotationpt2] */ RM TS MD OT MB 
end rule

% //***SingleThreadedExecutionPattern:  Role = 1(Use of synchronized keyword, Java's way of implementing a guarded method);
rule findSingleThreadedExecPattern2
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
				
	deconstruct MD
	    MN [method_name] '( LFP [list formal_parameter] ') RD [repeat dimension]    
	deconstruct MN
		DN [declared_name]
	deconstruct DN
	   methodID [id] OGP [opt generic_parameter]    
		
	construct PlusOne [number]
		1
		
	import singThrExMethIDColl [repeat id]
	construct newSTEMethIDs [repeat id]
		singThrExMethIDColl [. methodID]
	export singThrExMethIDColl
		newSTEMethIDs	

	import Counter [number]
	construct NewCountb [number]
		Counter [+ PlusOne]
	export Counter
		NewCountb		
		
	construct singThrAnnotationpt1 [stringlit]
		"@SingleThreadedExecPatternAnnotation(patternInstanceID="
	construct singThrAnnotationpt2 [stringlit]
		", roleID=1, roleDescription='Use of synchronized keyword, Java's way of implementing a guarded method')"
	
	by
		'MUTATED /* singThrAnnotationpt1 [+ Counter] [+ singThrAnnotationpt2] */ RM TS MD OT MB 
end rule

% Function to check if the synchronized modifier is being used.
function isSynchronized SYNCH [modifier]
	match * [modifier]
		SYNCH
end function

% Function to check if the synchronized modifier is being used by the "this" keyword.
function isMethodSynchdUsingThis THIS [expression]
	match * [expression]
		THIS
end function
