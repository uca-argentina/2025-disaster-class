Class {
	#name : 'RewardManager',
	#superclass : 'Object',
	#instVars : [
		'rewards'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
RewardManager class >> with: aCollection [ 
	^ self new initializeWith: aCollection

]

{ #category : 'initialization' }
RewardManager >> applyTo: aShip [

	rewards atRandom applyTo: aShip
]

{ #category : 'initialization' }
RewardManager >> initializeWith: rewardsCollection [

	rewards := rewardsCollection collect: [ :each |
		           OrderedCollection
			           new: (each value * 100) asInteger
			           withAll: each key ].
	rewards := rewards flattened
]
