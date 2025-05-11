Class {
	#name : 'WormholeCell',
	#superclass : 'Cell',
	#instVars : [
		'linkedCell'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
WormholeCell class >> createPair [
	| cell1 cell2 |
	cell1 := self new.
	cell2 := self new.
	cell1 linkWith: cell2.
	cell2 linkWith: cell1.
	^ {
		  cell1.
		  cell2 }
]

{ #category : 'as yet unclassified' }
WormholeCell >> linkWith: anotherWormholeCell [

	linkedCell := anotherWormholeCell
]
