Class {
	#name : 'Parsecs',
	#superclass : 'Object',
	#instVars : [
		'amount'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'accessing' }
Parsecs class >> amount: anAmount [

	^ self new initializeWith: anAmount
]

{ #category : 'accessing' }
Parsecs >> initializeWith: anAmount [

	amount := anAmount
]

{ #category : 'accessing' }
Parsecs >> toCellsOf: aBoard [

	^ amount * aBoard parsecsPerCell
]
