Class {
	#name : 'ShipTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
ShipTest >> test001IfAShipIsCreatedWithTheGivenNameThenIsValid [

	| aShipName aShip |
	aShipName := 'Frankito'.
	aShip := Ship withName: aShipName.

	self assert: aShip getName equals: aShipName
]
