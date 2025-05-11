Class {
	#name : #BoardTest,
	#superclass : #TestCase,
	#category : 'IngSoft2-Tests'
}

{ #category : #'as yet unclassified' }
BoardTest >> test001IfCreatedMapIsSizeOfAllocatedValueThenIsValid [

	| aNumberOfCells aBoard |
	aNumberOfCells := 20.
	aBoard := Board with: aNumberOfCells.
	self assert: aBoard getMap size equals: aNumberOfCells
]

{ #category : #'as yet unclassified' }
BoardTest >> test002FirstElementIsACell [

	| aBoard |
	aBoard := Board with: 1.
	self assert: (aBoard getMap first isKindOf: RegularCell)
]

{ #category : #'as yet unclassified' }
BoardTest >> test003AllElementsAreCellsThenIsValid [

	| aBoard |
	aBoard := Board with: 20.
	self assert:
		(aBoard getMap allSatisfy: [ :element | element isKindOf: RegularCell ])
]

{ #category : #'as yet unclassified' }
BoardTest >> test004AddShipAtFirstCellOfBoardAndShipIsThere [ 
	| aMap aBoard aShip aCell |
	aBoard := Board with: 5.
	aShip := Ship new.
	aMap := aBoard getMap.
	aCell := (aMap at:1).
	aCell enters: aShip.
	self assert: ((aCell getShips at: 1) isKindOf: Ship ).
]
