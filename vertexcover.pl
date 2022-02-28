/* Georgios Tsiris, 1115201700173 */

:- set_flag(print_depth,1000).

:- lib(ic).
:- lib(branch_and_bound).

:- compile(graph).

vertexcover(NNodes, Density, Cover) :-
	create_graph(NNodes, Density, Graph),
	def_vars(NNodes, Nodes),
	state_constrs(Nodes, Graph),
	Cost #= sum(Nodes),
	bb_min(search(Nodes, 0, input_order, indomain, complete, []), Cost, _),
	cover_format(Nodes, 1, Cover).

def_vars(NNodes, Nodes) :-
	length(Nodes, NNodes),
	Nodes #:: 0..1.

state_constrs(_, []).
state_constrs(Nodes, [N1 - N2| Graph]) :-
	n_th(N1, Nodes, Node1),
	n_th(N2, Nodes, Node2),
	Node1 + Node2 #> 0,
	state_constrs(Nodes, Graph).

n_th(1, [Node| _], Node).
n_th(N, [_| Nodes], Node) :-
	N \= 1,
	N1 is N - 1,
	n_th(N1, Nodes, Node).

cover_format([], _, []).
cover_format([0|Nodes], Index, Cover) :-
	NewIndex is Index + 1,
	cover_format(Nodes, NewIndex, CoverAcc),
	append([], CoverAcc, Cover).
cover_format([1|Nodes], Index, Cover) :-
	NewIndex is Index + 1,
	cover_format(Nodes, NewIndex, CoverAcc),
	append([Index], CoverAcc, Cover).