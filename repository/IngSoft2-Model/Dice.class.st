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
Dice class >> with: aNumberOfSides [ 
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
