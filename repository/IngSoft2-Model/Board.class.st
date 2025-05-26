Class {
	#name : 'Board',
	#superclass : 'Object',
	#instVars : [
		'map'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
Board class >> with: aNumberOfCells withWormholesAt: someFirstPosition And: someSecondPosition [

	^ self new
		  initializeWith: aNumberOfCells
		  withWormholesAt: someFirstPosition
		  and: someSecondPosition
]

{ #category : 'as yet unclassified' }
Board >> applyEffectTo: aShip [

	| cell |
	cell := self cellContaining: aShip.
	cell applyEffectTo: aShip in: self
]

{ #category : 'as yet unclassified' }
Board >> cellAt: aPosition [
	^ map at: aPosition.
]

{ #category : 'as yet unclassified' }
Board >> cellContaining: aShip [

	^ map detect: [ :each | each includes: aShip ]
]

{ #category : 'accessing' }
Board >> createMapOf: aNumberOfCells withWormholesAt: someFirstPosition and: someSecondPosition using: wormholePair [
	map := OrderedCollection new: aNumberOfCells.

	1 to: aNumberOfCells do: [ :i |
		i = someFirstPosition
			ifTrue: [ map add: (wormholePair at: 1) ]
			ifFalse: [
				i = someSecondPosition
					ifTrue: [ map add: (wormholePair at: 2) ]
					ifFalse: [ map add: (RegularCell with: OrderedCollection new) ] ] ].

	^ map
]

{ #category : 'as yet unclassified' }
Board >> firstCell [
	^ map first
]

{ #category : 'as yet unclassified' }
Board >> indexOfCellContaining: aShip [
	^ map indexOf: (self cellContaining: aShip).
]

{ #category : 'initialization' }
Board >> initializeWith: aNumberOfCells withWormholesAt: someFirstPosition and: someSecondPosition [

	| wormholePair |
	wormholePair := WormholeCell createPair.
	self
		validateIf: someFirstPosition
		and: someSecondPosition
		areBetweenOneAnd: aNumberOfCells.

	map := self
		createMapOf: aNumberOfCells
		withWormholesAt: someFirstPosition
		and: someSecondPosition
		using: wormholePair.
]

{ #category : 'as yet unclassified' }
Board >> lastCell [
	^ map last.
]

{ #category : 'as yet unclassified' }
Board >> moveShip: aShip steps: aStepCount [

	| currentIndex newIndex oldCell newCell |
	currentIndex := self indexOfCellContaining: aShip.
	newIndex := (currentIndex + aStepCount - 1) \\ self size + 1.

	(oldCell := map at: currentIndex) leaves: aShip.
	(newCell := map at: newIndex) enters: aShip
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

{ #category : 'as yet unclassified' }
Board >> size [
	^ map size.
]

{ #category : 'as yet unclassified' }
Board >> validateIf: someFirstPosition and: someSecondPosition areBetweenOneAnd: aBoardLength [

	((someFirstPosition between: 1 and: aBoardLength) and:
		 (someSecondPosition between: 1 and: aBoardLength)) ifFalse: [
		Error signal: 'Posiciones de agujeros de gusano fuera de rango: '
			,
			(Array with: someFirstPosition with: someSecondPosition)
				printString ]
]
