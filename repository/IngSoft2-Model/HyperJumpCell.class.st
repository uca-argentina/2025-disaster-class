Class {
	#name : 'HyperJumpCell',
	#superclass : 'Cell',
	#instVars : [
		'lengths'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
HyperJumpCell class >> withLengths: aCollectionOfLenghts [

	^ self new initializeWith: aCollectionOfLenghts
]

{ #category : 'as yet unclassified' }
HyperJumpCell >> applyEffectTo: aShip in: aBoard [

	| anAmountToMove |
	anAmountToMove := lengths first.
	lengths removeFirst.
	lengths addLast: anAmountToMove.

	aShip move: (anAmountToMove toCellsOf: aBoard) in: aBoard
]

{ #category : 'initialization' }
HyperJumpCell >> initializeWith: someLengths [

	lengths := someLengths.
	^ self
]
