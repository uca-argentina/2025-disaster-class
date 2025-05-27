Class {
	#name : 'GameTests',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
GameTests >> should: anErrorBlock raise: anErrorClass withMessageText: errorMessage [

	self
		should: anErrorBlock
		raise: anErrorClass
		withExceptionDo: [ :error |
		self assert: error messageText equals: errorMessage ]
]

{ #category : 'tests' }
GameTests >> test001IfGameIsCreatedWithABoardThenIsValid [

	| aDie aGame aBoard |
	aDie := Die with: 2.
	aBoard := Board with: 20 withWormholesAt: 2 And: 4.
	aGame := Game
		         playedIn: aBoard
		         with: aDie
		         andShipsNamed: #( 'Apollo' ).

	self assert: aGame board equals: aBoard
]

{ #category : 'tests' }
GameTests >> test002IfGameIsCreatedWithASingleDieThenIsValid [

	| aDie aGame aBoard someShips |
	someShips := OrderedCollection with: Ship new.
	aDie := Die with: 2.
	aBoard := aBoard := Board with: 20 withWormholesAt: 2 And: 4.
	aGame := Game playedIn: aBoard with: aDie andShipsNamed: someShips.

	self assert: aGame dice equals: aDie
]

{ #category : 'tests' }
GameTests >> test003IfGameIsCreatedWithAShipThenIsValid [

	| aDie aGame aBoard |
	aDie := Die with: 2.
	aBoard := Board with: 20 withWormholesAt: 2 And: 4.
	aGame := Game
		         playedIn: aBoard
		         with: aDie
		         andShipsNamed: #( 'Apollo' ).

	self assert:
		(aGame ships anySatisfy: [ :ship | ship name = 'Apollo' ])
]

{ #category : 'tests' }
GameTests >> test004IfGameIsCreatedWithMultipleShipsThenIsValid [

	| aDie aGame aBoard |
	aDie := Die with: 2.
	aBoard := Board with: 20 withWormholesAt: 2 And: 4.
	aGame := Game
		         playedIn: aBoard
		         with: aDie
		         andShipsNamed: #( 'Apollo' 'Orion' ).

	self assert:
		(aGame ships anySatisfy: [ :ship | ship name = 'Apollo' ]).
	self assert:
		(aGame ships anySatisfy: [ :ship | ship name = 'Orion' ])
]

{ #category : 'tests' }
GameTests >> test005IfGameIsCreatedThenAllShipsAreAtCell1 [

	| aDie aBoard aGame positions |
	aDie := Die with: 2.
	aBoard := Board with: 20 withWormholesAt: 2 And: 4.
	aGame := Game
		         playedIn: aBoard
		         with: aDie
		         andShipsNamed: #( 'Apollo' 'Orion' ).
	positions := aGame positions.

	self assert: (positions values allSatisfy: [ :pos | pos = 1 ])
]

{ #category : 'tests' }
GameTests >> test006IfPlayTurnMovesShipOneSpaceThenIsValid [

	| aDie aGame aBoard positionsBefore positionsAfter |
	aDie := OrderedCollection with: (TestDie withForcedRoll: 1).
	aBoard := Board with: 20 withWormholesAt: 10 And: 18.
	aGame := Game
		         playedIn: aBoard
		         with: aDie
		         andShipsNamed: #( 'Apollo' 'Orion' ).

	positionsBefore := aGame positions.

	self assert: (positionsBefore at: 'Apollo') equals: 1.
	self assert: (positionsBefore at: 'Orion') equals: 1.

	aGame playTurn.

	positionsAfter := aGame positions.

	self assert: (positionsAfter at: 'Apollo') equals: 2.
	self assert: (positionsAfter at: 'Orion') equals: 1
]

{ #category : 'tests' }
GameTests >> test007IfPlayTurnTwiceMovesSecondShipThenIsValid [

	| aDie aBoard game positionsAfterTurn2 |
	aDie := OrderedCollection with: (TestDie withForcedRoll: 2).
	aBoard := Board with: 20 withWormholesAt: 2 And: 4.
	game := Game
		        playedIn: aBoard
		        with: aDie
		        andShipsNamed: #( 'Apollo' 'Orion' ).

	self assert: (game positions at: 'Apollo') equals: 1.
	self assert: (game positions at: 'Orion') equals: 1.

	game playTurn.
	game playTurn.

	positionsAfterTurn2 := game positions.

	self assert: (positionsAfterTurn2 at: 'Apollo') equals: 3.
	self assert: (positionsAfterTurn2 at: 'Orion') equals: 3
]

{ #category : 'tests' }
GameTests >> test008IfShipFallsIntoWormholeThenIsTransportedToOtherEndThenIsValid [

	| aDie aBoard aGame positionsAfter |
	aDie := OrderedCollection with: (TestDie withForcedRoll: 1).
	aBoard := Board with: 20 withWormholesAt: 2 And: 4.
	aGame := Game
		         playedIn: aBoard
		         with: aDie
		         andShipsNamed: #( 'Apollo' ).

	aGame playTurn.

	positionsAfter := aGame positions.

	self assert: (positionsAfter at: 'Apollo') equals: 4
]

{ #category : 'tests' }
GameTests >> test009IfRollDiceMovesShipAccordinglyThenIsValid [

	| aDie aBoard aGame positionsBefore positionsAfter |
	aDie := OrderedCollection with: (TestDie withForcedRoll: 3).
	aBoard := Board with: 20 withWormholesAt: 10 And: 18.
	aGame := Game
		         playedIn: aBoard
		         with: aDie
		         andShipsNamed: #( 'Apollo' ).

	positionsBefore := aGame positions.

	self assert: (positionsBefore at: 'Apollo') equals: 1.

	aGame playTurn.

	positionsAfter := aGame positions.

	self assert: (positionsAfter at: 'Apollo') equals: 4
]

{ #category : 'tests' }
GameTests >> test010GameIsOverWhenShipCompletesTheRequiredLaps [

	| aDie aBoard aGame |
	aDie := OrderedCollection with: (TestDie withForcedRoll: 20).
	aBoard := Board with: 20 withWormholesAt: 10 And: 18.
	aGame := Game
		         playedIn: aBoard
		         with: aDie
		         andShipsNamed: #( 'Apollo' )
		         numberOfLaps: 1.

	self deny: aGame isOver.

	aGame playTurn.

	self assert: aGame isOver
]

{ #category : 'tests' }
GameTests >> test011GameIsNotOverWhenNoShipHasReachedTheEnd [

	| die board game |
	die := OrderedCollection with: (TestDie withForcedRoll: 1).
	board := Board with: 20 withWormholesAt: 2 And: 4.
	game := Game playedIn: board with: die andShipsNamed: #( 'Apollo' ).

	self deny: game isOver.

	game playTurn.

	self deny: game isOver
]

{ #category : 'tests' }
GameTests >> test012IfShipReachesLastCellThenWinnerIsThatShip [

	| die board game |
	die := OrderedCollection with: (TestDie withForcedRoll: 20).
	board := Board with: 20 withWormholesAt: 10 And: 18.
	game := Game
		        playedIn: board
		        with: die
		        andShipsNamed: #('Apollo').

	self assert: game winner isNil.

	game playTurn.

	self assert: game winner name equals: 'Apollo'.

]

{ #category : 'tests' }
GameTests >> test013GameIsOverWhenThereIsAWinner [

	| die board game |
	die := OrderedCollection with: (TestDie withForcedRoll: 20).
	board := Board with: 20 withWormholesAt: 10 And: 18.
	game := Game playedIn: board with: die andShipsNamed: #('Apollo').

	self deny: game isOver.
	self assert: game winner isNil.

	game playTurn.

	self assert: game isOver.
	self assert: (game winner name) equals: 'Apollo'.
]

{ #category : 'tests' }
GameTests >> test014NoMoreTurnsAfterGameIsOverWhenLapsCompleted [

	| aDie aBoard aGame somePositions |
	aDie := TestDie withForcedRoll: 20.
	aBoard := Board with: 20 withWormholesAt: 10 And: 18.
	aGame := Game
		         playedIn: aBoard
		         with: (OrderedCollection with: aDie)
		         andShipsNamed: #( 'Apollo' )
		         numberOfLaps: 1.

	"Primer turno completa una vuelta"
	aGame playTurn.
	self assert: aGame isOver.

	"Posición después de terminar"
	somePositions := aGame positions.
	self assert: (somePositions at: 'Apollo')
		= (aBoard indexOfCellContaining: aGame ships first).

	"Intento de jugar otro turno no debe cambiar nada"
	aGame playTurn.

	self assert: aGame isOver.
	self assert: (aGame positions at: 'Apollo')
		= (aBoard indexOfCellContaining: aGame ships first).
	self assert: aGame isOver
]

{ #category : 'tests' }
GameTests >> test015IfYouCanPlayWithMultipleDieConsecutivelyThenIsValid [
	| die1 die2 dice board game positions |

	die1 := TestDie withRolls: #(6 4).
	die2 := TestDie withRolls: #(5 5).
	dice := OrderedCollection with: die1 with: die2.

	board := Board with: 20 withWormholesAt: 10 And: 18.
	game := Game
		playedIn: board
		with: dice
		andShipsNamed: #( 'Apollo' )
		numberOfLaps: 1.

	game playTurn.
	self deny: game isOver.

	positions := game positions.
	self assert: (positions at: 'Apollo') equals: 12.

	game playTurn.
	self assert: game isOver.

	positions := game positions.
	self assert: (positions at: 'Apollo') equals: 1.
	self assert: (game currentLapsFor: (game ships first)) equals: 1.

]

{ #category : 'tests' }
GameTests >> test016IfWhenGameEndsItReportsWinnerAndFinalPositionsCorrectlyThenIsValid [

	| aDie aBoard aGame somePositions |
	aDie := TestDie withForcedRoll: 20.
	aBoard := Board with: 20 withWormholesAt: 10 And: 18.
	aGame := Game
		         playedIn: aBoard
		         with: (OrderedCollection with: aDie)
		         andShipsNamed: #( 'Apollo' 'Orion' )
		         numberOfLaps: 1.

	aGame playTurn.
	self assert: aGame isOver.
	self assert: aGame winner name equals: 'Apollo'.

	somePositions := aGame positions.
	self assert: (somePositions at: 'Apollo') equals: 1.
	self assert: (somePositions at: 'Orion') equals: 1
]

{ #category : 'tests' }
GameTests >> test017WhenFirstWormholeIsGreaterThanBoardLengthThenCreationFails [

	self
		should: [ Board with: 20 withWormholesAt: 45 And: 10 ]
		raise: Error
		withMessageText:
		'Posiciones de agujeros de gusano fuera de rango: #(45 10)'

]

{ #category : 'tests' }
GameTests >> test018WhenSecondWormholeIsGreaterThanBoardLengthThenCreationFails [

	self
		should: [ Board with: 20 withWormholesAt: 10 And: 45 ]
		raise: Error
		withMessageText:
		'Posiciones de agujeros de gusano fuera de rango: #(10 45)'

]

{ #category : 'tests' }
GameTests >> test019IfWhenGameEndsPlayTurnDoesNothingThenIsValid [

	| aDie aBoard aGame somePositions |
	aDie := TestDie withForcedRoll: 21.
	aBoard := Board with: 20 withWormholesAt: 10 And: 18.
	aGame := Game
		         playedIn: aBoard
		         with: (OrderedCollection with: aDie)
		         andShipsNamed: #( 'Apollo' 'Orion' ).

	aGame playTurn.

	self assert: aGame isOver.

	somePositions := aGame positions.
	self assert: (somePositions at: 'Apollo') equals: 2.
	self assert: (somePositions at: 'Orion') equals: 1.

	aGame playTurn.

	somePositions := aGame positions.
	self assert: (somePositions at: 'Apollo') equals: 2.
	self assert: (somePositions at: 'Orion') equals: 1
]

{ #category : 'tests' }
GameTests >> test020ShipStartsWithFuelAndConsumesItPerStepMoved [

	| aDie aBoard aGame initialFuel fuelAfterTurn |
	aDie := TestDie withForcedRoll: 3.
	aBoard := Board with: 20 withWormholesAt: 10 And: 18.
	aGame := Game
		playedIn: aBoard
		with: (OrderedCollection with: aDie)
		andShipsNamed: #('Apollo').

	initialFuel := aGame fuelOf: 'Apollo'.
	self assert: initialFuel equals: 6.

	aGame playTurn.

	fuelAfterTurn := aGame fuelOf: 'Apollo'.
	self assert: fuelAfterTurn equals: 3.
]

{ #category : 'tests' }
GameTests >> test021IfShipRunsOutOfFuelThenReturnsToFirstCell [

	| die board game ship |
	die := TestDie withForcedRoll: 6.
	board := Board with: 10 withWormholesAt: 3 And: 7.
	game := Game
		        playedIn: board
		        with: (OrderedCollection with: die)
		        andShipsNamed: #( 'Apollo' ).

	ship := game ships first.
	ship consumeFuel: 12. "Simula que no tiene suficiente fuel"

	game playTurn.

	self assert: (board indexOfCellContaining: ship) equals: 1
]

{ #category : 'tests' }
GameTests >> test022IfShipRunsOutOfFuelThenLosesTwoTurns [

	| die board game ship |
	die := TestDie withForcedRoll: 6.
	board := Board with: 10 withWormholesAt: 3 And: 7.
	game := Game
		        playedIn: board
		        with: (OrderedCollection with: die)
		        andShipsNamed: #( 'Apollo' ).

	ship := game ships first.
	ship consumeFuel: 12. "Sin combustible"

	game playTurn. "Aplica penalidad (2 turnos perdidos)"

	self deny: ship canPlay. "turno 1"
	game playTurn.
	self deny: ship canPlay. "turno 2"
	game playTurn.
	self assert: ship canPlay "turno 3"
]

{ #category : 'tests' }
GameTests >> test023IfPlayerSkipsTurnThenFuelIsRestoredToMax [

	| die board game ship |
	die := TestDie withForcedRoll: 3.
	board := Board with: 10 withWormholesAt: 2 And: 4.
	game := Game
		        playedIn: board
		        with: (OrderedCollection with: die)
		        andShipsNamed: #( 'Apollo' ).

	ship := game ships first.
	ship consumeFuel: 5.
	self assert: ship fuel equals: 1. "Partía con 6 de fuel (2*dado)"

	game skipTurn.

	self assert: ship fuel equals: ship fuelCapacity
]

{ #category : 'tests' }
GameTests >> test024IfShipFallsIntoAtomicBombThenAllShipsReturnToStart [

	| die board game apollo orion |
	die := TestDie withForcedRoll: 5.
	board := Board with: 10 withWormholesAt: 3 And: 7.
	game := Game
		        playedIn: board
		        with: (OrderedCollection with: die)
		        andShipsNamed: #( 'Apollo' 'Orion' ).

	apollo := game ships detect: [ :s | s name = 'Apollo' ].
	orion := game ships detect: [ :s | s name = 'Orion' ].

	"Colocamos la bomba en la posición donde caerá Apollo"
	board getMap at: 6 put: AtomicBombCell new.

	"Permitimos que ambos se puedan mover"
	apollo consumeFuel: 1.
	orion consumeFuel: 1.

	game playTurn. "Apollo cae en la bomba"

	self assert: (board indexOfCellContaining: apollo) equals: 1.
	self assert: (board indexOfCellContaining: orion) equals: 1
]
