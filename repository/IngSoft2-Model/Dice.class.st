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

	aNumberOfSides < 2 ifTrue: [
		Error signal: 'The die number of sides should at least be higher than 1.' ]
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
Dice >> rollDice [

	^(1 to: aNumberOfSides ) atRandom.
]

{ #category : 'as yet unclassified' }
Dice >> sides [
	^aNumberOfSides.
]
