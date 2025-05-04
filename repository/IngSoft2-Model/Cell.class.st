"
Represents a cell which has the capacity to hold a ship.
"
Class {
	#name : 'Cell',
	#superclass : 'Object',
	#instVars : [
		'shipContainer'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
Cell class >> with: aShipContainer [
	^self new initializeWith: aShipContainer.
]

{ #category : 'as yet unclassified' }
Cell >> getShips [
	^shipContainer.
]

{ #category : 'initialization' }
Cell >> initializeWith: aShipContainer [ 
	shipContainer := aShipContainer.
]
