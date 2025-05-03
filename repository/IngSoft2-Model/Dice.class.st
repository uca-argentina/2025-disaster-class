"
Represents a dice that returns a numeric value
"
Class {
	#name : 'Dice',
	#superclass : 'Object',
	#instVars : [
		'aNumberOfSides'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
Dice class >> numberOfSidesIsHigherThanOne: aNumberOfSides [

	aNumberOfSides < 1 ifTrue: [
		'The die number of sides should at least be higher than 1.' ]
]

{ #category : 'instance creation' }
Dice class >> with: aNumberOfSides [ 
	self numberOfSidesIsHigherThanOne: aNumberOfSides.
	^self new initializeWith: aNumberOfSides.
]

{ #category : 'initialization' }
Dice >> initializeWith: numberOfSides [

	aNumberOfSides := numberOfSides
]

{ #category : 'accessing' }
Dice >> result [

	^ 1
]

{ #category : 'as yet unclassified' }
Dice >> sides [
	^aNumberOfSides.
]
