Class {
	#name : 'FuelBuffReward',
	#superclass : 'Reward',
	#instVars : [
		'buff'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
FuelBuffReward class >> by: anAmount [ 

	^ self new initializeWith: anAmount
]

{ #category : 'initialization' }
FuelBuffReward >> applyTo: aSpaceship [

	aSpaceship changeFuelCapacityBy: buff
]

{ #category : 'initialization' }
FuelBuffReward >> initializeWith: anAmount [ 

	buff := anAmount
]
