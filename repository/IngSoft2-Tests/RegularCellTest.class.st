Class {
	#name : #RegularCellTest,
	#superclass : #TestCase,
	#category : 'IngSoft2-Tests'
}

{ #category : #tests }
RegularCellTest >> test001IfACellIsEmptyThenIsValid [

"si la cell no contiene ships es valido"

	| aShipContainer aCell |
	aShipContainer := OrderedCollection new.
	aCell := RegularCell new.

	self assert:
		(aCell getShips isEmpty)


]

{ #category : #tests }
RegularCellTest >> test002IfCellHasCollectionOfShipsThenIsValid [

	| aCollection aCell |
	aCollection := OrderedCollection new.
	aCell := RegularCell new.

	self assert: aCell getShips equals: aCollection
]

{ #category : #tests }
RegularCellTest >> test003IfACellContainsAShipThenIsValid [
	"si la cell contiene ships"

	| aShip aCell |
	aShip := Ship new.
	aCell := RegularCell new enters: aShip.
	self assert:
		(aCell getShips anySatisfy: [ :ship | ship isKindOf: Ship ])
]

{ #category : #tests }
RegularCellTest >> test004IfACellContainsOnlyShipsThenIsValid [
	"si la cell solo contiene ships entonces es valido"

	| aShip aCell aSecondShip |
	aShip := Ship new.
	aSecondShip := Ship new.
	aCell := RegularCell new.
	aCell enters: aShip.
	aCell enters: aSecondShip.

	self assert:
		(aCell getShips allSatisfy: [ :ship | ship isKindOf: Ship ])
]

{ #category : #tests }
RegularCellTest >> test005IfAShipEntersToACellAndThenTheShipLeavesThenTheCellIsEmpty [

| aRegularCell aShip aShipContainer |
	aShipContainer := OrderedCollection new.
	aRegularCell := RegularCell new.
	aShip := Ship new.
	
	aRegularCell enters: aShip.
	aRegularCell leaves: aShip.

	self assert:
		(aRegularCell getShips isEmpty)



]

{ #category : #tests }
RegularCellTest >> test006IfTwoShipsEnterToACellAndOneShipLeavesThenTheCellIsNotEmpty [

	| aRegularCell aShip aShipContainer aSecondShip |
	aShipContainer := OrderedCollection new.
	aRegularCell := RegularCell new.
	aShip := Ship new.
	aSecondShip := Ship new.

	aRegularCell enters: aShip.
	aRegularCell enters: aSecondShip.

	aRegularCell leaves: aShip.

	self assert: aRegularCell getShips isNotEmpty
]

{ #category : #tests }
RegularCellTest >> test007TwoShipsEnterAndLeaveThenCellIsEmptyAfter [

| aRegularCell aShip aShipContainer aSecondShip |
	aShipContainer := OrderedCollection new.
	aRegularCell := RegularCell new.
	aShip := Ship new.
	aSecondShip := Ship new.
	
	aRegularCell enters: aShip.
	aRegularCell enters: aSecondShip.
	
	aRegularCell leaves: aShip.
	aRegularCell leaves: aSecondShip .
  
	self deny:
		(aRegularCell getShips anySatisfy: [:ship | ship isKindOf: Ship])



]
