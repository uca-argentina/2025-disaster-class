Class {
	#name : 'Dice',
	#superclass : 'Object',
	#instVars : [
		'diceCollection'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
Dice class >> with: anArrayMadeOfDice [

	^ self new initializeWith: anArrayMadeOfDice
]

{ #category : 'initialization' }
Dice >> initializeWith: anArrayMadeOfDice [

	diceCollection := anArrayMadeOfDice
]

{ #category : 'initialization' }
Dice >> maxThrow [

	^ diceCollection sum: [ :die | die maxThrow ]
]

{ #category : 'initialization' }
Dice >> throw [

	^ (diceCollection collect: [ :eachDie | eachDie throw ] )sum
]
