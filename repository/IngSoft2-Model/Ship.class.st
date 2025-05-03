Class {
	#name : 'Ship',
	#superclass : 'Object',
	#instVars : [
		'name'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Ship class >> withName: aShipName [

	^ self new initializeWith: aShipName
]

{ #category : 'private' }
Ship >> getName [
	^name
]

{ #category : 'initialization' }
Ship >> initializeWith: aShipName [ 
	name := aShipName.
]
