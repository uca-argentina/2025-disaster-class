Class {
	#name : 'CardEnforcer',
	#superclass : 'Object',
	#instVars : [
		'ships',
		'board',
		'activeCards',
		'turnManager',
		'nextShip',
		'lastCard',
		'lastUsedCardTarget'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
CardEnforcer class >> withShips: someShips withBoard: aBoard withTurnManager: aTurnManager [
	^self new initializeWithShips: someShips withBoard: aBoard withTurnManager: aTurnManager 
]

{ #category : 'initialization' }
CardEnforcer >> addActiveCardEffect: aCard [ 
	activeCards add: aCard


]

{ #category : 'initialization' }
CardEnforcer >> applyAccelerationEffect [

	ships do: [ :ship | ship changeDiceAdjustmentBy: 1 ]
]

{ #category : 'initialization' }
CardEnforcer >> applyLastCardEffectTo: aShip [ 

	board applyLastCardEffectTo: aShip


]

{ #category : 'initialization' }
CardEnforcer >> applyOverloadEffectTo: affectedSpaceship [

	affectedSpaceship changeDiceAdjustmentBy: -2
]

{ #category : 'initialization' }
CardEnforcer >> board [
	^board

]

{ #category : 'as yet unclassified' }
CardEnforcer >> createAlliance: aSpaceship [ 

	nextShip allyWith: aSpaceship.
	aSpaceship allyWith: nextShip

]

{ #category : 'initialization' }
CardEnforcer >> disableCardEffect: aCard [

	activeCards
		remove: aCard
		ifAbsent: [ Error signal: 'There is no such active card' ].
	aCard removeEffectsWith: self
]

{ #category : 'initialization' }
CardEnforcer >> findShip: aShipName [
	^ships detect: [ :ship | ship name = aShipName ]
		ifNone: [ Error signal: 'No ship name found' ]

]

{ #category : 'initialization' }
CardEnforcer >> initializeWithShips: someShips withBoard: aBoard withTurnManager: aTurnManager [

	ships := someShips.
	board := aBoard.
	turnManager := aTurnManager.
	activeCards := OrderedCollection new.
	lastCard := NullCard new
]

{ #category : 'initialization' }
CardEnforcer >> playCard: aCard from: aShip target: aTarget [ 
	nextShip := turnManager currentTurnsShip.
	aCard verifyCanBePlayedBy: aShip with: turnManager.
	aCard use: self from: aShip target: aTarget.
	aShip useCard: aCard.
	lastCard := aCard lastUsedCard: lastCard.
	

]

{ #category : 'initialization' }
CardEnforcer >> redoLastCardFrom: aSpaceship target: aTarget [ 
	
	nextShip := turnManager currentTurnsShip.
	lastCard verifyCanBePlayedBy: aSpaceship with: turnManager.
	lastCard use: self from: aSpaceship target: aTarget .

]

{ #category : 'initialization' }
CardEnforcer >> removeAccelerationEffect [

	ships do: [ :ship | ship changeDiceAdjustmentBy: -1 ]
]

{ #category : 'initialization' }
CardEnforcer >> turnManager [ 
	^turnManager 

]
