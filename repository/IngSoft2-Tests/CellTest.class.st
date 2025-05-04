Class {
	#name : 'CellTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
CellTest >> testIfCellHasCollectionOfShipsThenIsValid [

	| aCollection aCell |
	aCollection := OrderedCollection new.
	aCell := Cell with: aCollection.

	self assert: aCell getShips = aCollection
]
