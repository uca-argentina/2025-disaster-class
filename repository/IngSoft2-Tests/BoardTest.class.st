Class {
	#name : #BoardTest,
	#superclass : #TestCase,
	#category : 'IngSoft2-Tests'
}

{ #category : #'as yet unclassified' }
BoardTest >> test001IfCreatedMapIsSizeOfAllocatedValueThenIsValid [

	| aNumberOfCells aBoard |
	aNumberOfCells := 20.
	aBoard := aBoard := Board with: 20 withWormholesAt: 2 And: 4.
	self assert: aBoard size equals: aNumberOfCells

]

{ #category : #'as yet unclassified' }
BoardTest >> test002FirstElementIsACell [

	| aBoard |
	aBoard := aBoard := Board with: 20 withWormholesAt: 2 And: 4.
	self assert: ((aBoard cellAt: 1) isKindOf: RegularCell)

]

{ #category : #'as yet unclassified' }
BoardTest >> test003AllElementsAreCellsThenIsValid [

	| aBoard |
	aBoard := aBoard := Board with: 20 withWormholesAt: 2 And: 4.

	self assert: ((1 to: aBoard size) allSatisfy: [ :i | (aBoard cellAt: i) isKindOf: Cell ]).



]

{ #category : #'as yet unclassified' }
BoardTest >> test004AddShipAtFirstCellOfBoardAndShipIsThere [

	| aBoard aShip aCell |
	aBoard := aBoard := Board with: 20 withWormholesAt: 2 And: 4.
	aShip := Ship new.
	aCell := aBoard cellAt: 1.
	aCell enters: aShip.
	self assert: ((aCell getShips at: 1) isKindOf: Ship)
]
