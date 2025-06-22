Class {
	#name : 'CardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
CardTest >> test001UsingAccelerationIncreasesDiceAdjustmentOfAllShips [

	| die game shipA shipB accelerationCard generator boardSize |

	boardSize := 10.
	die := TestDie withRolls: #(4). 
	generator := FixedCellGenerator withAllRegularCellAmount: boardSize.

	game := SpaceShipGame
		createdWith: generator
		withWormholesAt: 1 and: 2
		forLaps: 1
		withDice: (OrderedCollection with: die)
		andShipsNamed: #('shipA' 'shipB').

	shipA := game ships detect: [ :s | s name = 'shipA' ].
	shipB := game ships detect: [ :s | s name = 'shipB' ].
	
	"shipA addCard: Acceleration new."
	
	accelerationCard := shipA findCardOfClass: Acceleration.
	self assert: accelerationCard notNil.
	
	game playTurn.
	game playTurn. 

	self assert: (game positionOfShip: shipA) equals: 6. 
	self assert: (game positionOfShip: shipB) equals: 6. "También termina en 5"


	
	accelerationCard use: game cardEnforcer from: shipA target: nil.

	
	game playTurn. 
	game playTurn. 
		
	self assert: shipA diceAdjustment equals: 1.
	self assert: (game positionOfShip: shipA) equals: 10. "5 + 5 = 10"
	self assert: (game positionOfShip: shipB) equals: 1.  

]
