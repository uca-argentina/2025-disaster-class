Class {
	#name : 'Game',
	#superclass : 'Object',
	#instVars : [
		'board',
		'dice',
		'ships',
		'shipTurnIndex',
		'laps',
		'numberOfLaps'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Game class >> createdWith: aCellGenerator playedOnABoardSized: aBoardSize withWormholesAt: aFirstWormholeLocation and: aSecondWormholeLocation for: aLapCount with: someDice andShipsNamed: someShipNames [

	^ self new
		  initializeWith: aBoardSize
		  using: aCellGenerator
		  withWormholesAt: aFirstWormholeLocation
		  and: aSecondWormholeLocation
		  and: someDice
		  andShipNames: someShipNames
		  andLaps: aLapCount
]

{ #category : 'as yet unclassified' }
Game class >> playedIn: aBoard with: someDice andShipsNamed: someShipNames [

	^ self new
		  initializeWith: aBoard
		  and: someDice
		  andShipNames: someShipNames
]

{ #category : 'as yet unclassified' }
Game class >> playedOnABoardSized: aBoardSize for: aLapCount with: someDice andShipsNamed: someShipNames [ 
	^ self new
		initializeWith: aBoardSize
		and: someDice
		andShipNames: someShipNames
		andLaps: aLapCount

]

{ #category : 'as yet unclassified' }
Game >> advanceToNextPlayer [

	shipTurnIndex := shipTurnIndex \\ ships size + 1
]

{ #category : 'accessing' }
Game >> board [

	^ board
]

{ #category : 'as yet unclassified' }
Game >> calculateNewPositionFor: aShip afterRolling: totalRoll [

	| currentIndex maxIndex targetIndex |
	currentIndex := self positionOfShip: aShip.
	maxIndex := board size.
	targetIndex := currentIndex + totalRoll min: maxIndex.
	^ board cellAt: targetIndex
]

{ #category : 'as yet unclassified' }
Game >> currentCellOf: aShip [

	^ board cellContaining: aShip
]

{ #category : 'as yet unclassified' }
Game >> currentLapsFor: aShip [
	^ laps at: aShip


]

{ #category : 'as yet unclassified' }
Game >> currentShip [

	^ ships at: shipTurnIndex
]

{ #category : 'accessing' }
Game >> dice [

	^ dice
]

{ #category : 'testing' }
Game >> finishLineCell [

	^ board lastCell
]

{ #category : 'as yet unclassified' }
Game >> fuelOf: aName [

	^ (ships detect: [ :s | s name = aName ]) fuel 
]

{ #category : 'initialization' }
Game >> initializeWith: aBoard and: someDice andShipNames: someShipNames [

	| ship |
	board := aBoard.
	dice := someDice.
	ships := someShipNames collect: [ :eachName |
		         ship := Ship withName: eachName and: 2 * self maxDiceRoll.
		         ship ].
	shipTurnIndex := 1.
	board placeAllShipsAtStart: ships.
	laps := Dictionary new.
	ships do: [ :s | laps at: s put: 0 ].
	numberOfLaps := 1.  "Por defecto, o podés parametrizarlo"
]

{ #category : 'initialization' }
Game >> initializeWith: aBoard and: someDice andShipNames: someShipNames andLaps: lapsCount [ 
	board := aBoard.
	dice := someDice.
	ships := someShipNames collect: [ :eachName |
		Ship withName: eachName and: 2 * self maxDiceRoll ].
	shipTurnIndex := 1.
	board placeAllShipsAtStart: ships.

	laps := Dictionary newFromKeys: ships andValues: (ships collect: [ :_ | 0 ]).
	numberOfLaps := lapsCount.

]

{ #category : 'initialization' }
Game >> initializeWith: aBoardSize using: aCellGenerator withWormholesAt: firstWormhole and: secondWormhole and: someDice andShipNames: someShipNames andLaps: aLapCount [

	| cells |
	dice := someDice.

	ships := someShipNames collect: [ :eachName |
		         Ship withName: eachName and: 2 * self maxDiceRoll ].

	cells := aCellGenerator generateCells: aBoardSize.
	WormholeCell newPairIn: cells at: firstWormhole and: secondWormhole.

	board := Board withCells: cells.
	board placeAllShipsAtStart: ships.

	shipTurnIndex := 1.
	laps := Dictionary newFromKeys: ships andValues: (ships collect: [ :_ | 0 ]).
	numberOfLaps := aLapCount
]

{ #category : 'testing' }
Game >> isOver [

	^ laps values anySatisfy: [ :count | count >= numberOfLaps ]
]

{ #category : 'testing' }
Game >> isShipAtFinishLine: aShip [

	^ (self currentCellOf: aShip) = board lastCell
]

{ #category : 'accessing' }
Game >> maxDiceRoll [
	| allDice sidesList |
	
	allDice := dice isCollection
		ifTrue: [ dice ]
		ifFalse: [ Array with: dice ].

	sidesList := allDice collect: [ :die |
		(die respondsTo: #sides)
			ifTrue: [ die sides ]
			ifFalse: [ 0 ] ].

	^ sidesList sum.
]

{ #category : 'as yet unclassified' }
Game >> performTurnWith: aShip [

	| steps previousIndex newIndex boardSize |
	steps := self rollAllDice.
	previousIndex := board indexOfCellContaining: aShip.
	boardSize := board size.

	aShip moveS: steps in: board.

	newIndex := board indexOfCellContaining: aShip.
	"Checkea que haga vuelta aunque quede en un cell mas alto q el inicial"
	(((previousIndex + steps - 1) // boardSize) > ((previousIndex - 1) // boardSize))
		ifTrue: [ self shipDidCompleteLap: aShip ].

	board applyEffectTo: aShip.
]

{ #category : 'as yet unclassified' }
Game >> playTurn [

	| ship |
	self isOver ifTrue: [ ^ nil ].

	ship := self currentShip.

	ship canPlay ifFalse: [
		ship lostATurn.
		^ self advanceToNextPlayer ].

	self performTurnWith: ship.
	self advanceToNextPlayer
]

{ #category : 'as yet unclassified' }
Game >> positionOfShip: aShip [

	^ board indexOfCellContaining: aShip
]

{ #category : 'as yet unclassified' }
Game >> positions [

	^ Dictionary newFrom:
		  (ships collect: [ :ship |
			   ship name -> (self positionOfShip: ship) ])
]

{ #category : 'as yet unclassified' }
Game >> rollAllDice [

	^ (dice collect: [ :d | d rollDice ]) sum.
]

{ #category : 'as yet unclassified' }
Game >> shipDidCompleteLap: aShip [ 
	| current |
	current := laps at: aShip.
	laps at: aShip put: current + 1.


]

{ #category : 'accessing' }
Game >> ships [

	^ ships
]

{ #category : 'as yet unclassified' }
Game >> skipTurn [

	| ship |
	ship := self currentShip.
	ship refuel.
	self advanceToNextPlayer
]

{ #category : 'testing' }
Game >> winner [

	^ laps keys
		detect: [ :ship | (laps at: ship) >= numberOfLaps ]
		ifNone: [ nil ]
]
