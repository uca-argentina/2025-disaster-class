"
Represents a cell which has the capacity to hold a ship.
"
Class {
	#name : 'RegularCell',
	#superclass : 'Cell',
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
RegularCell >> entersAll: someShips [
	someShips do: [:each | self enters: each ].
]
