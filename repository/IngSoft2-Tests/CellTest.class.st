Class {
	#name : 'CellTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
CellTest >> testIfACellContainsAShipThenIsValid [
	"si la cell contiene ships"

	| aShip aShipContainer aCell |
	aShip := Ship withName: 'Franco'.
	aShipContainer := OrderedCollection with: aShip.
	aCell := Cell with: aShipContainer.

	self assert:
		(aCell getShips anySatisfy: [ :ship | ship isKindOf: Ship ])
]

{ #category : 'tests' }
CellTest >> testIfACellContainsOnlyShipsThenIsValid [
	"si la cell solo contiene ships entonces es valido"

	| aShip aShipContainer aCell aSecondShip |
	aShip := Ship withName: 'Franco'.
	aSecondShip := Ship withName: 'Maxi'.
	aShipContainer := OrderedCollection with: aShip with: aSecondShip .
	aCell := Cell with: aShipContainer.

	self assert:
		(aCell getShips allSatisfy: [ :ship | ship isKindOf: Ship ])
]

{ #category : 'tests' }
CellTest >> testIfCellHasCollectionOfShipsThenIsValid [

	| aCollection aCell |
	aCollection := OrderedCollection new.
	aCell := Cell with: aCollection.

	self assert: aCell getShips = aCollection
]
