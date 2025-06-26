Class {
	#name : 'RankingTable',
	#superclass : 'Object',
	#instVars : [
		'players',
		'gameboard'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
RankingTable class >> forPlayers: players withGameboard: aGameboard [

	^ self new initializeWith: players and: aGameboard
]

{ #category : 'initialization' }
RankingTable >> initializeWith: playersCollection and: aGameboard [

	players := playersCollection.
	gameboard := aGameboard.
]

{ #category : 'initialization' }
RankingTable >> rankings [

	| comparisonBlock sortedCollection |
	comparisonBlock := [ :a :b | a second >= b second ].
	sortedCollection := SortedCollection sortBlock: comparisonBlock.

	players do: [ :player |
		| playerPosition playerLap playerPositionObj |
		playerPosition := gameboard indexOfCellContaining: player.
		playerLap := gameboard lapsCompletedOf: player.
		playerPositionObj := Position laps: playerLap cell: playerPosition.
		sortedCollection add:
			(OrderedCollection with: player with: playerPositionObj) ].

	^ sortedCollection collect: [ :entry | entry first name ]
]
