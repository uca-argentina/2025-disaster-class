Class {
	#name : 'RegularCellTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
RegularCellTest >> testIfACellContainsAShipThenIsValid [
	"si la cell contiene ships"

	| aShip aShipContainer aCell |
	aShip := Ship withName: 'Franco'.
	aShipContainer := OrderedCollection with: aShip.
	aCell := RegularCell with: aShipContainer.

	self assert:
		(aCell getShips anySatisfy: [ :ship | ship isKindOf: Ship ])
]

{ #category : 'tests' }
RegularCellTest >> testIfACellContainsOnlyShipsThenIsValid [
	"si la cell solo contiene ships entonces es valido"

	| aShip aShipContainer aCell aSecondShip |
	aShip := Ship withName: 'Franco'.
	aSecondShip := Ship withName: 'Maxi'.
	aShipContainer := OrderedCollection with: aShip with: aSecondShip .
	aCell := RegularCell with: aShipContainer.

	self assert:
		(aCell getShips allSatisfy: [ :ship | ship isKindOf: Ship ])
]

{ #category : 'tests' }
RegularCellTest >> testIfAShipIsAddedCorrectlyAfterInitializationThenIsValid [
	"test if a ship can be added after initialization of the cell"

	| aRegularCell aShip aShipContainer |
	aShipContainer := OrderedCollection new.
	aRegularCell := RegularCell with: aShipContainer.
	aShip := Ship withName: 'Franco'.
	aRegularCell enters: aShip.

	self assert:
		(aRegularCell getShips allSatisfy: [ :ship | ship isKindOf: Ship ])
]

{ #category : 'tests' }
RegularCellTest >> testIfCellHasCollectionOfShipsThenIsValid [

	| aCollection aCell |
	aCollection := OrderedCollection new.
	aCell := RegularCell with: aCollection.

	self assert: aCell getShips = aCollection
]
