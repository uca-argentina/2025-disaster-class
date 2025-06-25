Class {
	#name : 'TurnManager',
	#superclass : 'Object',
	#instVars : [
		'ships',
		'shipTurnIndex'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
TurnManager class >> withShips: someShips [

	^ self new initializeWithShips: someShips
]

{ #category : 'initialization' }
TurnManager >> advanceToNextPlayer [

	shipTurnIndex := shipTurnIndex \\ ships size + 1
]

{ #category : 'initialization' }
TurnManager >> currentTurnsShip [

	^ ships at: shipTurnIndex
]

{ #category : 'initialization' }
TurnManager >> initializeWithShips: someShips [

	ships := someShips.
	shipTurnIndex := 1.
	^ self
]
