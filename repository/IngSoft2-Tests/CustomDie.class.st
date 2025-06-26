Class {
	#name : 'CustomDie',
	#superclass : 'Object',
	#instVars : [
		'sequence'
	],
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'as yet unclassified' }
CustomDie class >> withRolls: anArrayOfValues [

	^ self new initializeSequence: anArrayOfValues
]

{ #category : 'initialization' }
CustomDie >> initializeSequence: anArrayOfValues [

	sequence := anArrayOfValues asOrderedCollection
]

{ #category : 'initialization' }
CustomDie >> maxThrow [

	^ sequence max
]

{ #category : 'initialization' }
CustomDie >> throw [

	| currentThrow |
	currentThrow := sequence removeFirst.
	sequence addLast: currentThrow.
	^ currentThrow
]
