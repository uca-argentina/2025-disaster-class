Class {
	#name : 'Game',
	#superclass : 'Object',
	#instVars : [
		'board',
		'dice',
		'ships',
		'shipTurnIndex'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Game class >> playedIn: aBoard with: someDice andShipsNamed: someShipNames [

	^ self new
		  initializeWith: aBoard
		  and: someDice
		  andShipNames: someShipNames
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

	[ ^ (ships detect: [ :s | s name = aName ]) fuel ]
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
	board placeAllShipsAtStart: ships
]

{ #category : 'testing' }
Game >> isOver [

	^ ships anySatisfy: [ :ship | self isShipAtFinishLine: ship ]
]

{ #category : 'testing' }
Game >> isShipAtFinishLine: aShip [

	^ (self currentCellOf: aShip) = board lastCell
]

{ #category : 'accessing' }
Game >> maxDiceRoll [
	^ (dice isCollection
		ifTrue: [ dice ]
		ifFalse: [ Array with: dice ])
		sum: [ :d | d sides ]
]

{ #category : 'as yet unclassified' }
Game >> performTurnWith: aShip [

	| steps |
	steps := self rollAllDice.

	board moveShip: aShip steps: steps.

	board applyEffectTo: aShip
]

{ #category : 'as yet unclassified' }
Game >> playTurn [

	self isOver ifTrue: [ ^ nil ].

	self performTurnWith: self currentShip.

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

	^ dice sum: [ :eachDie | eachDie rollDice ]
]

{ #category : 'accessing' }
Game >> ships [

	^ ships
]

{ #category : 'testing' }
Game >> winner [

	| shipsAtEnd |
	shipsAtEnd := board lastCell getShips.
	^ shipsAtEnd isEmpty
		  ifTrue: [ nil ]
		  ifFalse: [ shipsAtEnd first ]
]
