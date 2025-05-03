Class {
	#name : 'Board',
	#superclass : 'Object',
	#instVars : [
		'map'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
Board class >> with: aNumberOfCells [ 
	^self new initializeWith: aNumberOfCells. 
]

{ #category : 'as yet unclassified' }
Board >> getMap [ 
	^map.
]

{ #category : 'initialization' }
Board >> initializeWith: aNumberOfCells [
	 map := OrderedCollection new: aNumberOfCells.
	1 to: aNumberOfCells do: [ :i | map add: Cell new. ].
]
