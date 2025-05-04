"
Represents a cell which has the capacity to hold a ship.
"
Class {
	#name : 'RegularCell',
	#superclass : 'Cell',
	#instVars : [
		'shipContainer'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
RegularCell class >> with: aShipContainer [
	^self new initializeWith: aShipContainer.
]

{ #category : 'as yet unclassified' }
RegularCell >> enters: aShip [

	shipContainer add: aShip
]

{ #category : 'as yet unclassified' }
RegularCell >> getShips [
	^shipContainer.
]

{ #category : 'initialization' }
RegularCell >> initializeWith: aShipContainer [ 
	shipContainer := aShipContainer.
]

{ #category : 'accessing' }
RegularCell >> leaves: aShip [ 
	shipContainer remove: aShip
]
