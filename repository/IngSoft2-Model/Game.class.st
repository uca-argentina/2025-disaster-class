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
Game class >> playedIn: aBoard with: aDie and: someShips [

	^ self new initializeWith: aBoard and: aDie and: someShips
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

{ #category : 'as yet unclassified' }
Game >> finalPositions [

	^ Dictionary newFrom:
		  (ships collect: [ :ship | ship -> (self positionOfShip: ship) ])
]

{ #category : 'testing' }
Game >> finishLineCell [

	^ board lastCell
]

{ #category : 'initialization' }
Game >> initializeWith: aBoard and: someDice and: someShips [

	board := aBoard.
	dice := someDice.
	ships := someShips.
	shipTurnIndex := 1.
	board placeAllShipsAtStart: someShips
]

{ #category : 'testing' }
Game >> isOver [

	^ ships anySatisfy: [ :ship | self isShipAtFinishLine: ship ]
]

{ #category : 'testing' }
Game >> isShipAtFinishLine: aShip [

	^ (self currentCellOf: aShip) = board lastCell
]

{ #category : 'as yet unclassified' }
Game >> moveShip: aShip from: oldCell to: newCell [

	oldCell leaves: aShip.
	newCell enters: aShip
]

{ #category : 'as yet unclassified' }
Game >> performTurnWith: aShip [ 

	| oldCell newCell |

	oldCell := self currentCellOf: aShip.

	newCell := self
		calculateNewPositionFor: aShip
		afterRolling: self rollAllDice.

	self moveShip: aShip from: oldCell to: newCell.

	board applyEffectTo: aShip.


]

{ #category : 'as yet unclassified' }
Game >> playTurn [

	self isOver ifTrue: [ ^nil ].

	self performTurnWith: self currentShip.

	self advanceToNextPlayer.

]

{ #category : 'as yet unclassified' }
Game >> positionOfShip: aShip [

	^ board indexOfCellContaining: aShip
]

{ #category : 'as yet unclassified' }
Game >> rollAllDice [

	^ dice sum: [ :eachDie | eachDie rollDice ]
]

{ #category : 'testing' }
Game >> winner [

	^ ships
		  detect: [ :ship | self isShipAtFinishLine: ship ]
		  ifNone: [ nil ]
]
