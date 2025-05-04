Class {
	#name : 'RegularCellTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
RegularCellTest >> test001IfACellIsEmptyThenIsValid [

"si la cell no contiene ships es valido"

	| aShipContainer aCell |
	aShipContainer := OrderedCollection new.
	aCell := RegularCell with: aShipContainer.

	self assert:
		(aCell getShips isEmpty)


]

{ #category : 'tests' }
RegularCellTest >> test002IfCellHasCollectionOfShipsThenIsValid [

	| aCollection aCell |
	aCollection := OrderedCollection new.
	aCell := RegularCell with: aCollection.

	self assert: aCell getShips = aCollection
]

{ #category : 'tests' }
RegularCellTest >> test003IfACellContainsAShipThenIsValid [
	"si la cell contiene ships"

	| aShip aShipContainer aCell |
	aShip := Ship withName: 'Franco'.
	aShipContainer := OrderedCollection with: aShip.
	aCell := RegularCell with: aShipContainer.

	self assert:
		(aCell getShips anySatisfy: [ :ship | ship isKindOf: Ship ])
]

{ #category : 'tests' }
RegularCellTest >> test004IfACellContainsOnlyShipsThenIsValid [
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
RegularCellTest >> test005IfAShipIsAddedCorrectlyAfterInitializationThenIsValid [
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
RegularCellTest >> test006IfAShipEntersToACellAndThenTheShipLeavesThenTheCellIsEmpty [

| aRegularCell aShip aShipContainer |
	aShipContainer := OrderedCollection new.
	aRegularCell := RegularCell with: aShipContainer.
	aShip := Ship withName: 'Franco'.
	
	aRegularCell enters: aShip.
	aRegularCell leaves: aShip.

	self assert:
		(aRegularCell getShips isEmpty)



]

{ #category : 'tests' }
RegularCellTest >> test007IfTwoShipsEnterToACellAndOneShipLeavesThenTheCellIsNotEmpty [

| aRegularCell aShip aShipContainer aSecondShip |
	aShipContainer := OrderedCollection new.
	aRegularCell := RegularCell with: aShipContainer.
	aShip := Ship withName: 'Once'.
	aSecondShip := Ship withName: 'Caldos'.
	
	aRegularCell enters: aShip.
	aRegularCell enters: aSecondShip.
	
	aRegularCell leaves: aShip.
  
	self assert:
		(aRegularCell getShips isNotEmpty)



]

{ #category : 'tests' }
RegularCellTest >> test008TwoShipsEnterAndLeaveThenCellIsEmptyAfter [

| aRegularCell aShip aShipContainer aSecondShip |
	aShipContainer := OrderedCollection new.
	aRegularCell := RegularCell with: aShipContainer.
	aShip := Ship withName: 'Once'.
	aSecondShip := Ship withName: 'Caldos'.
	
	aRegularCell enters: aShip.
	aRegularCell enters: aSecondShip.
	
	aRegularCell leaves: aShip.
	aRegularCell leaves: aSecondShip .
  
	self deny:
		(aRegularCell getShips anySatisfy: [:ship | ship isKindOf: Ship])



]

{ #category : 'tests' }
RegularCellTest >> testRandom [

| aRegularCell aShip aShipContainer aSecondShip |
	aShipContainer := OrderedCollection new.
	aRegularCell := RegularCell with: aShipContainer.
	aShip := Ship withName: 'Once'.
	aSecondShip := Ship withName: 'Caldos'.
	
	aRegularCell enters: aShip.
	aRegularCell enters: aSecondShip.
	
	aRegularCell leaves: aShip.
	aRegularCell leaves: aSecondShip .
  
	self deny:
		(aRegularCell getShips anySatisfy: [:ship | ship isKindOf: Ship])



]
