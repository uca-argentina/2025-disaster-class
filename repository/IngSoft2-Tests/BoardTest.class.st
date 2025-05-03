Class {
	#name : 'BoardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'as yet unclassified' }
BoardTest >> testAllElementsAreCellsThenIsValid [

	| aBoard |
	aBoard := Board with: 20.
	self assert:
		(aBoard getMap allSatisfy: [ :element | element isKindOf: Cell ])
]

{ #category : 'as yet unclassified' }
BoardTest >> testFirstElementIsACell [

	| aBoard |
	aBoard := Board with: 1.
	self assert: (aBoard getMap first isKindOf: Cell)
]

{ #category : 'as yet unclassified' }
BoardTest >> testIfCreatedMapIsSizeOfAllocatedValueThenIsValid [

	| aNumberOfCells aBoard |
	aNumberOfCells := 20.
	aBoard := Board with: aNumberOfCells.
	self assert: aBoard getMap size equals: aNumberOfCells
]
