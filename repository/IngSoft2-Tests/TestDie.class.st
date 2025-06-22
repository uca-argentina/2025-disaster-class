Class {
	#name : 'TestDie',
	#superclass : 'Object',
	#instVars : [
		'forcedRoll',
		'forcedRolls',
		'index'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'as yet unclassified' }
TestDie class >> withRolls: aCollection [ 

	^ self new initializeWithRolls: aCollection
]

{ #category : 'initialization' }
TestDie >> initializeWithRolls: aCollection [ 

	
	forcedRolls := aCollection.
	index := 1 
]

{ #category : 'initialization' }
TestDie >> rollDice [ 

	| roll |
	forcedRoll ifNotNil: [ ^ forcedRoll ].

	forcedRolls ifNotNil: [
		index > forcedRolls size ifTrue: [ index := 1 ].
		roll := forcedRolls at: index.
		index := index + 1.
		^ roll ].

	Error signal:
		'TestDie requires either a forced roll or a list of rolls.'

]

{ #category : 'initialization' }
TestDie >> sides [ 

	^ forcedRolls
		  ifNotNil: [ forcedRolls max ]
		  ifNil: [ forcedRoll ifNotNil: [ forcedRoll ] ifNil: [ 0 ] ]


]
