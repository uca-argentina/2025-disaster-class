Class {
	#name : 'Board',
	#superclass : 'Object',
	#instVars : [
		'map',
		'ships',
		'lapsToWin',
		'lengthInParsecs',
		'lapsPerShip',
		'possibleCards',
		'lastCellLanded'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
Board class >> validateIsPositive: aLengthInParsecs and: aLapCount andAlsoStart: aStart andEnd: anEnd areInBoundsOf: aBoardSize [

	aLapCount <= 0 ifTrue: [
		Error signal: 'The lap count must be positive' ].

	aLengthInParsecs <= 0 ifTrue: [
		Error signal: 'Length in parsecs must be positive' ].

	aBoardSize <= 0 ifTrue: [
		Error signal: 'Board size must be positive' ].

	(aStart between: 1 and: aBoardSize) ifFalse: [
		Error signal: 'Wormhole start position is out of bounds' ].

	(anEnd between: 1 and: aBoardSize) ifFalse: [
		Error signal: 'Wormhole end position is out of bounds' ]
]

{ #category : 'instance creation' }
Board class >> withShips: someShips boardSize: aBoardSize lengthInParsecs: aLengthInParsecs lapsToWin: aLapCount wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation cellGenerator: aCellGenerator cards: someCards [

	self
		validateIsPositive:aLengthInParsecs
		and: aLapCount
		andAlsoStart: aWormholeStartLocation
		andEnd: aWormholeEndLocation
		areInBoundsOf: aBoardSize.

	^ self new
		  initializeWith: someShips
		  lengthInParsecs: aLengthInParsecs
		  laps: aLapCount
		  wormholeStart: aWormholeStartLocation
		  wormholeEnd: aWormholeEndLocation
		  CellGenerator: aCellGenerator
		  andCards: someCards
]

{ #category : 'removing' }
Board >> anyShipCompletedAllLaps [

	^ lapsPerShip anySatisfy: [ :lapsByEachShip |
		  lapsByEachShip >= lapsToWin ]
]

{ #category : 'as yet unclassified' }
Board >> applyEffectTo: aShip [

	| cell |
	cell := self whereIs: aShip.
	cell applyEffectTo: aShip in: self.
	lastCellLanded := cell
]

{ #category : 'as yet unclassified' }
Board >> applyLastCardEffectTo: aShip [

	lastCellLanded applyEffectTo: aShip in: self
]

{ #category : 'initialization' }
Board >> incrementLapsFor: aShip [

	lapsPerShip at: aShip put: (self lapsCompletedOf: aShip) + 1
]

{ #category : 'as yet unclassified' }
Board >> indexOfCellContaining: aShip [

	^ map indexOf: (self whereIs: aShip)
]

{ #category : 'initialization' }
Board >> initializeWith: someShips lengthInParsecs: aLengthInParsecs laps: aLapCount wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation CellGenerator: aCellGenerator andCards: someCards [

	ships := someShips.
	lastCellLanded := RegularCell initialize.
	lapsToWin := aLapCount.
	lengthInParsecs := aLengthInParsecs.
	lapsPerShip := Dictionary
		               newFromKeys: ships
		               andValues: (someShips collect: [ :_ | 0 ]).
	possibleCards := someCards.
	map := aCellGenerator generate.
	WormholeCell
		newPairIn: map
		at: aWormholeStartLocation
		and: aWormholeEndLocation.
	self placeAllShipsAtStart: ships
]

{ #category : 'initialization' }
Board >> initializeWith: someShips lengthInParsecs: aLengthInParsecs laps: aLapCount wormholeStart: aWormholeStartLocation wormholeEnd: aWormholeEndLocation andCellGenerator: aCellGenerator [

	ships := someShips.
	lastCellLanded := RegularCell initialize.
	lapsToWin := aLapCount.
	lengthInParsecs := aLengthInParsecs.
	lapsPerShip := Dictionary
		               newFromKeys: ships
		               andValues: (someShips collect: [ :_ | 0 ]).
	map := aCellGenerator generate.
	WormholeCell
		newPairIn: map
		at: aWormholeStartLocation
		and: aWormholeEndLocation.
	self placeAllShipsAtStart: ships
]

{ #category : 'removing' }
Board >> insertShip: aShip at: newIndex [

	| newCell |
	newCell := map at: newIndex.
	newCell enters: aShip
]

{ #category : 'initialization' }
Board >> lapsCompletedOf: aShip [

	^ lapsPerShip at: aShip ifAbsent: [ 0 ]
]

{ #category : 'initialization' }
Board >> mapSize [

	^ map size
]

{ #category : 'as yet unclassified' }
Board >> moveAllToStart [

	self ships do: [ :ship | self moveShipToStart: ship ]
]

{ #category : 'as yet unclassified' }
Board >> moveShip: aShip by: anAmount [

	| previousIndex newIndex boardSize cellsToMove |
	cellsToMove := anAmount toCellsOf: self.
	previousIndex := self indexOfCellContaining: aShip.
	boardSize := map size.
	newIndex := previousIndex + cellsToMove - 1 \\ boardSize + 1.

	self remove: aShip at: previousIndex.
	self insertShip: aShip at: newIndex.

	previousIndex + cellsToMove - 1 // boardSize
	> (previousIndex - 1 // boardSize) ifTrue: [
		self incrementLapsFor: aShip ]
]

{ #category : 'as yet unclassified' }
Board >> moveShipToStart: aShip [

	(self whereIs: aShip) leaves: aShip.
	(map at: 1) enters: aShip
]

{ #category : 'initialization' }
Board >> parsecsPerCell [

	^ map size // lengthInParsecs
]

{ #category : 'as yet unclassified' }
Board >> placeAllShipsAtStart: someShips [

	(map at: 1) entersAll: someShips
]

{ #category : 'as yet unclassified' }
Board >> possibleCards [

	^ possibleCards
]

{ #category : 'removing' }
Board >> remove: aShip at: someIndex [

	| oldCell |
	oldCell := map at: someIndex.
	oldCell leaves: aShip
]

{ #category : 'removing' }
Board >> shipThatCompletedAllLaps [

	^ ships
		  detect: [ :ship | (self lapsCompletedOf: ship) >= lapsToWin ]
		  ifNone: [ Error signal: 'There is no winner yet' ]
]

{ #category : 'initialization' }
Board >> ships [

	^ ships
]

{ #category : 'as yet unclassified' }
Board >> whereIs: aShip [

	^ map detect: [ :each | each includes: aShip ]
		ifNone: [ self error: 'Ship not found on board' ].
]
