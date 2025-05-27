Class {
	#name : #BoardTest,
	#superclass : #TestCase,
	#category : 'IngSoft2-Tests'
}

{ #category : #'as yet unclassified' }
BoardTest >> test001IfCreatedMapIsSizeOfAllocatedValueThenIsValid [

	| aNumberOfCells aBoard cells |
	aNumberOfCells := 20.
	cells := (1 to: aNumberOfCells) collect: [ :i | RegularCell new ].
	WormholeCell newPairIn: cells at: 2 and: 4.
	aBoard := Board withCells: cells.

	self assert: aBoard size equals: aNumberOfCells
]

{ #category : #'as yet unclassified' }
BoardTest >> test002FirstElementIsACell [

	| aBoard cells |
	cells := (1 to: 20) collect: [ :i | RegularCell new ].
	WormholeCell newPairIn: cells at: 2 and: 4.
	aBoard := Board withCells: cells.

	self assert: ((aBoard cellAt: 1) isKindOf: RegularCell)
]

{ #category : #'as yet unclassified' }
BoardTest >> test003AllElementsAreCellsThenIsValid [

	| aBoard cells |
	cells := (1 to: 20) collect: [ :i | RegularCell new ].
	WormholeCell newPairIn: cells at: 2 and: 4.
	aBoard := Board withCells: cells.

	self assert: ((1 to: aBoard size) allSatisfy: [ :i |
			 (aBoard cellAt: i) isKindOf: Cell ])
]

{ #category : #'as yet unclassified' }
BoardTest >> test004AddShipAtFirstCellOfBoardAndShipIsThere [

	| aBoard aShip aCell cells |
	cells := (1 to: 20) collect: [ :i | RegularCell new ].
	WormholeCell newPairIn: cells at: 2 and: 4.
	aBoard := Board withCells: cells.

	aShip := Ship new.
	aCell := aBoard cellAt: 1.
	aCell enters: aShip.

	self assert: ((aCell getShips at: 1) isKindOf: Ship)
]
