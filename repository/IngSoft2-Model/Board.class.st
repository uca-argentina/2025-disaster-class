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
		  And: someSecondPosition
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

{ #category : 'as yet unclassified' }
Board >> firstCell [
	^ map first
]

{ #category : 'as yet unclassified' }
Board >> getMap [

	^ map
]

{ #category : 'as yet unclassified' }
Board >> indexOfCellContaining: aShip [
	^ map indexOf: (self cellContaining: aShip).
]

{ #category : 'initialization' }
Board >> initializeWith: aNumberOfCells withWormholesAt: pos1 And: pos2 [

	| wormholePair |
	map := OrderedCollection new: aNumberOfCells.

	1 to: aNumberOfCells do: [ :i |
	map add: (RegularCell with: OrderedCollection new) ].

	((pos1 between: 1 and: aNumberOfCells) and:
		 (pos2 between: 1 and: aNumberOfCells)) ifFalse: [
		Error signal: 'Posiciones de agujeros de gusano fuera de rango: '
			, (Array with: pos1 with: pos2) printString ].

	wormholePair := WormholeCell createPair.
	map at: pos1 put: (wormholePair at: 1).
	map at: pos2 put: (wormholePair at: 2)
]

{ #category : 'as yet unclassified' }
Board >> lastCell [
	^ map last.
]

{ #category : 'as yet unclassified' }
Board >> placeAllShipsAtStart: someShips [

	(map at: 1) entersAll: someShips
]

{ #category : 'as yet unclassified' }
Board >> size [
	^ map size.
]
