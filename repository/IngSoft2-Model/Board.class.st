Class {
	#name : 'Board',
	#superclass : 'Object',
	#instVars : [
		'map',
		'laps'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
Board class >> withCells: someCells [

	^ self new
		  initializeWith: someCells 
]

{ #category : 'instance creation' }
Board class >> withCells: someCells andShips: someShips [
    ^ self new initializeWith: someCells andShips: someShips
]

{ #category : 'as yet unclassified' }
Board >> applyEffectTo: aShip [

	| cell |
	cell := self cellContaining: aShip.
	cell applyEffectTo: aShip in: self
]

{ #category : 'as yet unclassified' }
Board >> cellAt: aPosition [

	^ map at: aPosition
]

{ #category : 'as yet unclassified' }
Board >> cellContaining: aShip [

	^ map detect: [ :each | each includes: aShip ]
]

{ #category : 'initialization' }
Board >> incrementLapsFor: aShip [
    laps at: aShip put: (self lapsCompletedOf: aShip) + 1
]

{ #category : 'as yet unclassified' }
Board >> indexOfCellContaining: aShip [
	^ map indexOf: (self cellContaining: aShip).
]

{ #category : 'initialization' }
Board >> initializeWith: someCells [

	map := someCells
]

{ #category : 'initialization' }
Board >> initializeWith: someCells andShips: someShips [

	map := someCells.
	laps := Dictionary newFromKeys: someShips andValues: (someShips collect: [ :_ | 0 ]).
]

{ #category : 'removing' }
Board >> insertShip: aShip at: newIndex [

	| newCell |
	newCell := map at: newIndex.
	newCell enters: aShip
]

{ #category : 'initialization' }
Board >> lapsCompletedOf: aShip [
    ^ laps at: aShip ifAbsent: [ 0 ]
]

{ #category : 'as yet unclassified' }
Board >> lastCell [
	^ map last.
]

{ #category : 'as yet unclassified' }
Board >> moveAllToStart [
    self ships do: [:ship | self moveShipToStart: ship ].
]

{ #category : 'as yet unclassified' }
Board >> moveShip: aShip steps: steps [

	aShip attemptMoveBy: steps in: self
]

{ #category : 'as yet unclassified' }
Board >> moveShipDirectly: aShip steps: steps [

	| previousIndex newIndex boardSize |
	previousIndex := self indexOfCellContaining: aShip.
	boardSize := self size.
	newIndex := previousIndex + steps - 1 \\ self size + 1.

	self remove: aShip at: previousIndex.
	self insertShip: aShip at: newIndex.

	previousIndex + steps - 1 // boardSize
	> (previousIndex - 1 // boardSize) ifTrue: [
		self incrementLapsFor: aShip ]
]

{ #category : 'as yet unclassified' }
Board >> moveShipToStart: aShip [

	| index |
	index := self indexOfCellContaining: aShip.
	(map at: index) leaves: aShip.
	(map at: 1) enters: aShip
]

{ #category : 'as yet unclassified' }
Board >> placeAllShipsAtStart: someShips [

	(map at: 1) entersAll: someShips
]

{ #category : 'removing' }
Board >> remove: aShip at: someIndex [

	| oldCell |
	oldCell := map at: someIndex.
	oldCell leaves: aShip
]

{ #category : 'initialization' }
Board >> ships [
    ^ laps keys
]

{ #category : 'as yet unclassified' }
Board >> size [
	^ map size.
]
